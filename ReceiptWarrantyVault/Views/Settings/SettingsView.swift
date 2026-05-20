import SwiftData
import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PurchaseItem.purchaseDate, order: .reverse) private var purchases: [PurchaseItem]
    @Query(sort: \AttachmentRecord.createdAt, order: .forward) private var attachments: [AttachmentRecord]

    @AppStorage(AppStorageKeys.defaultWarrantyMonths) private var defaultWarrantyMonths = 24
    @AppStorage(AppStorageKeys.defaultReturnDays) private var defaultReturnDays = 14
    @AppStorage(AppStorageKeys.defaultCurrencyCode) private var defaultCurrencyCode = CurrencyService.defaultCurrencyCode
    @AppStorage(AppStorageKeys.notificationsEnabled) private var notificationsEnabled = false
    @AppStorage(AppStorageKeys.biometricLockEnabled) private var biometricLockEnabled = false
    @AppStorage(AppStorageKeys.includeDocumentsInDeviceBackup) private var includeDocumentsInDeviceBackup = true

    @State private var exportDocument: ExportDocument?
    @State private var shareDocument: ExportDocument?
    @State private var errorMessage: String?
    @State private var isExportingBackup = false
    @State private var activityMessage: LocalizedStringKey?
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
                    ActionRowLabel(
                        title: "settings.exportData",
                        systemImage: "square.and.arrow.up",
                        tint: .accentColor,
                        isLoading: isExportingBackup
                    )
                }
                .disabled(isExportingBackup)
                .buttonStyle(.plain)

                if let exportDocument {
                    Button {
                        shareDocument = exportDocument
                    } label: {
                        ActionRowLabel(
                            title: "purchase.action.shareExport",
                            systemImage: "square.and.arrow.up.on.square",
                            tint: .accentColor
                        )
                    }
                    .buttonStyle(.plain)
                }

                Button(role: .destructive) {
                    isConfirmingDeleteAll = true
                } label: {
                    ActionRowLabel(title: "settings.deleteAll", systemImage: "trash", tint: .red)
                }
                .buttonStyle(.plain)
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
        .sheet(item: $shareDocument) { document in
            ExportShareSheet(url: document.url)
        }
        .loadingOverlay(activityMessage)
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
        guard !isExportingBackup else { return }
        isExportingBackup = true
        activityMessage = "settings.exportData"

        Task { @MainActor in
            await Task.yield()

            do {
                let document = ExportDocument(url: try BackupExportService().exportArchive(purchases: purchases, attachments: attachments))
                exportDocument = document
                errorMessage = nil
                activityMessage = nil
                isExportingBackup = false
                shareDocument = document
            } catch {
                errorMessage = error.localizedDescription
                activityMessage = nil
                isExportingBackup = false
            }
        }
    }

    private func deleteAllData() {
        activityMessage = "settings.deleteAll"

        Task { @MainActor in
            await Task.yield()

            do {
                for purchase in purchases {
                    NotificationScheduler().cancelNotifications(for: purchase)
                    try DocumentStorageService().deleteAttachments(for: purchase.id)
                    modelContext.delete(purchase)
                }
                try modelContext.save()
                exportDocument = nil
                shareDocument = nil
                errorMessage = nil
                activityMessage = nil
            } catch {
                errorMessage = error.localizedDescription
                activityMessage = nil
            }
        }
    }
}

struct ExportDocument: Identifiable, Equatable {
    let url: URL

    var id: String {
        url.absoluteString
    }
}

struct ExportShareSheet: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
