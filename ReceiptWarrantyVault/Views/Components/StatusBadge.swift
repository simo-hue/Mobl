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

struct ActionRowLabel: View {
    let title: LocalizedStringKey
    let systemImage: String
    let tint: Color
    var isLoading = false

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(tint.opacity(0.14))
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .tint(tint)
                } else {
                    Image(systemName: systemImage)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(tint)
                }
            }
            .frame(width: 34, height: 34)

            Text(title)
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)

            Spacer()

            if isLoading {
                ProgressView()
                    .controlSize(.small)
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .opacity(isLoading ? 0.9 : 1)
    }
}

struct LoadingOverlayModifier: ViewModifier {
    let message: LocalizedStringKey?

    func body(content: Content) -> some View {
        content
            .overlay {
                if let message {
                    ZStack {
                        Color.black.opacity(0.18)
                            .ignoresSafeArea()

                        VStack(spacing: 14) {
                            ProgressView()
                                .controlSize(.large)
                                .tint(.accentColor)
                            Text(message)
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.18), radius: 20, y: 10)
                        .padding(24)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                }
            }
            .animation(.easeInOut(duration: 0.16), value: message != nil)
    }
}

extension View {
    func loadingOverlay(_ message: LocalizedStringKey?) -> some View {
        modifier(LoadingOverlayModifier(message: message))
    }
}
