import XCTest
@testable import ReceiptWarrantyVault

final class WarrantyCalculatorTests: XCTestCase {
    func testWarrantyEndDateHandlesLeapYear() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let calculator = WarrantyCalculator(calendar: calendar)

        let start = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 2, day: 29)))
        let end = calculator.warrantyEndDate(from: start, durationMonths: 12)
        let components = calendar.dateComponents([.year, .month, .day], from: end)

        XCTAssertEqual(components.year, 2025)
        XCTAssertEqual(components.month, 2)
        XCTAssertEqual(components.day, 28)
    }

    func testReturnEndDateAddsConfigurableDays() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let calculator = WarrantyCalculator(calendar: calendar)

        let start = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 5, day: 20)))
        let end = calculator.returnEndDate(from: start, returnDays: 30)
        let days = calendar.dateComponents([.day], from: start, to: end).day

        XCTAssertEqual(days, 30)
    }

    func testStatusUsesCalendarDayBoundaries() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let calculator = WarrantyCalculator(calendar: calendar)

        let today = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 5, day: 20, hour: 18)))
        let due = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 5, day: 21, hour: 1)))

        XCTAssertEqual(calculator.status(for: due, today: today, soonThresholdDays: 7), .expiringSoon)
    }
}

