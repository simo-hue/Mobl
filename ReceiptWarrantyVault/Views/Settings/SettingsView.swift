import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PurchaseItem.purchaseDate, order: .reverse) private var purchases: [PurchaseItem]

    @AppStorage(AppStorageKeys.defaultWarrantyMonths) private var defaultWarrantyMonths = 24
    @AppStorage(AppStorageKeys.defaultReturnDays) private var defaultReturnDays = 14
    @AppStorage(AppStorageKeys.defaultCurrencyCode) private var defaultCurrencyCode = CurrencyService.defaultCurrencyCode
    @AppStorage(AppStorageKeys.notificationsEnabled) private var notificationsEnabled = false
    @AppStorage(AppStorageKeys.biometricLockEnabled) private var biometricLockEnabled = false
    @AppStorage(AppStorageKeys.includeDocumentsInDeviceBackup) private var includeDocumentsInDeviceBackup = true

    @State private var exportURL: URL?
    @State private var errorMessage: String?
    @State private var isConfirmingDeleteAll = false

    var body: some View {
        Form {
            Section("settings.section.defaults") {
                Stepper(value: $defaultWarrantyMonths, in: 0...120) {
                    LabeledContent("field.warrantyDuration") {
                        Text(String.localizedStringWithFormat(NSLocalizedString("form.months.format", comment: "Month count"), defaultWarrantyMonths))
                    }
                }

                Picker("settings.defaultReturnWindow", selection: $defaultReturnDays) {
                    Text("settings.return.none").tag(0)
                    ForEach([7, 14, 30, 60, 90], id: \.self) { days in
                        Text(String.localizedStringWithFormat(NSLocalizedString("form.days.format", comment: "Day count"), days))
                            .tag(days)
                    }
                }

                Picker("field.currency", selection: $defaultCurrencyCode) {
                    ForEach(CurrencyService.commonCurrencyCodes, id: \.self) { code in
                        Text(code).tag(code)
                    }
                }
            }

            Section("settings.section.privacy") {
                Toggle("settings.notifications", isOn: notificationsBinding)
                Toggle("settings.faceID", isOn: biometricBinding)
                Toggle("settings.deviceBackup", isOn: $includeDocumentsInDeviceBackup)

                NavigationLink("settings.privacy") {
                    PrivacyView()
                }

                NavigationLink("settings.legal") {
                    LegalDisclaimerView()
                }
            }

            Section("settings.section.data") {
                Button {
                    exportBackup()
                } label: {
                    Label("settings.exportData", systemImage: "square.and.arrow.up")
                }

                if let exportURL {
                    ShareLink(item: exportURL) {
                        Label("purchase.action.shareExport", systemImage: "square.and.arrow.up.on.square")
                    }
                }

                Button(role: .destructive) {
                    isConfirmingDeleteAll = true
                } label: {
                    Label("settings.deleteAll", systemImage: "trash")
                }
            }

            Section("settings.section.about") {
                NavigationLink("settings.about") {
                    AboutView()
                }

                LabeledContent("settings.version") {
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1.0")
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("tab.settings")
        .confirmationDialog("settings.deleteAll.title", isPresented: $isConfirmingDeleteAll, titleVisibility: .visible) {
            Button("settings.deleteAll.confirm", role: .destructive) {
                deleteAllData()
            }
            Button("common.cancel", role: .cancel) {}
        }
    }

    private var notificationsBinding: Binding<Bool> {
        Binding {
            notificationsEnabled
        } set: { newValue in
            if newValue {
                Task {
                    do {
                        try await NotificationScheduler().requestAuthorizationIfNeeded()
                        notificationsEnabled = true
                    } catch {
                        notificationsEnabled = false
                        errorMessage = error.localizedDescription
                    }
                }
            } else {
                notificationsEnabled = false
                for purchase in purchases {
                    NotificationScheduler().cancelNotifications(for: purchase)
                }
            }
        }
    }

    private var biometricBinding: Binding<Bool> {
        Binding {
            biometricLockEnabled
        } set: { newValue in
            if newValue {
                Task {
                    let allowed = await AuthenticationService().authenticate()
                    biometricLockEnabled = allowed
                    if !allowed {
                        errorMessage = String(localized: "settings.faceID.failed", comment: "Face ID activation failed")
                    }
                }
            } else {
                biometricLockEnabled = false
            }
        }
    }

    private func exportBackup() {
        do {
            exportURL = try BackupExportService().exportArchive(purchases: purchases)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteAllData() {
        do {
            for purchase in purchases {
                NotificationScheduler().cancelNotifications(for: purchase)
                try DocumentStorageService().deleteAttachments(for: purchase.id)
                modelContext.delete(purchase)
            }
            try modelContext.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

