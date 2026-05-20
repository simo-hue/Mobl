import SwiftData
import SwiftUI

struct ArchiveView: View {
    @Query(sort: \PurchaseItem.purchaseDate, order: .reverse) private var purchases: [PurchaseItem]
    @State private var searchText = ""
    @State private var selectedCategoryId: String?
    @State private var statusFilter: ArchiveStatusFilter = .all
    @State private var sort: PurchaseSort = .newest
    @State private var isShowingForm = false

    var body: some View {
        List {
            if filteredPurchases.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(filteredPurchases) { purchase in
                    NavigationLink {
                        PurchaseDetailView(purchase: purchase)
                    } label: {
                        PurchaseRow(purchase: purchase)
                    }
                }
            }
        }
        .navigationTitle("tab.archive")
        .searchable(text: $searchText, prompt: "archive.search")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Picker("filter.category", selection: $selectedCategoryId) {
                        Text("filter.all").tag(String?.none)
                        ForEach(PurchaseCategory.allCases) { category in
                            Label(LocalizedStringKey(category.localizationKey), systemImage: category.iconName)
                                .tag(String?.some(category.id))
                        }
                    }

                    Picker("filter.status", selection: $statusFilter) {
                        ForEach(ArchiveStatusFilter.allCases) { filter in
                            Text(LocalizedStringKey(filter.localizationKey)).tag(filter)
                        }
                    }

                    Picker("sort.title", selection: $sort) {
                        ForEach(PurchaseSort.allCases) { sort in
                            Text(LocalizedStringKey(sort.localizationKey)).tag(sort)
                        }
                    }
                } label: {
                    Label("archive.filters", systemImage: "line.3.horizontal.decrease.circle")
                }
            }

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

    private var filteredPurchases: [PurchaseItem] {
        purchases
            .filter(matchesSearch)
            .filter(matchesCategory)
            .filter(matchesStatus)
            .sorted(by: sortPredicate)
    }

    private func matchesSearch(_ purchase: PurchaseItem) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }

        let fields = [
            purchase.name,
            purchase.storeName ?? "",
            purchase.serialNumber ?? "",
            purchase.notes ?? ""
        ]
        .joined(separator: " ")

        return fields.localizedCaseInsensitiveContains(query)
    }

    private func matchesCategory(_ purchase: PurchaseItem) -> Bool {
        guard let selectedCategoryId else { return true }
        return purchase.categoryId == selectedCategoryId
    }

    private func matchesStatus(_ purchase: PurchaseItem) -> Bool {
        switch statusFilter {
        case .all:
            return true
        case .active, .expiringSoon, .expired, .archived, .noDate:
            return purchase.deadlineStatus().rawValue == statusFilter.rawValue
        }
    }

    private func sortPredicate(_ lhs: PurchaseItem, _ rhs: PurchaseItem) -> Bool {
        switch sort {
        case .newest:
            lhs.purchaseDate > rhs.purchaseDate
        case .oldest:
            lhs.purchaseDate < rhs.purchaseDate
        case .warrantyExpiringSoon:
            (lhs.primaryWarranty?.endDate ?? .distantFuture) < (rhs.primaryWarranty?.endDate ?? .distantFuture)
        case .returnExpiringSoon:
            (lhs.primaryReturnWindow?.endDate ?? .distantFuture) < (rhs.primaryReturnWindow?.endDate ?? .distantFuture)
        case .highestPrice:
            (lhs.price ?? 0) > (rhs.price ?? 0)
        case .alphabetical:
            lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }
}

