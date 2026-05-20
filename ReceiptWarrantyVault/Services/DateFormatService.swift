import Foundation

enum DateFormatService {
    static func mediumDate(_ date: Date, locale: Locale = .current) -> String {
        date.formatted(.dateTime.locale(locale).year().month().day())
    }

    static func relativeDays(_ days: Int) -> String {
        if days < 0 {
            return String.localizedStringWithFormat(
                NSLocalizedString("date.daysOverdue.format", comment: "Number of days after a deadline"),
                abs(days)
            )
        }

        if days == 0 {
            return String(localized: "date.dueToday", comment: "Deadline is today")
        }

        return String.localizedStringWithFormat(
            NSLocalizedString("date.daysRemaining.format", comment: "Number of days until a deadline"),
            days
        )
    }
}
