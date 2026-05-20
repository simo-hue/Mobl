import SwiftUI

struct AppRootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedTab: AppTab = .deadlines

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases) { tab in
                NavigationStack {
                    tab.content
                }
                .tabItem { tab.label }
                .tag(tab)
            }
        }
        .fullScreenCover(isPresented: onboardingBinding) {
            OnboardingView {
                hasCompletedOnboarding = true
                selectedTab = .scan
            }
        }
    }

    private var onboardingBinding: Binding<Bool> {
        Binding(
            get: { !hasCompletedOnboarding },
            set: { isPresented in
                if !isPresented {
                    hasCompletedOnboarding = true
                }
            }
        )
    }
}

