import SwiftUI

struct ScanView: View {
    @State private var isShowingManualForm = false

    var body: some View {
        List {
            Section {
                Button {
                    isShowingManualForm = true
                } label: {
                    Label("scan.addManual", systemImage: "square.and.pencil")
                }

                NavigationLink {
                    ScannerHubView()
                } label: {
                    Label("scan.openScanner", systemImage: "doc.viewfinder")
                }
            }

            Section {
                Label("privacy.localOnly", systemImage: "lock.shield")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("tab.scan")
        .sheet(isPresented: $isShowingManualForm) {
            NavigationStack {
                PurchaseFormView()
            }
        }
    }
}

