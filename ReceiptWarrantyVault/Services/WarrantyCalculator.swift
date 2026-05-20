import Foundation

struct WarrantyCalculator {
    var calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func warrantyEndDate(from purchaseDate: Date, durationMonths: Int) -> Date {
        calendar.date(byAdding: .month, value: durationMonths, to: purchaseDate) ?? purchaseDate
    }

    func returnEndDate(from purchaseDate: Date, returnDays: Int) -> Date {
        calendar.date(byAdding: .day, value: returnDays, to: purchaseDate) ?? purchaseDate
    }

    func status(for endDate: Date?, today: Date = .now, soonThresholdDays: Int) -> DeadlineStatus {
        guard let endDate else { return .noDate }

        let startOfToday = calendar.startOfDay(for: today)
        let startOfEndDate = calendar.startOfDay(for: endDate)

        if startOfEndDate < startOfToday {
            return .expired
        }

        let days = calendar.dateComponents([.day], from: startOfToday, to: startOfEndDate).day ?? 0
        return days <= soonThresholdDays ? .expiringSoon : .active
    }

    func daysRemaining(until endDate: Date, today: Date = .now) -> Int {
        let startOfToday = calendar.startOfDay(for: today)
        let startOfEndDate = calendar.startOfDay(for: endDate)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfEndDate).day ?? 0
    }
}

