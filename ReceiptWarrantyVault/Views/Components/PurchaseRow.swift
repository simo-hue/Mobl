import SwiftUI

struct PurchaseRow: View {
    let purchase: PurchaseItem

    var body: some View {
        HStack(spacing: 12) {
            categoryIcon

            VStack(alignment: .leading, spacing: 4) {
                Text(purchase.name)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    if let storeName = purchase.storeName, !storeName.isEmpty {
                        Text(storeName)
                    }
                    Text(DateFormatService.mediumDate(purchase.purchaseDate))
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)

                if let price = purchase.price {
                    Text(CurrencyService.formattedAmount(price, currencyCode: purchase.currencyCode))
                        .font(.subheadline.weight(.medium))
                }
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 8) {
                StatusBadge(status: purchase.deadlineStatus())

                if !purchase.attachments.isEmpty {
                    Label("\(purchase.attachments.count)", systemImage: "paperclip")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleAndIcon)
                }

                if let endDate = purchase.primaryWarranty?.endDate {
                    Text(DateFormatService.relativeDays(WarrantyCalculator().daysRemaining(until: endDate)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var categoryIcon: some View {
        let category = PurchaseCategory(rawValue: purchase.categoryId ?? "") ?? .other
        return Image(systemName: category.iconName)
            .font(.title3.weight(.semibold))
            .foregroundStyle(.tint)
            .frame(width: 42, height: 42)
            .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
            .accessibilityHidden(true)
    }

    private var accessibilityLabel: Text {
        Text(purchase.name)
    }
}
