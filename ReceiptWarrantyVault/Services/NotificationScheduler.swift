import Foundation
import UserNotifications

enum NotificationSchedulerError: LocalizedError {
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            String(localized: "error.notificationsDenied", comment: "Notification permission denied")
        }
    }
}

struct NotificationScheduler {
    private let center: UNUserNotificationCenter
    private let calendar: Calendar

    init(center: UNUserNotificationCenter = .current(), calendar: Calendar = .current) {
        self.center = center
        self.calendar = calendar
    }

    func requestAuthorizationIfNeeded() async throws {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return
        case .denied:
            throw NotificationSchedulerError.permissionDenied
        case .notDetermined:
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if !granted {
                throw NotificationSchedulerError.permissionDenied
            }
        @unknown default:
            throw NotificationSchedulerError.permissionDenied
        }
    }

    func cancelNotifications(for purchase: PurchaseItem) {
        let identifiers = purchase.notificationRules.map(\.notificationIdentifier)
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func scheduleNotifications(for purchase: PurchaseItem) async throws {
        cancelNotifications(for: purchase)

        for rule in purchase.notificationRules where rule.isEnabled {
            guard let targetDate = targetDate(for: rule, purchase: purchase),
                  let notificationDate = calendar.date(byAdding: .day, value: -rule.daysBefore, to: targetDate),
                  notificationDate > .now
            else {
                continue
            }

            let content = UNMutableNotificationContent()
            content.title = title(for: rule)
            content.body = body(for: rule, purchaseName: purchase.name, daysBefore: rule.daysBefore)
            content.sound = .default

            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: rule.notificationIdentifier, content: content, trigger: trigger)
            try await center.add(request)
        }
    }

    private func targetDate(for rule: NotificationRuleRecord, purchase: PurchaseItem) -> Date? {
        switch rule.targetType {
        case .warranty:
            purchase.primaryWarranty?.endDate
        case .returnWindow:
            purchase.primaryReturnWindow?.endDate
        }
    }

    private func title(for rule: NotificationRuleRecord) -> String {
        switch rule.targetType {
        case .warranty:
            String(localized: "notification.warranty.title", comment: "Warranty notification title")
        case .returnWindow:
            String(localized: "notification.return.title", comment: "Return notification title")
        }
    }

    private func body(for rule: NotificationRuleRecord, purchaseName: String, daysBefore: Int) -> String {
        switch rule.targetType {
        case .warranty:
            return String.localizedStringWithFormat(
                NSLocalizedString("notification.warranty.body", comment: "Warranty notification body"),
                purchaseName,
                daysBefore
            )
        case .returnWindow:
            return String.localizedStringWithFormat(
                NSLocalizedString("notification.return.body", comment: "Return notification body"),
                purchaseName,
                daysBefore
            )
        }
    }
}

