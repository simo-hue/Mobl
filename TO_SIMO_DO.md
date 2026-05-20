# Manual Actions For Simo

- App Store signing: set the final Apple Developer Team in Xcode and confirm the final bundle identifier before archive/submission. Current bundle id is `com.simo.receiptwarrantyvault`.
- App Store Connect: create the app record, upload screenshots, paste the EN/IT metadata from `AppStore/metadata/`, and provide a public privacy policy URL based on `AppStore/privacy-policy.md`.
- Privacy details: declare `Tracking: No` and `Data collected by developer: None` only if no external SDKs/services are added before submission.
- Device QA: test VisionKit scanning on a physical iPhone because the document camera is not fully testable in Simulator.
- Legal/business: confirm final commercial name and paid-upfront price tier before App Store submission.

## Distribution Upload Issue - 2026-05-20

- App Store Connect: check whether Xcode created an app record named `ReceiptWarrantyVault` with Apple ID `6771369236` and bundle ID `com.simo.receiptwarrantyvault`.
- If the record exists, rename the app metadata to `Warranty Vault`, complete the required App Store Connect fields, wait a few minutes for propagation, then retry Xcode Organizer upload.
- If the record is not visible, manually create a new app record in App Store Connect using bundle ID `com.simo.receiptwarrantyvault`, SKU `com.simo.receiptwarrantyvault`, primary language English, then retry upload.
- Avoid relying on Xcode's automatic "create app record" recovery path for the next attempt; create/verify the record in App Store Connect first, then upload the archive.
