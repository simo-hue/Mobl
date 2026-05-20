import SwiftUI

struct DeadlineCard: View {
    let item: DeadlineItem

    var body: some View {
        NavigationLink {
            PurchaseDetailView(purchase: item.purchase)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: item.kind.systemImage)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.tint)
                    .frame(width: 42, height: 42)
                    .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.purchase.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Text(LocalizedStringKey(item.kind.titleKey))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)

                    Text(DateFormatService.mediumDate(item.dueDate))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 8) {
                    StatusBadge(status: item.status)
                    Text(DateFormatService.relativeDays(WarrantyCalculator().daysRemaining(until: item.dueDate)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 6)
        }
        .accessibilityElement(children: .combine)
    }
}

