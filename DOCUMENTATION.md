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

- [2026-05-20 00:00 Europe/Rome]: App Store Preparation
  - *Details*: Added English and Italian App Store metadata drafts, App Review notes, and a privacy policy draft aligned with the local-only/no-tracking implementation.
  - *Tech Notes*: The intended App Store privacy declaration for v1 is no tracking and no data collected by the developer, assuming no third-party SDKs or external services are added before submission.

- [2026-05-20 14:00 Europe/Rome]: Warranty Vault English Branding
  - *Details*: Added a dedicated English branding file for the Warranty Vault App Store listing and optimized the English subtitle, promotional text, description, keywords, marketing lines, screenshot captions, and review notes.
  - *Tech Notes*: Subtitle and promotional text stay within App Store Connect limits. Keyword string is 92 characters, below the 100-character App Store keyword limit.

- [2026-05-20 14:30 Europe/Rome]: Marketing and Compliance Website
  - *Details*: Created a premium, bilingual, and responsive static website deployed to both the root (`/`) and the `/docs` directory. This dual-compatibility design resolves default GitHub Pages configuration mismatches. Added `.nojekyll` files to both folders to bypass Jekyll compilation and prevent SCSS conversion errors.
  - *Tech Notes*: Implemented native HTML5 structures, vanilla CSS with custom variables for dark/glassmorphic aesthetics, and dynamic vanilla JS translation engines supporting on-the-fly English/Italian switches. Built-in Privacy, Support (with FAQs and modern validated contact forms), and Terms of Service agreements to satisfy App Store Connect guidelines.

- [2026-05-20 14:44 Europe/Rome]: Face ID Lock and Document Attachment Fixes
  - *Details*: Fixed biometric lock lifecycle so the vault locks when the app enters background, not every time the app becomes active during Face ID presentation. Improved scanned document persistence and display by inserting attachment records before linking them to purchases, querying purchase documents directly by `purchaseItemID`, adding an in-app Quick Look preview, and showing an attachment count indicator in purchase rows.
  - *Tech Notes*: Added an authentication re-entry guard in `AppRootView`, Quick Look preview support in `PurchaseDetailView`, safer attachment file-size extraction in `DocumentStorageService`, and a regression test covering scanned attachment file copy, metadata, and purchase linkage.

- [2026-05-20 15:00 Europe/Rome]: Photo Library Attachment Reliability Fix
  - *Details*: Fixed the gallery import path so photos selected with PhotosPicker are converted into stable pending purchase drafts before opening the purchase form. Gallery images now use detected image metadata instead of relying on the first suggested content type, and they are classified as receipt image documents for the vault flow.
  - *Tech Notes*: Replaced the scanner hub purchase form presentation with item-driven sheet state, added `PhotoAttachmentBuilder` with ImageIO-backed type detection, reset the selected PhotosPicker item after import, and added a regression test for PNG gallery imports.

- [2026-05-20 15:06 Europe/Rome]: Export Actions and PDF Rendering Fix
  - *Details*: Reworked export-related buttons so data and PDF exports execute immediately and open the native share sheet, with clearly active action rows and reusable sharing for the last generated export. Fixed blank PDF output by rendering on an explicit white page with black text and richer purchase details.
  - *Tech Notes*: Added direct attachment querying for purchase PDF export and settings backup export, made `BackupExportService` accept explicit attachment records, added a UIKit share sheet bridge, and added regression tests for PDF text extraction and backup ZIP attachment inclusion.

- [2026-05-20 15:25 Europe/Rome]: App-Wide Action Feedback
  - *Details*: Added visible loading feedback for export, delete, save, scan processing, file import, and photo import flows. Updated action row styling so important actions read as active controls instead of muted blue list links.
  - *Tech Notes*: Added reusable `ActionRowLabel` and `loadingOverlay` SwiftUI components, converted long-running actions to yield before synchronous work so the busy state can render, and disabled repeated taps while exports or saves are in progress.

- [2026-05-20 15:53 Europe/Rome]: App Store Review Readiness Audit Fixes
  - *Details*: Updated the iOS privacy manifest to declare required reason API usage for local app preferences and file metadata access. Corrected the support website so the contact form opens a real prefilled email instead of showing a fake ticket submission, and aligned Terms copy with the current no-IAP/no-subscription binary.
  - *Tech Notes*: `PrivacyInfo.xcprivacy` now declares `NSPrivacyAccessedAPICategoryUserDefaults` with reason `CA92.1` and `NSPrivacyAccessedAPICategoryFileTimestamp` with reason `C617.1`; empty tracking domains were removed while keeping `NSPrivacyTracking=false`. The support form now uses `mailto:mattioli.simone.10@gmail.com` in both root and `/docs` website copies.

- [2026-05-20 15:56 Europe/Rome]: Developer Support Email Update
  - *Details*: Replaced the placeholder email `support@simo.dev` with the developer's real support email `mattioli.simone.10@gmail.com` across all website pages and scripts.
  - *Tech Notes*: Updated translation dictionary strings, contact form mailto handlers, HTML fallback text, and documentation references in both root and `/docs` directories. No other architectural or functionality changes were made.
