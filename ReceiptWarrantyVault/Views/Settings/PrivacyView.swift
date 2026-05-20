import SwiftUI

struct PrivacyView: View {
    var body: some View {
        List {
            Section {
                Label("privacy.noAccount", systemImage: "person.crop.circle.badge.xmark")
                Label("privacy.noTracking", systemImage: "eye.slash")
                Label("privacy.localDocuments", systemImage: "iphone")
                Label("privacy.manualExport", systemImage: "square.and.arrow.up")
            }

            Section("settings.privacyPolicy") {
                Text("privacy.policy.body")
            }
        }
        .navigationTitle("settings.privacy")
    }
}

