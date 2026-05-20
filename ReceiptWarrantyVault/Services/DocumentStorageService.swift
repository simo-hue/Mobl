import Foundation
import UIKit
import UniformTypeIdentifiers

enum DocumentStorageError: LocalizedError {
    case cannotCreateImageData
    case missingStoredFile

    var errorDescription: String? {
        switch self {
        case .cannotCreateImageData:
            String(localized: "error.imageEncoding", comment: "Image encoding failure")
        case .missingStoredFile:
            String(localized: "error.missingFile", comment: "Stored document cannot be found")
        }
    }
}

struct PendingAttachment: Identifiable, Hashable {
    let id = UUID()
    let sourceURL: URL
    let type: AttachmentType
    let originalFileName: String?
    let mimeType: String
}

struct DocumentStorageService {
    private let fileManager: FileManager
    private let userDefaults: UserDefaults

    init(fileManager: FileManager = .default, userDefaults: UserDefaults = .standard) {
        self.fileManager = fileManager
        self.userDefaults = userDefaults
    }

    var rootURL: URL {
        get throws {
            let supportURL = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return supportURL.appending(path: "ReceiptWarrantyVault", directoryHint: .isDirectory)
        }
    }

    var attachmentsURL: URL {
        get throws {
            try rootURL.appending(path: "Attachments", directoryHint: .isDirectory)
        }
    }

    var exportsURL: URL {
        get throws {
            try rootURL.appending(path: "Exports", directoryHint: .isDirectory)
        }
    }

    func prepareDirectories() throws {
        try fileManager.createDirectory(at: try attachmentsURL, withIntermediateDirectories: true)
        try fileManager.createDirectory(at: try exportsURL, withIntermediateDirectories: true)
    }

    func storedURL(for attachment: AttachmentRecord) throws -> URL {
        let url = try attachmentsURL
            .appending(path: attachment.purchaseItemID.uuidString, directoryHint: .isDirectory)
            .appending(path: attachment.localFileName)

        guard fileManager.fileExists(atPath: url.path) else {
            throw DocumentStorageError.missingStoredFile
        }

        return url
    }

    func storeFile(
        at sourceURL: URL,
        for purchaseID: UUID,
        type: AttachmentType,
        originalFileName: String? = nil,
        mimeType: String? = nil
    ) throws -> AttachmentRecord {
        try prepareDirectories()

        let attachmentID = UUID()
        let purchaseDirectory = try attachmentsURL.appending(path: purchaseID.uuidString, directoryHint: .isDirectory)
        try fileManager.createDirectory(at: purchaseDirectory, withIntermediateDirectories: true)

        let fileExtension = sourceURL.pathExtension.isEmpty ? preferredExtension(for: mimeType) : sourceURL.pathExtension
        let localFileName = "\(attachmentID.uuidString).\(fileExtension)"
        let destinationURL = purchaseDirectory.appending(path: localFileName)

        if fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.removeItem(at: destinationURL)
        }
        try fileManager.copyItem(at: sourceURL, to: destinationURL)
        try applyProtection(to: destinationURL)

        let attributes = try? fileManager.attributesOfItem(atPath: destinationURL.path)
        let fileSize = attributes?[.size] as? Int64

        return AttachmentRecord(
            id: attachmentID,
            purchaseItemID: purchaseID,
            type: type,
            localFileName: localFileName,
            originalFileName: originalFileName ?? sourceURL.lastPathComponent,
            mimeType: mimeType ?? mimeTypeForPathExtension(fileExtension),
            fileSize: fileSize
        )
    }

    func storeImage(_ image: UIImage, for purchaseID: UUID, type: AttachmentType) throws -> AttachmentRecord {
        guard let data = image.jpegData(compressionQuality: 0.88) else {
            throw DocumentStorageError.cannotCreateImageData
        }

        try prepareDirectories()
        let attachmentID = UUID()
        let purchaseDirectory = try attachmentsURL.appending(path: purchaseID.uuidString, directoryHint: .isDirectory)
        try fileManager.createDirectory(at: purchaseDirectory, withIntermediateDirectories: true)

        let localFileName = "\(attachmentID.uuidString).jpg"
        let destinationURL = purchaseDirectory.appending(path: localFileName)
        try data.write(to: destinationURL, options: [.atomic])
        try applyProtection(to: destinationURL)

        return AttachmentRecord(
            id: attachmentID,
            purchaseItemID: purchaseID,
            type: type,
            localFileName: localFileName,
            originalFileName: "scan.jpg",
            mimeType: UTType.jpeg.preferredMIMEType ?? "image/jpeg",
            fileSize: Int64(data.count)
        )
    }

    func delete(_ attachment: AttachmentRecord) throws {
        let url = try? storedURL(for: attachment)
        if let url, fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }

    func deleteAttachments(for purchaseID: UUID) throws {
        let directory = try attachmentsURL.appending(path: purchaseID.uuidString, directoryHint: .isDirectory)
        if fileManager.fileExists(atPath: directory.path) {
            try fileManager.removeItem(at: directory)
        }
    }

    private func applyProtection(to url: URL) throws {
        try fileManager.setAttributes(
            [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
            ofItemAtPath: url.path
        )

        var mutableURL = url
        let includeInBackup = userDefaults.object(forKey: AppStorageKeys.includeDocumentsInDeviceBackup) as? Bool ?? true
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = !includeInBackup
        try mutableURL.setResourceValues(resourceValues)
    }

    private func preferredExtension(for mimeType: String?) -> String {
        guard let mimeType, let type = UTType(mimeType: mimeType) else { return "dat" }
        return type.preferredFilenameExtension ?? "dat"
    }

    private func mimeTypeForPathExtension(_ pathExtension: String) -> String {
        UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? "application/octet-stream"
    }
}
