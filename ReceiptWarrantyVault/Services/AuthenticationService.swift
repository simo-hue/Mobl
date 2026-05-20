import Foundation
import LocalAuthentication

struct AuthenticationService {
    func canUseBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }

    func authenticate() async -> Bool {
        let context = LAContext()
        context.localizedCancelTitle = String(localized: "common.cancel", comment: "Cancel button")

        do {
            return try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: String(
                    localized: "auth.reason",
                    comment: "Reason shown in the Face ID or passcode prompt"
                )
            )
        } catch {
            return false
        }
    }
}

