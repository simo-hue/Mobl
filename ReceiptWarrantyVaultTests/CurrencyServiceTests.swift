import XCTest
@testable import ReceiptWarrantyVault

final class CurrencyServiceTests: XCTestCase {
    func testFormatsCurrencyUsingProvidedLocaleAndCurrencyCode() {
        let value = Decimal(1249)
        let formatted = CurrencyService.formattedAmount(value, currencyCode: "USD", locale: Locale(identifier: "en_US"))

        XCTAssertTrue(formatted.contains("$"))
        XCTAssertTrue(formatted.contains("1,249"))
    }

    func testParsesLocalizedDecimal() {
        let parsed = CurrencyService.decimal(from: "1.249,50", locale: Locale(identifier: "it_IT"))

        XCTAssertEqual(parsed, Decimal(string: "1249.5"))
    }
}

