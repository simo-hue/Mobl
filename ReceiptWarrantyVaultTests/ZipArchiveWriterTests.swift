import UIKit
import UniformTypeIdentifiers
import XCTest
@testable import ReceiptWarrantyVault

final class ZipArchiveWriterTests: XCTestCase {
    func testWritesReadableStoredZipArchive() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString, directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let zipURL = directory.appending(path: "backup.zip")

        try ZipArchiveWriter().write(entries: [
            .init(path: "README.txt", data: Data("hello".utf8)),
            .init(path: "metadata.json", data: Data("{}".utf8))
        ], to: zipURL)

        let data = try Data(contentsOf: zipURL)
        XCTAssertGreaterThan(data.count, 40)
        XCTAssertTrue(data.contains(Data("README.txt".utf8)))
        XCTAssertTrue(data.contains(Data("metadata.json".utf8)))
    }

    func testDocumentStorageCopiesScannedAttachmentAndKeepsPurchaseLink() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString, directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer {
            try? FileManager.default.removeItem(at: directory)
        }

        let purchaseID = UUID()
        let sourceURL = directory.appending(path: "scan.jpg")
        let sourceData = Data("scanned receipt image data".utf8)
        try sourceData.write(to: sourceURL, options: [.atomic])

        let storage = DocumentStorageService()
        let attachment = try storage.storeFile(
            at: sourceURL,
            for: purchaseID,
            type: .receiptImage,
            originalFileName: "scan.jpg",
            mimeType: "image/jpeg"
        )
        defer {
            try? storage.deleteAttachments(for: purchaseID)
        }

        let storedURL = try storage.storedURL(for: attachment)
        XCTAssertEqual(attachment.purchaseItemID, purchaseID)
        XCTAssertEqual(attachment.type, .receiptImage)
        XCTAssertEqual(attachment.originalFileName, "scan.jpg")
        XCTAssertEqual(attachment.mimeType, "image/jpeg")
        XCTAssertEqual(try Data(contentsOf: storedURL), sourceData)
        XCTAssertEqual(attachment.fileSize, Int64(sourceData.count))
    }

    func testPhotoAttachmentBuilderCreatesReceiptImageFromGalleryData() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString, directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer {
            try? FileManager.default.removeItem(at: directory)
        }

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        let image = renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        let photoData = try image.pngData().unwrap()

        let attachment = try PhotoAttachmentBuilder().makePendingAttachment(
            from: photoData,
            suggestedTypes: [.image]
        ) { fileExtension in
            directory.appending(path: "gallery.\(fileExtension)")
        }

        XCTAssertEqual(attachment.type, .receiptImage)
        XCTAssertEqual(attachment.originalFileName, "photo.png")
        XCTAssertEqual(attachment.mimeType, "image/png")
        XCTAssertEqual(attachment.sourceURL.pathExtension, "png")
        XCTAssertEqual(try Data(contentsOf: attachment.sourceURL), photoData)
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
