import SwiftUI
import SwiftData

@main
struct ReceiptWarrantyVaultApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(for: AppModelContainer.models)
    }
}

