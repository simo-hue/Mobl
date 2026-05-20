import Foundation
import SwiftData

enum WarrantyType: String, CaseIterable, Codable, Identifiable {
    case legal
    case commercial
    case extended
    case insurance
    case custom

    var id: String { rawValue }

    var localizationKey: String {
        "warranty.type.\(rawValue)"
    }
}

enum AttachmentType: String, CaseIterable, Codable, Identifiable {
    case receiptImage
    case receiptPDF
    case invoice
    case warrantyDocument
    case productPhoto
    case manual
    case other

    var id: String { rawValue }

    var localizationKey: String {
        "attachment.type.\(rawValue)"
    }
}

enum NotificationTargetType: String, Codable, CaseIterable, Identifiable {
    case warranty
    case returnWindow

    var id: String { rawValue }
}

enum DeadlineStatus: String, CaseIterable, Identifiable {
    case active
    case expiringSoon
    case expired
    case noDate
    case archived

    var id: String { rawValue }

    var localizationKey: String {
        switch self {
        case .active: "status.active"
        case .expiringSoon: "status.expiringSoon"
        case .expired: "status.expired"
        case .noDate: "status.noDate"
        case .archived: "status.archived"
        }
    }
}

@Model
final class PurchaseItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var categoryId: String?
    var storeName: String?
    var purchaseDate: Date
    var price: Decimal?
    var currencyCode: String
    var notes: String?
    var serialNumber: String?
    var createdAt: Date
    var updatedAt: Date
    var isArchived: Bool

    @Relationship(deleteRule: .cascade, inverse: \WarrantyRecord.purchaseItem)
    var warranties: [WarrantyRecord] = []

    @Relationship(deleteRule: .cascade, inverse: \ReturnWindowRecord.purchaseItem)
    var returnWindows: [ReturnWindowRecord] = []

    @Relationship(deleteRule: .cascade, inverse: \AttachmentRecord.purchaseItem)
    var attachments: [AttachmentRecord] = []

    @Relationship(deleteRule: .cascade, inverse: \NotificationRuleRecord.purchaseItem)
    var notificationRules: [NotificationRuleRecord] = []

    init(
        id: UUID = UUID(),
        name: String,
        categoryId: String? = PurchaseCategory.other.id,
        storeName: String? = nil,
        purchaseDate: Date = .now,
        price: Decimal? = nil,
        currencyCode: String = CurrencyService.defaultCurrencyCode,
        notes: String? = nil,
        serialNumber: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        isArchived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.categoryId = categoryId
        self.storeName = storeName
        self.purchaseDate = purchaseDate
        self.price = price
        self.currencyCode = currencyCode
        self.notes = notes
        self.serialNumber = serialNumber
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isArchived = isArchived
    }
}

@Model
final class WarrantyRecord {
    @Attribute(.unique) var id: UUID
    var purchaseItemID: UUID
    var typeRawValue: String
    var startDate: Date
    var endDate: Date
    var durationMonths: Int?
    var notes: String?
    var purchaseItem: PurchaseItem?

    var type: WarrantyType {
        get { WarrantyType(rawValue: typeRawValue) ?? .custom }
        set { typeRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        purchaseItemID: UUID,
        type: WarrantyType = .commercial,
        startDate: Date,
        endDate: Date,
        durationMonths: Int? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.purchaseItemID = purchaseItemID
        self.typeRawValue = type.rawValue
        self.startDate = startDate
        self.endDate = endDate
        self.durationMonths = durationMonths
        self.notes = notes
    }
}

@Model
final class ReturnWindowRecord {
    @Attribute(.unique) var id: UUID
    var purchaseItemID: UUID
    var startDate: Date
    var endDate: Date
    var storePolicyNotes: String?
    var isCompleted: Bool
    var purchaseItem: PurchaseItem?

    init(
        id: UUID = UUID(),
        purchaseItemID: UUID,
        startDate: Date,
        endDate: Date,
        storePolicyNotes: String? = nil,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.purchaseItemID = purchaseItemID
        self.startDate = startDate
        self.endDate = endDate
        self.storePolicyNotes = storePolicyNotes
        self.isCompleted = isCompleted
    }
}

@Model
final class AttachmentRecord {
    @Attribute(.unique) var id: UUID
    var purchaseItemID: UUID
    var typeRawValue: String
    var localFileName: String
    var originalFileName: String?
    var mimeType: String
    var fileSize: Int64?
    var createdAt: Date
    var purchaseItem: PurchaseItem?

    var type: AttachmentType {
        get { AttachmentType(rawValue: typeRawValue) ?? .other }
        set { typeRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        purchaseItemID: UUID,
        type: AttachmentType,
        localFileName: String,
        originalFileName: String?,
        mimeType: String,
        fileSize: Int64?,
        createdAt: Date = .now
    ) {
        self.id = id
        self.purchaseItemID = purchaseItemID
        self.typeRawValue = type.rawValue
        self.localFileName = localFileName
        self.originalFileName = originalFileName
        self.mimeType = mimeType
        self.fileSize = fileSize
        self.createdAt = createdAt
    }
}

@Model
final class NotificationRuleRecord {
    @Attribute(.unique) var id: UUID
    var purchaseItemID: UUID
    var targetTypeRawValue: String
    var daysBefore: Int
    var isEnabled: Bool
    var notificationIdentifier: String
    var purchaseItem: PurchaseItem?

    var targetType: NotificationTargetType {
        get { NotificationTargetType(rawValue: targetTypeRawValue) ?? .warranty }
        set { targetTypeRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        purchaseItemID: UUID,
        targetType: NotificationTargetType,
        daysBefore: Int,
        isEnabled: Bool = true,
        notificationIdentifier: String
    ) {
        self.id = id
        self.purchaseItemID = purchaseItemID
        self.targetTypeRawValue = targetType.rawValue
        self.daysBefore = daysBefore
        self.isEnabled = isEnabled
        self.notificationIdentifier = notificationIdentifier
    }
}

extension PurchaseItem {
    var primaryWarranty: WarrantyRecord? {
        warranties.sorted { $0.endDate < $1.endDate }.first
    }

    var primaryReturnWindow: ReturnWindowRecord? {
        returnWindows
            .filter { !$0.isCompleted }
            .sorted { $0.endDate < $1.endDate }
            .first
    }

    func deadlineStatus(today: Date = .now, calendar: Calendar = .current) -> DeadlineStatus {
        guard !isArchived else { return .archived }
        guard let endDate = primaryWarranty?.endDate else { return .noDate }
        return WarrantyCalculator(calendar: calendar).status(for: endDate, today: today, soonThresholdDays: 30)
    }
}

