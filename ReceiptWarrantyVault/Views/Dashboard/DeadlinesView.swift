import SwiftData
import SwiftUI

struct DeadlinesView: View {
    @Query(sort: \PurchaseItem.purchaseDate, order: .reverse) private var purchases: [PurchaseItem]
    @State private var isShowingForm = false

    private let calculator = WarrantyCalculator()

    var body: some View {
        List {
            if deadlineItems.isEmpty {
                ContentUnavailableView(
                    "empty.receipts.title",
                    systemImage: "doc.text.viewfinder",
                    description: Text("empty.receipts.body")
                )
                .listRowBackground(Color.clear)
            } else {
                deadlineSection("home.returnSoon", items: returnSoon)
                deadlineSection("home.warrantySoon", items: warrantySoon)
                deadlineSection("home.activeWarranties", items: activeWarranties)
                deadlineSection("home.expired", items: expired)
            }
        }
        .navigationTitle("tab.deadlines")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingForm = true
                } label: {
                    Label("common.add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingForm) {
            NavigationStack {
                PurchaseFormView()
            }
        }
    }

    @ViewBuilder
    private func deadlineSection(_ titleKey: LocalizedStringKey, items: [DeadlineItem]) -> some View {
        if !items.isEmpty {
            Section(titleKey) {
                ForEach(items) { item in
                    DeadlineCard(item: item)
                }
            }
        }
    }

    private var deadlineItems: [DeadlineItem] {
        purchases.flatMap { purchase in
            guard !purchase.isArchived else {
                return [DeadlineItem]()
            }

            var items: [DeadlineItem] = []

            if let returnWindow = purchase.primaryReturnWindow {
                items.append(.init(
                    purchase: purchase,
                    kind: .returnWindow,
                    dueDate: returnWindow.endDate,
                    status: calculator.status(for: returnWindow.endDate, soonThresholdDays: 7)
                ))
            }

            if let warranty = purchase.primaryWarranty {
                items.append(.init(
                    purchase: purchase,
                    kind: .warranty,
                    dueDate: warranty.endDate,
                    status: calculator.status(for: warranty.endDate, soonThresholdDays: 30)
                ))
            }

            return items
        }
        .sorted { $0.dueDate < $1.dueDate }
    }

    private var returnSoon: [DeadlineItem] {
        deadlineItems.filter { $0.kind == .returnWindow && $0.status == .expiringSoon }
    }

    private var warrantySoon: [DeadlineItem] {
        deadlineItems.filter { $0.kind == .warranty && $0.status == .expiringSoon }
    }

    private var activeWarranties: [DeadlineItem] {
        deadlineItems.filter { $0.kind == .warranty && $0.status == .active }
    }

    private var expired: [DeadlineItem] {
        deadlineItems.filter { $0.status == .expired }
    }
}

