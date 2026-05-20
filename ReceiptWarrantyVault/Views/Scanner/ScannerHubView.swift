import SwiftUI

struct ScannerHubView: View {
    var body: some View {
        ContentUnavailableView(
            "scanner.ready.title",
            systemImage: "doc.viewfinder",
            description: Text("scanner.ready.body")
        )
        .navigationTitle("tab.scan")
    }
}

