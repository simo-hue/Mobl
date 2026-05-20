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

## GitHub Pages & App Store Connect Setup - 2026-05-20

- **Deploying to GitHub Pages (Dual-Compatibility Enabled)**:
  1. We have configured the website to exist in **both** the root directory (`/`) and the `/docs` directory. This means your site is compatible with **any** GitHub Pages configuration!
  2. We added a **`.nojekyll`** bypass file to both locations. This instructs GitHub Pages to skip the Jekyll compilation step entirely, which **resolves the Jekyll build errors** you faced and ensures instant, error-free deployment of our custom assets.
  3. In your repository on GitHub, navigate to **Settings** > **Pages**.
  4. Under **Build and deployment**, set **Source** to **Deploy from a branch**.
  5. Select your active branch (e.g., `main`) and choose either **`/(root)`** or **`/docs`** (either will work perfectly now!).
  6. Click **Save**. GitHub will publish your site automatically at `https://simo-hue.github.io/Mobl/`.
  
- **App Store Connect Metadata URLs**:
  - **Support URL**: `https://simo-hue.github.io/Mobl/support.html` (Enter this in the App Store Connect "Support URL" field)
  - **Privacy Policy URL**: `https://simo-hue.github.io/Mobl/privacy.html` (Enter this in the App Store Connect "Privacy Policy URL" field)
  - **Marketing URL** (Optional but recommended): `https://simo-hue.github.io/Mobl/`
