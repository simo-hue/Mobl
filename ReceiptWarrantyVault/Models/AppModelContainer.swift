import Foundation
import SwiftData

enum AppModelContainer {
    static let models: [any PersistentModel.Type] = [
        PurchaseItem.self,
        WarrantyRecord.self,
        ReturnWindowRecord.self,
        AttachmentRecord.self,
        NotificationRuleRecord.self
    ]
}

