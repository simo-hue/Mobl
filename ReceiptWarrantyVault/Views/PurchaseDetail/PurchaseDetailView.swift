import QuickLook
import SwiftData
import SwiftUI

struct PurchaseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let purchase: PurchaseItem
    @Query private var attachments: [AttachmentRecord]

    @State private var isEditing = false
    @State private var exportDocument: ExportDocument?
    @State private var shareDocument: ExportDocument?
    @State private var errorMessage: String?
    @State private var isConfirmingDelete = false

    init(purchase: PurchaseItem) {
        self.purchase = purchase
        let purchaseID = purchase.id
        _attachments = Query(
            filter: #Predicate<AttachmentRecord> { attachment in
                attachment.purchaseItemID == purchaseID
            },
            sort: \AttachmentRecord.createdAt,
            order: .forward
        )
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(purchase.name)
                                .font(.title2.bold())
                            if let storeName = purchase.storeName {
                                Text(storeName)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        StatusBadge(status: purchase.deadlineStatus())
                    }

                    if let price = purchase.price {
                        Text(CurrencyService.formattedAmount(price, currencyCode: purchase.currencyCode))
                            .font(.headline)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("detail.section.timeline") {
                LabeledContent("field.purchaseDate") {
                    Text(DateFormatService.mediumDate(purchase.purchaseDate))
                }

                if let warranty = purchase.primaryWarranty {
                    LabeledContent("field.warrantyEnds") {
                        Text(DateFormatService.mediumDate(warranty.endDate))
                    }
                }

                if let returnWindow = purchase.primaryReturnWindow {
                    LabeledContent("field.returnEnds") {
                        Text(DateFormatService.mediumDate(returnWindow.endDate))
                    }
                }
            }

            Section("detail.section.metadata") {
                if let category = PurchaseCategory(rawValue: purchase.categoryId ?? "") {
                    LabeledContent("field.category") {
                        Label(LocalizedStringKey(category.localizationKey), systemImage: category.iconName)
                    }
                }

                if let serialNumber = purchase.serialNumber {
                    LabeledContent("field.serialNumber") {
                        Text(serialNumber)
                    }
                }

                if let notes = purchase.notes {
                    LabeledContent("field.notes") {
                        Text(notes)
                    }
                }
            }

            PurchaseAttachmentsSection(attachments: attachments)

            Section("detail.section.actions") {
                Button {
                    exportPDF()
                } label: {
                    ActionRowLabel(title: "purchase.action.exportPDF", systemImage: "square.and.arrow.up", tint: .accentColor)
                }

                if let exportDocument {
                    Button {
                        shareDocument = exportDocument
                    } label: {
                        ActionRowLabel(
                            title: "purchase.action.shareExport",
                            systemImage: "square.and.arrow.up.on.square",
                            tint: .accentColor
                        )
                    }
                }

                Button {
                    purchase.isArchived.toggle()
                    purchase.updatedAt = .now
                    try? modelContext.save()
                } label: {
                    ActionRowLabel(
                        title: LocalizedStringKey(purchase.isArchived ? "purchase.action.unarchive" : "purchase.action.archive"),
                        systemImage: "archivebox",
                        tint: .accentColor
                    )
                }

                Button(role: .destructive) {
                    isConfirmingDelete = true
                } label: {
                    ActionRowLabel(title: "purchase.action.delete", systemImage: "trash", tint: .red)
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("detail.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("common.edit") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                PurchaseFormView(purchaseToEdit: purchase)
            }
        }
        .sheet(item: $shareDocument) { document in
            ExportShareSheet(url: document.url)
        }
        .confirmationDialog("delete.purchase.title", isPresented: $isConfirmingDelete, titleVisibility: .visible) {
            Button("delete.purchase.confirm", role: .destructive) {
                deletePurchase()
            }
            Button("common.cancel", role: .cancel) {}
        }
    }

    private func exportPDF() {
        do {
            let document = ExportDocument(url: try PDFExportService().exportPurchaseSummary(purchase, attachments: attachments))
            exportDocument = document
            shareDocument = document
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deletePurchase() {
        do {
            NotificationScheduler().cancelNotifications(for: purchase)
            try DocumentStorageService().deleteAttachments(for: purchase.id)
            modelContext.delete(purchase)
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct PurchaseAttachmentsSection: View {
    let attachments: [AttachmentRecord]
    @State private var previewDocument: PreviewDocument?
    @State private var errorMessage: String?

    var body: some View {
        Section("detail.section.attachments") {
            if attachments.isEmpty {
                Text("detail.attachments.empty")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(attachments) { attachment in
                    AttachmentRow(attachment: attachment) {
                        open(attachment)
                    }
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
        }
        .sheet(item: $previewDocument) { document in
            DocumentPreview(url: document.url)
                .ignoresSafeArea()
        }
    }

    private func open(_ attachment: AttachmentRecord) {
        do {
            previewDocument = PreviewDocument(url: try DocumentStorageService().storedURL(for: attachment))
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct AttachmentRow: View {
    let attachment: AttachmentRecord
    let onOpen: () -> Void

    var body: some View {
        HStack {
            Button(action: onOpen) {
                HStack {
                    Image(systemName: iconName)
                        .foregroundStyle(.tint)
                        .frame(width: 28)
                    VStack(alignment: .leading) {
                        Text(attachment.originalFileName ?? attachment.localFileName)
                            .lineLimit(1)
                        Text(LocalizedStringKey(attachment.type.localizationKey))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if let fileSize = attachment.fileSize {
                        Text(fileSize, format: .byteCount(style: .file))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)

            if let url = try? DocumentStorageService().storedURL(for: attachment) {
                ShareLink(item: url) {
                    Image(systemName: "square.and.arrow.up")
                        .accessibilityLabel("purchase.action.shareExport")
                }
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var iconName: String {
        switch attachment.type {
        case .receiptImage, .productPhoto:
            "photo"
        case .receiptPDF, .invoice, .warrantyDocument, .manual:
            "doc.richtext"
        case .other:
            "paperclip"
        }
    }
}

private struct PreviewDocument: Identifiable {
    let id = UUID()
    let url: URL
}

private struct DocumentPreview: UIViewControllerRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {
        context.coordinator.url = url
        controller.reloadData()
    }

    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        var url: URL

        init(url: URL) {
            self.url = url
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            url as NSURL
        }
    }
}
