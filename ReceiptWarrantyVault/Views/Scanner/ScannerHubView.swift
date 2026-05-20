import ImageIO
import PhotosUI
import SwiftUI
import UniformTypeIdentifiers
import VisionKit

struct ScannerHubView: View {
    @State private var isShowingScanner = false
    @State private var isShowingFileImporter = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var pendingDraft: PendingPurchaseDraft?
    @State private var errorMessage: String?

    var body: some View {
        List {
            Section {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("scanner.scanWithCamera", systemImage: "doc.viewfinder")
                }
                .disabled(!VNDocumentCameraViewController.isSupported)

                Button {
                    isShowingFileImporter = true
                } label: {
                    Label("scanner.importFiles", systemImage: "folder")
                }

                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Label("scanner.importPhotos", systemImage: "photo")
                }

                Button {
                    pendingDraft = PendingPurchaseDraft()
                } label: {
                    Label("scan.addManual", systemImage: "square.and.pencil")
                }
            } footer: {
                Text("scanner.ready.body")
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("tab.scan")
        .sheet(isPresented: $isShowingScanner) {
            DocumentScannerView { images in
                handleScannedImages(images)
            } onCancel: {
                isShowingScanner = false
            } onError: { error in
                errorMessage = error.localizedDescription
                isShowingScanner = false
            }
        }
        .sheet(item: $pendingDraft) { draft in
            NavigationStack {
                PurchaseFormView(pendingAttachments: draft.attachments)
            }
        }
        .fileImporter(
            isPresented: $isShowingFileImporter,
            allowedContentTypes: [.pdf, .image, .jpeg, .png, .heic],
            allowsMultipleSelection: true
        ) { result in
            handleFileImport(result)
        }
        .onChange(of: selectedPhotoItem) { _, item in
            guard let item else { return }
            Task {
                await handlePhotoImport(item)
            }
        }
    }

    private func handleScannedImages(_ images: [UIImage]) {
        do {
            let attachments = try images.enumerated().map { index, image in
                let data = try image.jpegData(compressionQuality: 0.88).unwrap()
                let url = try temporaryURL(fileExtension: "jpg")
                try data.write(to: url, options: [.atomic])
                return PendingAttachment(
                    sourceURL: url,
                    type: .receiptImage,
                    originalFileName: "scan-\(index + 1).jpg",
                    mimeType: "image/jpeg"
                )
            }

            isShowingScanner = false
            presentPurchaseForm(with: attachments)
        } catch {
            errorMessage = error.localizedDescription
            isShowingScanner = false
        }
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        do {
            let urls = try result.get()
            let attachments = try urls.map { sourceURL in
                let didAccess = sourceURL.startAccessingSecurityScopedResource()
                defer {
                    if didAccess {
                        sourceURL.stopAccessingSecurityScopedResource()
                    }
                }

                let copiedURL = try makeTemporaryCopy(of: sourceURL)
                let type = UTType(filenameExtension: copiedURL.pathExtension)
                return PendingAttachment(
                    sourceURL: copiedURL,
                    type: attachmentType(for: type),
                    originalFileName: sourceURL.lastPathComponent,
                    mimeType: type?.preferredMIMEType ?? "application/octet-stream"
                )
            }
            presentPurchaseForm(with: attachments)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func handlePhotoImport(_ item: PhotosPickerItem) async {
        defer {
            selectedPhotoItem = nil
        }

        do {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let attachment = try PhotoAttachmentBuilder().makePendingAttachment(
                from: data,
                suggestedTypes: item.supportedContentTypes,
                temporaryURL: temporaryURL(fileExtension:)
            )
            presentPurchaseForm(with: [attachment])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func makeTemporaryCopy(of sourceURL: URL) throws -> URL {
        let destination = try temporaryURL(fileExtension: sourceURL.pathExtension.isEmpty ? "dat" : sourceURL.pathExtension)
        if FileManager.default.fileExists(atPath: destination.path) {
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.copyItem(at: sourceURL, to: destination)
        return destination
    }

    private func temporaryURL(fileExtension: String) throws -> URL {
        FileManager.default.temporaryDirectory
            .appending(path: "\(UUID().uuidString).\(fileExtension)")
    }

    private func attachmentType(for type: UTType?) -> AttachmentType {
        guard let type else { return .other }
        if type.conforms(to: .pdf) {
            return .receiptPDF
        }
        if type.conforms(to: .image) {
            return .receiptImage
        }
        return .other
    }

    private func presentPurchaseForm(with attachments: [PendingAttachment]) {
        pendingDraft = nil
        Task { @MainActor in
            await Task.yield()
            pendingDraft = PendingPurchaseDraft(attachments: attachments)
        }
    }
}

private struct PendingPurchaseDraft: Identifiable {
    let id = UUID()
    let attachments: [PendingAttachment]

    init(attachments: [PendingAttachment] = []) {
        self.attachments = attachments
    }
}

struct PhotoAttachmentBuilder {
    func makePendingAttachment(
        from data: Data,
        suggestedTypes: [UTType],
        temporaryURL: (String) throws -> URL
    ) throws -> PendingAttachment {
        let type = imageType(from: data, suggestedTypes: suggestedTypes)
        let fileExtension = type.preferredFilenameExtension ?? "jpg"
        let url = try temporaryURL(fileExtension)
        try data.write(to: url, options: [.atomic])

        return PendingAttachment(
            sourceURL: url,
            type: .receiptImage,
            originalFileName: "photo.\(fileExtension)",
            mimeType: type.preferredMIMEType ?? "image/jpeg"
        )
    }

    private func imageType(from data: Data, suggestedTypes: [UTType]) -> UTType {
        if let detectedType = detectedImageType(from: data) {
            return detectedType
        }

        if let suggestedType = suggestedTypes.first(where: isConcreteImageType) {
            return suggestedType
        }

        return .jpeg
    }

    private func detectedImageType(from data: Data) -> UTType? {
        guard
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let typeIdentifier = CGImageSourceGetType(imageSource)
        else {
            return nil
        }

        return UTType(typeIdentifier as String)
    }

    private func isConcreteImageType(_ type: UTType) -> Bool {
        type.conforms(to: .image)
            && type.preferredFilenameExtension != nil
            && type.preferredMIMEType != nil
    }
}

private extension Optional {
    func unwrap() throws -> Wrapped {
        guard let value = self else {
            throw DocumentStorageError.cannotCreateImageData
        }
        return value
    }
}
