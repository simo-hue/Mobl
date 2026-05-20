import Foundation

enum PurchaseSort: String, CaseIterable, Identifiable {
    case newest
    case oldest
    case warrantyExpiringSoon
    case returnExpiringSoon
    case highestPrice
    case alphabetical

    var id: String { rawValue }

    var localizationKey: String {
        "sort.\(rawValue)"
    }
}

enum ArchiveStatusFilter: String, CaseIterable, Identifiable {
    case all
    case active
    case expiringSoon
    case expired
    case archived
    case noDate

    var id: String { rawValue }

    var localizationKey: String {
        switch self {
        case .all: "filter.all"
        case .active: "status.active"
        case .expiringSoon: "status.expiringSoon"
        case .expired: "status.expired"
        case .archived: "status.archived"
        case .noDate: "status.noDate"
        }
    }
}

enum DeadlineKind: String, Identifiable {
    case warranty
    case returnWindow

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .warranty: "deadline.kind.warranty"
        case .returnWindow: "deadline.kind.return"
        }
    }

    var systemImage: String {
        switch self {
        case .warranty: "shield.checkered"
        case .returnWindow: "arrow.uturn.left.circle"
        }
    }
}

struct DeadlineItem: Identifiable {
    let id: String
    let purchase: PurchaseItem
    let kind: DeadlineKind
    let dueDate: Date
    let status: DeadlineStatus

    init(purchase: PurchaseItem, kind: DeadlineKind, dueDate: Date, status: DeadlineStatus) {
        self.id = "\(purchase.id.uuidString)-\(kind.rawValue)"
        self.purchase = purchase
        self.kind = kind
        self.dueDate = dueDate
        self.status = status
    }
}

