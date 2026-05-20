import SwiftUI

struct StatusBadge: View {
    let status: DeadlineStatus

    var body: some View {
        Label(LocalizedStringKey(status.localizationKey), systemImage: iconName)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor, in: Capsule())
            .accessibilityElement(children: .combine)
    }

    private var iconName: String {
        switch status {
        case .active: "checkmark.circle.fill"
        case .expiringSoon: "exclamationmark.triangle.fill"
        case .expired: "xmark.octagon.fill"
        case .noDate: "questionmark.circle.fill"
        case .archived: "archivebox.fill"
        }
    }

    private var foregroundColor: Color {
        switch status {
        case .active: .green
        case .expiringSoon: .orange
        case .expired: .red
        case .noDate: .secondary
        case .archived: .gray
        }
    }

    private var backgroundColor: Color {
        foregroundColor.opacity(0.14)
    }
}

