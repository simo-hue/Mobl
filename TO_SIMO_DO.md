# Manual Actions For Simo

- App Store signing: set the final Apple Developer Team in Xcode and confirm the final bundle identifier before archive/submission. Current bundle id is `com.simo.receiptwarrantyvault`.
- App Store Connect: create the app record, upload screenshots, paste the EN/IT metadata from `AppStore/metadata/`, and provide a public privacy policy URL based on `AppStore/privacy-policy.md`.
- Privacy details: declare `Tracking: No` and `Data collected by developer: None` only if no external SDKs/services are added before submission.
- Device QA: test VisionKit scanning on a physical iPhone because the document camera is not fully testable in Simulator.
- Legal/business: confirm final commercial name and paid-upfront price tier before App Store submission.
