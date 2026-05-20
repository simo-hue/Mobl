import SwiftUI

struct AppRootView: View {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage(AppStorageKeys.biometricLockEnabled) private var biometricLockEnabled = false
    @State private var selectedTab: AppTab = .deadlines
    @State private var isUnlocked = false
    @State private var isAuthenticating = false

    var body: some View {
        Group {
            if biometricLockEnabled && !isUnlocked {
                LockedView {
                    Task {
                        await unlockIfNeeded()
                    }
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
        .task(id: biometricLockEnabled) {
            if biometricLockEnabled {
                await unlockIfNeeded()
            } else {
                isUnlocked = true
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard biometricLockEnabled else { return }

            switch newPhase {
            case .background:
                isUnlocked = false
            case .active:
                if !isUnlocked {
                    Task {
                        await unlockIfNeeded()
                    }
                }
            default:
                break
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

    @MainActor
    private func unlockIfNeeded() async {
        guard biometricLockEnabled, !isUnlocked, !isAuthenticating else { return }

        isAuthenticating = true
        isUnlocked = await AuthenticationService().authenticate()
        isAuthenticating = false
    }
}
