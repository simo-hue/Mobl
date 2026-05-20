# Development Log

- [2026-05-20 00:00 Europe/Rome]: Project Bootstrap
  - *Details*: Initialized the native iOS app structure for ReceiptWarrantyVault with SwiftUI entry point, onboarding shell, tab shell, localized English/Italian strings, privacy manifest, localized permission strings, and asset catalog scaffolding.
  - *Tech Notes*: Minimum iOS target is 17.0. The v1 monetization path is paid upfront, so StoreKit is intentionally not included. No backend, analytics, ads, or tracking SDKs were added.

- [2026-05-20 00:00 Europe/Rome]: Local Data Foundation
  - *Details*: Added SwiftData models for purchases, warranties, return windows, attachments, and local notification rules. Added stable category identifiers and pure services for warranty date calculations, localized currency parsing/formatting, and date display helpers.
  - *Tech Notes*: Purchase price uses `Decimal`, each purchase stores an ISO currency code, and category display names are keyed for localization instead of storing translated labels.
