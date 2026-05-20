import SwiftData
import SwiftUI

struct PurchaseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let purchase: PurchaseItem

    @State private var isEditing = false
    @State private var exportURL: URL?
    @State private var errorMessage: String?
    @State private var isConfirmingDelete = false

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

            Section("detail.section.attachments") {
                if purchase.attachments.isEmpty {
                    Text("detail.attachments.empty")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(purchase.attachments) { attachment in
                        AttachmentRow(attachment: attachment)
                    }
                }
            }

            Section("detail.section.actions") {
                Button {
                    exportPDF()
                } label: {
                    Label("purchase.action.exportPDF", systemImage: "square.and.arrow.up")
                }

                if let exportURL {
                    ShareLink(item: exportURL) {
                        Label("purchase.action.shareExport", systemImage: "square.and.arrow.up.on.square")
                    }
                }

                Button {
                    purchase.isArchived.toggle()
                    purchase.updatedAt = .now
                    try? modelContext.save()
                } label: {
                    Label(purchase.isArchived ? "purchase.action.unarchive" : "purchase.action.archive", systemImage: "archivebox")
                }

                Button(role: .destructive) {
                    isConfirmingDelete = true
                } label: {
                    Label("purchase.action.delete", systemImage: "trash")
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
        .confirmationDialog("delete.purchase.title", isPresented: $isConfirmingDelete, titleVisibility: .visible) {
            Button("delete.purchase.confirm", role: .destructive) {
                deletePurchase()
            }
            Button("common.cancel", role: .cancel) {}
        }
    }

    private func exportPDF() {
        do {
            exportURL = try PDFExportService().exportPurchaseSummary(purchase)
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

private struct AttachmentRow: View {
    let attachment: AttachmentRecord

    var body: some View {
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
