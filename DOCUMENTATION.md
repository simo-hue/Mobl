# Development Log

- [2026-05-20 00:00 Europe/Rome]: Project Bootstrap
  - *Details*: Initialized the native iOS app structure for ReceiptWarrantyVault with SwiftUI entry point, onboarding shell, tab shell, localized English/Italian strings, privacy manifest, localized permission strings, and asset catalog scaffolding.
  - *Tech Notes*: Minimum iOS target is 17.0. The v1 monetization path is paid upfront, so StoreKit is intentionally not included. No backend, analytics, ads, or tracking SDKs were added.

- [2026-05-20 00:00 Europe/Rome]: Local Data Foundation
  - *Details*: Added SwiftData models for purchases, warranties, return windows, attachments, and local notification rules. Added stable category identifiers and pure services for warranty date calculations, localized currency parsing/formatting, and date display helpers.
  - *Tech Notes*: Purchase price uses `Decimal`, each purchase stores an ISO currency code, and category display names are keyed for localization instead of storing translated labels.

- [2026-05-20 00:00 Europe/Rome]: Offline Services Layer
  - *Details*: Added local document storage, notification scheduling, biometric authentication, single-purchase PDF export, and JSON/ZIP backup export services.
  - *Tech Notes*: Attachments are stored under Application Support instead of SwiftData blobs. File protection uses `completeUntilFirstUserAuthentication`. ZIP backup is implemented in-app without third-party dependencies or network calls.

- [2026-05-20 00:00 Europe/Rome]: Core Purchase Flows
  - *Details*: Replaced placeholder tabs with Deadlines, Archive, Scan entry, purchase form, and purchase detail screens. Added search, category/status filters, sorting, deadline cards, manual purchase creation/editing, archive/delete actions, and PDF sharing entry points.
  - *Tech Notes*: UI uses SwiftUI with SwiftData `@Query`; deadlines are derived from local model data using `WarrantyCalculator`. Visible text is keyed for localization through the string catalog.

- [2026-05-20 00:00 Europe/Rome]: Native Import, Privacy, and Settings
  - *Details*: Added VisionKit document scanning, Files import, Photos import, pending attachment handoff into purchase creation, optional Face ID app lock, notification and backup preferences, full backup export, delete-all flow, and privacy/legal/about screens.
  - *Tech Notes*: Scanner and imports copy files into temporary local URLs before `DocumentStorageService` persists them into Application Support. Notifications remain local only. Face ID uses `LocalAuthentication` with passcode fallback.
