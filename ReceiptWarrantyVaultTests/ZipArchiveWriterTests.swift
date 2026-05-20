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
}

