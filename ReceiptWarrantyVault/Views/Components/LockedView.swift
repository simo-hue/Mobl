import SwiftUI

struct LockedView: View {
    let onUnlock: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield")
                .font(.system(size: 64, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text("lock.title")
                    .font(.title.bold())
                Text("lock.body")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("lock.unlock") {
                onUnlock()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(28)
    }
}

