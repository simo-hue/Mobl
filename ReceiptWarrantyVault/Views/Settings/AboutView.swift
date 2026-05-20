import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                Label("app.name", systemImage: "shield.lefthalf.filled")
                Text("about.body")
                    .foregroundStyle(.secondary)
            }

            Section("settings.appLanguage") {
                Text("settings.appLanguage.body")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("settings.about")
    }
}

