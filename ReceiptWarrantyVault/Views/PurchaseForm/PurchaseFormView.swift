import SwiftData
import SwiftUI

struct PurchaseFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @AppStorage(AppStorageKeys.defaultWarrantyMonths) private var defaultWarrantyMonths = 24
    @AppStorage(AppStorageKeys.defaultReturnDays) private var defaultReturnDays = 14
    @AppStorage(AppStorageKeys.defaultCurrencyCode) private var defaultCurrencyCode = CurrencyService.defaultCurrencyCode
    @AppStorage(AppStorageKeys.notificationsEnabled) private var notificationsEnabled = false

    private let purchaseToEdit: PurchaseItem?
    private let pendingAttachments: [PendingAttachment]

    @State private var name = ""
    @State private var storeName = ""
    @State private var purchaseDate = Date()
    @State private var priceText = ""
    @State private var currencyCode = CurrencyService.defaultCurrencyCode
    @State private var categoryId = PurchaseCategory.other.id
    @State private var warrantyMonths = 24
    @State private var hasReturnWindow = true
    @State private var returnDays = 14
    @State private var serialNumber = ""
    @State private var notes = ""
    @State private var errorMessage: String?

    init(purchaseToEdit: PurchaseItem? = nil, pendingAttachments: [PendingAttachment] = []) {
        self.purchaseToEdit = purchaseToEdit
        self.pendingAttachments = pendingAttachments
    }

    var body: some View {
        Form {
            Section("form.section.purchase") {
                TextField("field.productName", text: $name)
                    .textInputAutocapitalization(.words)

                TextField("field.store", text: $storeName)
                    .textInputAutocapitalization(.words)

                DatePicker("field.purchaseDate", selection: $purchaseDate, displayedComponents: .date)

                Picker("field.category", selection: $categoryId) {
                    ForEach(PurchaseCategory.allCases) { category in
                        Label(LocalizedStringKey(category.localizationKey), systemImage: category.iconName)
                            .tag(category.id)
                    }
                }
            }

            Section("form.section.price") {
                TextField("field.price", text: $priceText)
                    .keyboardType(.decimalPad)

                Picker("field.currency", selection: $currencyCode) {
                    ForEach(CurrencyService.commonCurrencyCodes, id: \.self) { code in
                        Text(code).tag(code)
                    }
                }
            }

            Section {
                Stepper(value: $warrantyMonths, in: 0...120, step: 1) {
                    LabeledContent("field.warrantyDuration") {
                        Text(String.localizedStringWithFormat(NSLocalizedString("form.months.format", comment: "Month count"), warrantyMonths))
                    }
                }

                Toggle("field.returnWindow", isOn: $hasReturnWindow)

                if hasReturnWindow {
                    Picker("field.returnWindow", selection: $returnDays) {
                        ForEach([7, 14, 30, 60, 90], id: \.self) { days in
                            Text(String.localizedStringWithFormat(NSLocalizedString("form.days.format", comment: "Day count"), days))
                                .tag(days)
                        }
                    }
                }
            } header: {
                Text("form.section.deadlines")
            } footer: {
                Text("form.deadlines.disclaimer")
            }

            Section("form.section.details") {
                TextField("field.serialNumber", text: $serialNumber)
                    .textInputAutocapitalization(.characters)

                TextField("field.notes", text: $notes, axis: .vertical)
                    .lineLimit(3...8)
            }

            if !pendingAttachments.isEmpty {
                Section("detail.section.attachments") {
                    Label(
                        String.localizedStringWithFormat(
                            NSLocalizedString("form.pendingAttachments.format", comment: "Pending attachment count"),
                            pendingAttachments.count
                        ),
                        systemImage: "paperclip"
                    )
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle(purchaseToEdit == nil ? "purchase.add.title" : "purchase.edit.title")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("common.cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("common.save") {
                    save()
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear(perform: seedForm)
    }

    private func seedForm() {
        guard name.isEmpty else { return }

        if let purchaseToEdit {
            name = purchaseToEdit.name
            storeName = purchaseToEdit.storeName ?? ""
            purchaseDate = purchaseToEdit.purchaseDate
            priceText = purchaseToEdit.price.map { NSDecimalNumber(decimal: $0).stringValue } ?? ""
            currencyCode = purchaseToEdit.currencyCode
            categoryId = purchaseToEdit.categoryId ?? PurchaseCategory.other.id
            warrantyMonths = purchaseToEdit.primaryWarranty?.durationMonths ?? defaultWarrantyMonths
            hasReturnWindow = purchaseToEdit.primaryReturnWindow != nil
            if let returnEndDate = purchaseToEdit.primaryReturnWindow?.endDate {
                returnDays = WarrantyCalculator().daysRemaining(until: returnEndDate, today: purchaseToEdit.purchaseDate)
            } else {
                returnDays = defaultReturnDays
            }
            serialNumber = purchaseToEdit.serialNumber ?? ""
            notes = purchaseToEdit.notes ?? ""
        } else {
            warrantyMonths = defaultWarrantyMonths
            returnDays = defaultReturnDays
            currencyCode = defaultCurrencyCode
        }
    }

    private func save() {
        do {
            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            let price = CurrencyService.decimal(from: priceText)
            let purchase = purchaseToEdit ?? PurchaseItem(name: trimmedName)

            purchase.name = trimmedName
            purchase.storeName = storeName.nilIfBlank
            purchase.purchaseDate = purchaseDate
            purchase.price = price
            purchase.currencyCode = currencyCode
            purchase.categoryId = categoryId
            purchase.serialNumber = serialNumber.nilIfBlank
            purchase.notes = notes.nilIfBlank
            purchase.updatedAt = .now

            if purchaseToEdit == nil {
                modelContext.insert(purchase)
            } else {
                for warranty in purchase.warranties {
                    modelContext.delete(warranty)
                }
                for returnWindow in purchase.returnWindows {
                    modelContext.delete(returnWindow)
                }
                for rule in purchase.notificationRules {
                    modelContext.delete(rule)
                }
                purchase.warranties.removeAll()
                purchase.returnWindows.removeAll()
                purchase.notificationRules.removeAll()
            }

            if warrantyMonths > 0 {
                let warranty = WarrantyRecord(
                    purchaseItemID: purchase.id,
                    type: .commercial,
                    startDate: purchaseDate,
                    endDate: WarrantyCalculator().warrantyEndDate(from: purchaseDate, durationMonths: warrantyMonths),
                    durationMonths: warrantyMonths
                )
                warranty.purchaseItem = purchase
                purchase.warranties.append(warranty)
                modelContext.insert(warranty)
            }

            if hasReturnWindow {
                let returnWindow = ReturnWindowRecord(
                    purchaseItemID: purchase.id,
                    startDate: purchaseDate,
                    endDate: WarrantyCalculator().returnEndDate(from: purchaseDate, returnDays: returnDays)
                )
                returnWindow.purchaseItem = purchase
                purchase.returnWindows.append(returnWindow)
                modelContext.insert(returnWindow)
            }

            try importPendingAttachments(into: purchase)
            addDefaultNotificationRules(to: purchase)
            try modelContext.save()

            if notificationsEnabled {
                Task {
                    try? await NotificationScheduler().requestAuthorizationIfNeeded()
                    try? await NotificationScheduler().scheduleNotifications(for: purchase)
                }
            }

            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func importPendingAttachments(into purchase: PurchaseItem) throws {
        let storage = DocumentStorageService()
        for pendingAttachment in pendingAttachments {
            let attachment = try storage.storeFile(
                at: pendingAttachment.sourceURL,
                for: purchase.id,
                type: pendingAttachment.type,
                originalFileName: pendingAttachment.originalFileName,
                mimeType: pendingAttachment.mimeType
            )
            attachment.purchaseItem = purchase
            purchase.attachments.append(attachment)
            modelContext.insert(attachment)
        }
    }

    private func addDefaultNotificationRules(to purchase: PurchaseItem) {
        guard notificationsEnabled else { return }

        let warrantyOffsets = [30, 7, 0]
        let returnOffsets = [3, 1]

        for days in warrantyOffsets where purchase.primaryWarranty != nil {
            let rule = NotificationRuleRecord(
                purchaseItemID: purchase.id,
                targetType: .warranty,
                daysBefore: days,
                notificationIdentifier: "warranty-\(purchase.id.uuidString)-\(days)"
            )
            rule.purchaseItem = purchase
            purchase.notificationRules.append(rule)
            modelContext.insert(rule)
        }

        for days in returnOffsets where purchase.primaryReturnWindow != nil {
            let rule = NotificationRuleRecord(
                purchaseItemID: purchase.id,
                targetType: .returnWindow,
                daysBefore: days,
                notificationIdentifier: "return-\(purchase.id.uuidString)-\(days)"
            )
            rule.purchaseItem = purchase
            purchase.notificationRules.append(rule)
            modelContext.insert(rule)
        }
    }
}

private extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
