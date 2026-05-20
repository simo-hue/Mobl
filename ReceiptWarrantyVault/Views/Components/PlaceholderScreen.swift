import SwiftUI

struct PlaceholderScreen: View {
    let titleKey: LocalizedStringKey
    let systemImage: String

    var body: some View {
        ContentUnavailableView(titleKey, systemImage: systemImage)
            .navigationTitle(titleKey)
    }
}

