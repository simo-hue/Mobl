import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case deadlines
    case archive
    case scan
    case settings

    var id: String { rawValue }

    @ViewBuilder
    var content: some View {
        switch self {
        case .deadlines:
            PlaceholderScreen(titleKey: "tab.deadlines", systemImage: "calendar.badge.clock")
        case .archive:
            PlaceholderScreen(titleKey: "tab.archive", systemImage: "tray.full")
        case .scan:
            PlaceholderScreen(titleKey: "tab.scan", systemImage: "doc.viewfinder")
        case .settings:
            PlaceholderScreen(titleKey: "tab.settings", systemImage: "gearshape")
        }
    }

    @ViewBuilder
    var label: some View {
        switch self {
        case .deadlines:
            Label("tab.deadlines", systemImage: "calendar.badge.clock")
        case .archive:
            Label("tab.archive", systemImage: "tray.full")
        case .scan:
            Label("tab.scan", systemImage: "doc.viewfinder")
        case .settings:
            Label("tab.settings", systemImage: "gearshape")
        }
    }
}

