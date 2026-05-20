import Foundation

enum CurrencyService {
    static var defaultCurrencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }

    static let commonCurrencyCodes = [
        "USD", "EUR", "GBP", "JPY", "CHF", "CAD", "AUD", "CNY", "BRL", "INR"
    ]

    static func formattedAmount(_ amount: Decimal?, currencyCode: String, locale: Locale = .current) -> String {
        guard let amount else { return "" }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        formatter.generatesDecimalNumbers = true
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }

    static func decimal(from localizedText: String, locale: Locale = .current) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: localizedText)?.decimalValue
    }
}

