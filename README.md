# Warranties Vault

[![iOS Target](https://img.shields.io/badge/iOS-17.0%2B-blue.svg?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/Swift-5.10%2B-orange.svg?style=flat-square&logo=swift)](https://developer.apple.com/swift/)
[![SwiftData](https://img.shields.io/badge/SwiftData-Supported-green.svg?style=flat-square)](https://developer.apple.com/xcode/)
[![Platform](https://img.shields.io/badge/Platform-iPhone-black.svg?style=flat-square)](https://developer.apple.com/iphone/)

**Warranties Vault** is a native, premium, privacy-first iOS application designed to organize receipts, invoices, warranty documents, and return deadlines. It is built global-first with robust bilingual configurations (English and Italian) and is engineered to run completely offline.

The app features a zero-tracking architecture: there are no databases, no external backend servers, no sign-up forms, and no compiled advertising or analytics SDKs. Everything is processed and stored strictly inside the local iOS sandbox on the user's physical silicon.

---

## 🌟 Key Product Features

- **Native Document Scanning:** Integrated with VisionKit `VNDocumentCameraViewController` for high-quality, multi-page document scanning of physical receipts.
- **Digital Invoices Import:** Easily import existing PDFs, JPEG/PNG, or HEIC files from the native iOS Files app or Photo Library.
- **Deadline Tracking & Timelines:** Custom warranty date calculators and return window monitors highlight urgent timelines in dynamic lists.
- **Biometric Security:** Optional Face ID / Touch ID lock to restrict app access on the physical device with a secure system passcode fallback.
- **Local Smart Reminders:** Automatic user notifications scheduled locally on-device before return periods close or manufacturer warranties expire.
- **Native PDF & ZIP Portability:** Render elegant purchase sheets as single PDFs or export the entire structured database as a compressed ZIP backup including a structured `metadata.json` and a clean `attachments/` folder.
- **Bilingual Static Website:** Deployed statically via both root (`/`) and `/docs` folders for full GitHub Pages compatibility. It includes an interactive FAQs panel, an automated validated mailto contact form, and an on-the-fly translation engine (EN/IT).

---

## 🛠️ Technical Stack & Architecture

### Native iOS Client (`ReceiptWarrantyVault/`)
* **UI Framework:** SwiftUI for a modern, fluid, and responsive native user interface.
* **Data Storage:** SwiftData (`@Query` and custom relational structures) using `Decimal` values for precise financial entries.
* **Security:** `LocalAuthentication` framework for biometric protection, coupled with `completeUntilFirstUserAuthentication` file encryption keys.
* **Attachment Persistence:** Standard `ApplicationSupport` directory storage for document attachments to keep the SwiftData database lightweight.
* **Localization:** Native Xcode String Catalogs (`.xcstrings`) for structural strings and InfoPlist strings.

### Static Marketing Site (`/` and `/docs`)
* **Foundation:** HTML5, CSS custom styling variables (HSL tailored colors, glassmorphic card designs, radial neon tech-glow elements).
* **Localization Engine:** High-performance, vanilla JavaScript client-side translator mapping localized dictionaries (EN/IT) and applying smooth CSS fade transitions during swaps.
* **Compliance & Deliveries:** Deployed `.nojekyll` configurations bypass Jekyll processing on GitHub Pages to enable rapid, direct CSS and asset loading.

---

## 📂 Repository Directory Structure

```text
├── AppStore/                         # App Store Connect Submission Assets
│   ├── branding/                     # Dedicated marketing copysheets
│   │   └── warranties-vault-en.md    # English App Store marketing sheet
│   ├── metadata/en-US/               # App Store Storefront Copy
│   │   └── app-store.md              # Title, Subtitle, Keywords, Description
│   └── privacy-policy.md             # Privacy Policy compliant with local-only storage
│
├── ReceiptWarrantyVault/             # Native iOS App Source Code
│   ├── Models/                       # SwiftData Persistent Schemas (Purchase, Attachment, etc.)
│   ├── Services/                     # Core Business Logic (Backup, Biometrics, Documents, PDF rendering)
│   ├── Resources/                    # Plists, Assets Catalogs, and Localizable.xcstrings
│   └── Views/                        # Deadlines, Archive, Form Details, and Scanner Sheets
│
├── docs/                             # Compliant Site Directory (GitHub Pages Default Folder)
├── index.html                        # Website Landing Page (Root Copy)
├── privacy.html                      # Website Privacy Policy Page
├── support.html                      # Website Support & Contact Form Page
├── terms.html                        # Website Terms of Service & EULA Agreement
├── app.js                            # Website Translation & Form Handler Script
├── style.css                         # Website Styling Sheet (Vanilla CSS Variables)
│
├── specifiche_global.md              # Comprehensive product and technical specifications
├── DOCUMENTATION.md                  # Development changes log (timestamps & tech notes)
└── TO_SIMO_DO.md                     # Pending developer manual actions checklist
```

---

## 🚀 Getting Started for Developers

### Prerequisites
* **macOS:** macOS Sonoma 14.0 or newer.
* **Xcode:** Xcode 15.0 or newer.
* **Target:** iOS 17.0+ (SwiftData & standard SwiftUI APIs require this runtime minimum).

### Installation & Build

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd "Salva Scontrini"
   ```

2. **Open the Project:**
   Launch Xcode and open `ReceiptWarrantyVault.xcodeproj`.

3. **Configure Development Team:**
   Go to **Project Settings** > **Signing & Capabilities** and select your active Apple Developer Team to resolve provisioning profile settings.

4. **Run the Application:**
   Choose a Simulator (e.g., iPhone 15 Pro) or plug in a physical device and press **Cmd + R** to run.
   > 📝 **Note:** Document scanning via VisionKit camera is only testable on a physical device.

---

## 🔒 Compliance & Guidelines Alignment

* **App Store Guidelines:** Designed under strict compliance with Apple Review Section 5.1 (Privacy).
* **Privacy Manifests:** Fully implements `PrivacyInfo.xcprivacy` declaring `NSPrivacyAccessedAPICategoryUserDefaults` (CA92.1) and `NSPrivacyAccessedAPICategoryFileTimestamp` (C617.1) for compliant local file access.
* **Zero Tracking Declaration:** Configured for `Tracking: No` and `Data collected by developer: None` declarations on App Store Connect.
* **Business Model:** Structured as a premium paid upfront product. The current build contains no ads, trackers, in-app purchases, or subscription code blocks.