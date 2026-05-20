import Foundation

enum PurchaseCategory: String, CaseIterable, Identifiable, Codable {
    case electronics
    case appliances
    case home
    case kitchen
    case furniture
    case clothing
    case tools
    case sports
    case toys
    case automotive
    case documents
    case other

    var id: String { rawValue }

    var localizationKey: String {
        "category.\(rawValue)"
    }

    var iconName: String {
        switch self {
        case .electronics: "desktopcomputer"
        case .appliances: "washer"
        case .home: "house"
        case .kitchen: "fork.knife"
        case .furniture: "sofa"
        case .clothing: "tshirt"
        case .tools: "wrench.and.screwdriver"
        case .sports: "figure.run"
        case .toys: "teddybear"
        case .automotive: "car"
        case .documents: "doc.text"
        case .other: "shippingbox"
        }
    }
}

