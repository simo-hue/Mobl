import Foundation

struct BackupExportService {
    private let storage: DocumentStorageService
    private let zipWriter: ZipArchiveWriter

    init(storage: DocumentStorageService = DocumentStorageService(), zipWriter: ZipArchiveWriter = ZipArchiveWriter()) {
        self.storage = storage
        self.zipWriter = zipWriter
    }

    func exportArchive(purchases: [PurchaseItem], attachments: [AttachmentRecord]? = nil) throws -> URL {
        try storage.prepareDirectories()

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let attachmentsByPurchaseID = Dictionary(grouping: attachments ?? purchases.flatMap(\.attachments), by: \.purchaseItemID)
        let export = purchases.map { purchase in
            PurchaseExport(purchase, attachments: attachmentsByPurchaseID[purchase.id] ?? [])
        }
        let metadata = try encoder.encode(export)
        let readme = Data(backupReadme.utf8)

        var entries: [ZipArchiveWriter.Entry] = [
            .init(path: "metadata.json", data: metadata),
            .init(path: "README.txt", data: readme)
        ]

        for purchase in purchases {
            for attachment in attachmentsByPurchaseID[purchase.id] ?? [] {
                if let sourceURL = try? storage.storedURL(for: attachment),
                   let data = try? Data(contentsOf: sourceURL) {
                    entries.append(.init(path: "attachments/\(purchase.id.uuidString)/\(attachment.localFileName)", data: data))
                }
            }
        }

        let outputURL = try storage.exportsURL.appending(path: "WarrantyVault-Backup-\(Self.timestamp()).zip")
        try zipWriter.write(entries: entries, to: outputURL)
        return outputURL
    }

    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: .now)
    }

    private var backupReadme: String {
        """
        Warranty Vault backup

        This archive was created locally on the device after a manual export action.
        It contains metadata.json and any stored files under attachments/.
        The app developer does not receive this backup.
        """
    }
}

private struct PurchaseExport: Encodable {
    let id: UUID
    let name: String
    let categoryId: String?
    let storeName: String?
    let purchaseDate: Date
    let price: Decimal?
    let currencyCode: String
    let notes: String?
    let serialNumber: String?
    let createdAt: Date
    let updatedAt: Date
    let isArchived: Bool
    let warranties: [WarrantyExport]
    let returnWindows: [ReturnWindowExport]
    let attachments: [AttachmentExport]

    init(_ item: PurchaseItem, attachments attachmentRecords: [AttachmentRecord]) {
        id = item.id
        name = item.name
        categoryId = item.categoryId
        storeName = item.storeName
        purchaseDate = item.purchaseDate
        price = item.price
        currencyCode = item.currencyCode
        notes = item.notes
        serialNumber = item.serialNumber
        createdAt = item.createdAt
        updatedAt = item.updatedAt
        isArchived = item.isArchived
        warranties = item.warranties.map(WarrantyExport.init)
        returnWindows = item.returnWindows.map(ReturnWindowExport.init)
        attachments = attachmentRecords.map(AttachmentExport.init)
    }
}

private struct WarrantyExport: Encodable {
    let id: UUID
    let purchaseItemID: UUID
    let type: String
    let startDate: Date
    let endDate: Date
    let durationMonths: Int?
    let notes: String?

    init(_ record: WarrantyRecord) {
        id = record.id
        purchaseItemID = record.purchaseItemID
        type = record.typeRawValue
        startDate = record.startDate
        endDate = record.endDate
        durationMonths = record.durationMonths
        notes = record.notes
    }
}

private struct ReturnWindowExport: Encodable {
    let id: UUID
    let purchaseItemID: UUID
    let startDate: Date
    let endDate: Date
    let storePolicyNotes: String?
    let isCompleted: Bool

    init(_ record: ReturnWindowRecord) {
        id = record.id
        purchaseItemID = record.purchaseItemID
        startDate = record.startDate
        endDate = record.endDate
        storePolicyNotes = record.storePolicyNotes
        isCompleted = record.isCompleted
    }
}

private struct AttachmentExport: Encodable {
    let id: UUID
    let purchaseItemID: UUID
    let type: String
    let localFileName: String
    let originalFileName: String?
    let mimeType: String
    let fileSize: Int64?
    let createdAt: Date

    init(_ record: AttachmentRecord) {
        id = record.id
        purchaseItemID = record.purchaseItemID
        type = record.typeRawValue
        localFileName = record.localFileName
        originalFileName = record.originalFileName
        mimeType = record.mimeType
        fileSize = record.fileSize
        createdAt = record.createdAt
    }
}
