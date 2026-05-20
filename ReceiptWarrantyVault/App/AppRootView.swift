import SwiftUI

struct AppRootView: View {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage(AppStorageKeys.biometricLockEnabled) private var biometricLockEnabled = false
    @State private var selectedTab: AppTab = .deadlines
    @State private var isUnlocked = false

    var body: some View {
        Group {
            if biometricLockEnabled && !isUnlocked {
                LockedView {
                    unlock()
                }
            } else {
                TabView(selection: $selectedTab) {
                    ForEach(AppTab.allCases) { tab in
                        NavigationStack {
                            tab.content
                        }
                        .tabItem { tab.label }
                        .tag(tab)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: onboardingBinding) {
            OnboardingView {
                hasCompletedOnboarding = true
                selectedTab = .scan
            }
        }
        .task {
            if biometricLockEnabled {
                unlock()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active, biometricLockEnabled {
                isUnlocked = false
                unlock()
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

    private func unlock() {
        Task {
            isUnlocked = await AuthenticationService().authenticate()
        }
    }
}
