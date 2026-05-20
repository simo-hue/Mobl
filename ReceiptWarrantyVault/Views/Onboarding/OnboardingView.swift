import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var page = 0

    private let pages: [OnboardingPage] = [
        .init(titleKey: "onboarding.save.title", bodyKey: "onboarding.save.body", imageName: "doc.text.viewfinder"),
        .init(titleKey: "onboarding.deadlines.title", bodyKey: "onboarding.deadlines.body", imageName: "bell.badge"),
        .init(titleKey: "onboarding.privacy.title", bodyKey: "onboarding.privacy.body", imageName: "lock.shield")
    ]

    var body: some View {
        VStack(spacing: 24) {
            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            VStack(spacing: 12) {
                Button(page == pages.count - 1 ? "onboarding.cta.scan" : "common.next") {
                    if page == pages.count - 1 {
                        onComplete()
                    } else {
                        withAnimation(.snappy) {
                            page += 1
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button("onboarding.cta.manual") {
                    onComplete()
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct OnboardingPage: Identifiable {
    let id = UUID()
    let titleKey: LocalizedStringKey
    let bodyKey: LocalizedStringKey
    let imageName: String
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 40)

            Image(systemName: page.imageName)
                .font(.system(size: 78, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            VStack(spacing: 12) {
                Text(page.titleKey)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)

                Text(page.bodyKey)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
            }
            .padding(.horizontal, 28)

            Spacer(minLength: 40)
        }
    }
}

