# Specifica completa prodotto e tecnica — App iOS “Scontrini & Garanzie” / Receipt & Warranty Vault

**Versione documento:** 2.0  
**Data:** 2026-05-20  
**Lingua documento:** Italiano  
**Destinatario principale:** Codex / agente di sviluppo iOS  
**Obiettivo:** sviluppare una app iOS premium, privacy-first, offline-first e global-ready per archiviare scontrini, ricevute, fatture, garanzie e scadenze di reso/garanzia.

---

## 0. Sintesi esecutiva

Realizzare un’app iOS per salvare localmente sul dispositivo ricevute, scontrini, fatture, documenti di garanzia, foto prodotto e promemoria di scadenza. L’app deve essere vendibile a pagamento una tantum oppure come free trial limitato con sblocco lifetime, senza abbonamenti, senza account, senza backend, senza tracking e senza upload dei documenti dell’utente.

L’app deve essere progettata **global-first fin dalla v1**: UI localizzabile, supporto multilingua, formati regionali per date/valute/numeri, nessuna assunzione esclusivamente italiana, metadati App Store localizzabili e funzionalità configurabili per paesi diversi.

La promessa prodotto è:

> Una cassaforte privata, offline e internazionale per scontrini, garanzie e resi. Nessun account. Nessun cloud obbligatorio. Nessun tracking. Tutto resta sul tuo iPhone.

---

## 1. Principi non negoziabili

### 1.1 Privacy-first

L’app deve rispettare questi vincoli:

- Nessun account.
- Nessun backend proprietario.
- Nessun caricamento automatico dei documenti su server.
- Nessun SDK pubblicitario.
- Nessun tracking cross-app o cross-site.
- Nessun analytics di terze parti nella v1.
- Nessuna raccolta di dati personali da parte dello sviluppatore nella v1.
- Tutti i dati utente devono essere salvati localmente nella sandbox dell’app.
- Tutte le autorizzazioni di sistema devono essere richieste solo quando servono e con purpose string chiare.
- La privacy deve essere una feature visibile nell’app, nel marketing e nella pagina App Store.

### 1.2 Offline-first

L’app deve funzionare senza connessione internet per:

- creazione acquisto;
- scansione documento;
- gestione garanzie;
- allegati;
- ricerca locale;
- notifiche locali;
- export locale;
- Face ID / Touch ID.

### 1.3 Global-first

L’app deve essere pronta per un lancio internazionale fin dalla prima versione.

Obbligatorio:

- lingua base del progetto: **English**;
- localizzazioni minime v1: **English** e **Italian**;
- architettura pronta ad aggiungere il maggior numero possibile di lingue senza refactoring;
- nessuna stringa hardcoded;
- supporto valute diverse dall’euro;
- supporto formati data/numeri secondo locale utente;
- impostazioni modificabili per durata garanzia e finestra reso;
- categorie localizzabili;
- testi App Store preparabili in più lingue;
- nessuna dipendenza funzionale da regole italiane o UE.

### 1.4 Premium e semplice

L’app deve essere piccola ma rifinita. Evitare funzionalità ambigue o pesanti nella v1. L’esperienza deve comunicare fiducia, ordine e sicurezza.

---

## 2. Fonti Apple e riferimenti ufficiali da rispettare

Lo sviluppo deve attenersi alle fonti Apple ufficiali più recenti disponibili al momento dello sviluppo:

1. **App Review Guidelines**  
   https://developer.apple.com/app-store/review/guidelines/  
   Linee guida per sicurezza, performance, business, design e legal.

2. **App Privacy Details**  
   https://developer.apple.com/app-store/app-privacy-details/  
   Dichiarazione delle pratiche privacy su App Store Connect.

3. **Manage App Privacy — App Store Connect Help**  
   https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/  
   Richiede informazioni accurate sulle pratiche di raccolta dati e privacy policy URL per app iOS.

4. **User Privacy and Data Use**  
   https://developer.apple.com/app-store/user-privacy-and-data-use/  
   Pratiche privacy e rispetto dei permessi utente.

5. **Human Interface Guidelines — Privacy**  
   https://developer.apple.com/design/human-interface-guidelines/privacy  
   Privacy, minimizzazione dati e trasparenza.

6. **Xcode Localization / String Catalogs**  
   https://developer.apple.com/documentation/xcode/localization  
   https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog  
   String Catalogs sono il metodo raccomandato in Xcode 15+.

7. **Apple Localization resources**  
   https://developer.apple.com/localization/  
   Localizzazione del binario e dei metadati App Store.

8. **Localize App Information — App Store Connect Help**  
   https://developer.apple.com/help/app-store-connect/manage-app-information/localize-app-information/  
   Localizzazione di nome app, descrizione, keyword, screenshot e altri metadata.

9. **App Store product page**  
   https://developer.apple.com/app-store/product-page/  
   App preview, screenshot, metadata localizzati.

10. **VisionKit document scanner**  
    https://developer.apple.com/documentation/visionkit/vndocumentcameraviewcontroller  
    Scanner nativo per documenti fisici.

11. **UserNotifications**  
    https://developer.apple.com/documentation/usernotifications  
    Notifiche locali e richiesta permesso notifiche.

12. **Local notifications**  
    https://developer.apple.com/documentation/usernotifications/scheduling-a-notification-locally-from-your-app

13. **App icons — Human Interface Guidelines**  
    https://developer.apple.com/design/human-interface-guidelines/app-icons

14. **Configuring your app icon using an asset catalog**  
    https://developer.apple.com/documentation/xcode/configuring-your-app-icon  
    Asset catalog e immagine app icon 1024 pt per iOS.

15. **Export compliance / encryption**  
    https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance/  
    https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations  
    https://developer.apple.com/help/app-store-connect/reference/app-information/export-compliance-documentation-for-encryption/

---

## 3. Nome, naming e strategia internazionale

### 3.1 Nome interno progetto

Usare un nome neutro in inglese per repository, bundle e codice:

```text
ReceiptWarrantyVault
```

### 3.2 Nome commerciale consigliato

Per massima scalabilità globale, evitare un nome solo italiano. Possibili nomi:

1. **Warranty Vault**
2. **Receipt Vault**
3. **ProofVault**
4. **Warranty Safe**
5. **Receipt & Warranty Vault**

Consiglio: **Warranty Vault** oppure **Receipt Vault**.

### 3.3 Nome localizzato App Store

Il nome mostrato su App Store e nella home screen può essere localizzato dove opportuno.

Esempi:

- English: `Warranty Vault`
- Italian: `Scontrini & Garanzie`
- Spanish: `Recibos y Garantías`
- French: `Reçus et Garanties`
- German: `Belege & Garantien`
- Portuguese: `Recibos e Garantias`

Attenzione: il bundle name e i riferimenti interni devono restare stabili e non dipendere da una lingua specifica.

---

## 4. Target utenti

### 4.1 Segmenti principali

- Persone che acquistano elettronica, elettrodomestici, arredamento e prodotti costosi.
- Famiglie che vogliono gestire garanzie e documenti domestici.
- Freelance/professionisti che archiviano acquisti di strumenti di lavoro.
- Utenti privacy-conscious.
- Persone che fanno acquisti online e vogliono ricordare finestre di reso.
- Proprietari di case, host, gestori di piccoli inventari domestici.

### 4.2 Problemi da risolvere

- Perdita dello scontrino o fattura.
- Dimenticanza della scadenza reso.
- Dimenticanza della scadenza garanzia.
- Difficoltà a trovare documenti quando serve assistenza.
- Confusione tra garanzia legale, commerciale, estesa e assicurazione.
- Mancanza di un archivio ordinato e privato.

---

## 5. Proposta di valore

### 5.1 Value proposition

> Salva scontrini, fatture, garanzie e resi in un archivio locale e privato. Ricevi promemoria prima delle scadenze. Tutto resta sul tuo dispositivo.

### 5.2 Differenziazione

L’app non deve essere:

- un’app contabile;
- un expense tracker generico;
- un’app OCR cloud;
- un servizio con account;
- un archivio documentale aziendale;
- un’app con abbonamento obbligatorio.

L’app deve essere:

- una cassaforte locale per prove d’acquisto;
- semplice;
- internazionale;
- orientata a privacy;
- pagata una volta;
- utile senza connessione.

---

## 6. Strategia di monetizzazione

### 6.1 Modello principale consigliato

Due opzioni supportate, scegliere una prima dello sviluppo finale.

#### Opzione A — Paid upfront

- Prezzo lancio: 4,99–6,99 EUR/USD equivalente.
- Prezzo maturo: 6,99–9,99 EUR/USD equivalente.
- Nessun paywall interno.
- Nessun StoreKit necessario per v1, salvo eventuali future feature.

Vantaggi:

- coerente con privacy;
- semplice da implementare;
- utenti più qualificati;
- niente frizione paywall.

Svantaggi:

- meno download;
- nessuna prova gratuita.

#### Opzione B — Free + lifetime unlock

- Gratis con limite massimo di 5 acquisti.
- Sblocco illimitato lifetime: 8,99–12,99 EUR/USD equivalente.
- Usare StoreKit per non-consumable in-app purchase.

Vantaggi:

- più facile validazione globale;
- utenti possono provare scanner e UX;
- più potenziale recensioni.

Svantaggi:

- StoreKit da implementare;
- gestione paywall;
- conversione incerta;
- più utenti non paganti.

### 6.2 Requisito prodotto

Per questa specifica, il requisito di business desiderato è:

```text
Monetizzazione preferita: pagamento una tantum.
No subscription.
No ads.
No paid data collection.
No cloud upsell obbligatorio.
```

Se si sceglie free + lifetime unlock, il lifetime unlock deve essere l’unico acquisto principale e deve sbloccare tutte le funzioni core.

---

## 7. Requisiti global-first e localizzazione

Questa sezione è prioritaria. Codex deve implementare l’app assumendo un lancio globale fin dalla v1.

### 7.1 Lingue v1

Minimo obbligatorio:

- `en` — English, lingua base/fallback.
- `it` — Italian.

### 7.2 Lingue da predisporre

Il progetto deve essere strutturato per aggiungere facilmente almeno:

- Spanish (`es`)
- French (`fr`)
- German (`de`)
- Portuguese (`pt` / `pt-BR`)
- Dutch (`nl`)
- Polish (`pl`)
- Japanese (`ja`)
- Korean (`ko`)
- Chinese Simplified (`zh-Hans`)
- Chinese Traditional (`zh-Hant`)
- Arabic (`ar`)
- Hindi (`hi`)

Non è necessario tradurre tutte queste lingue nella prima build se non richiesto, ma il codice deve essere pronto.

### 7.3 String Catalogs

Usare String Catalogs `.xcstrings` in Xcode 15+.

Requisiti:

- Nessuna stringa visibile all’utente deve essere hardcoded.
- Ogni testo UI deve usare chiavi localizzabili.
- Le stringhe devono avere commenti di contesto per traduttori.
- Le stringhe con variabili devono usare interpolazione localizzabile corretta.
- Le stringhe con plurali devono essere gestite con pluralization rules, non concatenazione manuale.
- Evitare costruzioni come `"Garanzia: " + days + " giorni"`; usare stringhe localizzabili con placeholder.

Esempio concettuale:

```swift
Text("warranty.days_remaining \(days)")
```

Non:

```swift
Text("Garanzia: \(days) giorni rimasti")
```

### 7.4 Formattazione date

Non usare formati fissi come `dd/MM/yyyy` nella UI.

Usare:

- `Date.FormatStyle`
- `DateFormatter` configurato con `Locale.current`
- calendari e timezone coerenti con l’utente

Esempi:

- Italia: `20/05/2026`
- Stati Uniti: `5/20/2026`
- Germania: `20.05.2026`
- Giappone: `2026/05/20`

### 7.5 Formattazione valute

Non assumere euro come valuta unica.

Requisiti:

- Campo `currencyCode` nel modello dati.
- Default: valuta da `Locale.current.currency?.identifier`, con fallback `USD`.
- L’utente deve poter modificare valuta predefinita.
- Ogni acquisto deve poter avere una valuta propria.
- Usare `Decimal` per importi, non `Double`.
- Usare `NumberFormatStyle.Currency` o `NumberFormatter`.

Esempi:

- EUR: `€1,249.00` / `1.249,00 €` a seconda del locale.
- USD: `$1,249.00`
- GBP: `£1,249.00`
- JPY: `¥124,900`

### 7.6 Numeri e misure

Per eventuali conteggi, importi e statistiche:

- usare formattazione locale;
- non inserire separatori manualmente;
- non assumere punto o virgola decimale.

### 7.7 Testi legali e garanzie per paese

L’app non deve presentare la garanzia UE/Italia come verità universale.

Implementare:

- durata garanzia predefinita configurabile;
- preset regionale opzionale;
- testo neutro e modificabile;
- disclaimer chiaro.

Esempio UI:

```text
Warranty duration
Default suggestion: 24 months
You can edit this for each item. Warranty rules may vary by country, seller, product type, and contract.
```

In italiano:

```text
Durata garanzia
Suggerimento predefinito: 24 mesi
Puoi modificarlo per ogni prodotto. Le regole di garanzia possono variare in base a paese, venditore, prodotto e contratto.
```

### 7.8 Return window / resi

Non assumere che il reso sia sempre 14 giorni.

Requisiti:

- default modificabile;
- opzioni rapide: 7, 14, 30, 60, 90 giorni;
- valore personalizzato;
- possibilità di disabilitare reso;
- campo note politica negozio.

### 7.9 Categorie localizzabili

Categorie predefinite v1:

- Electronics
- Appliances
- Home
- Kitchen
- Furniture
- Clothing
- Tools
- Sports
- Toys
- Automotive
- Documents
- Other

Tutte devono essere localizzate. Salvare nel database un identificatore stabile, non il nome tradotto.

Esempio:

```text
category.id = "electronics"
displayName = localized("category.electronics")
```

### 7.10 App Store metadata localizzati

Preparare materiali almeno per:

- English
- Italian

Predisporre struttura per:

- app name;
- subtitle;
- promotional text;
- description;
- keywords;
- screenshots text overlays;
- app preview captions;
- privacy policy.

Apple consente di localizzare metadata come nome, descrizione, keyword, screenshot e preview in App Store Connect. La localizzazione del binario in Xcode e quella dei metadata App Store sono processi distinti: implementarli entrambi.

### 7.11 Screenshots globali

Gli screenshot App Store devono essere esportabili in più lingue.

Requisiti:

- evitare testo dentro immagini non modificabile;
- mantenere file sorgente Figma/Sketch/Canva con layer testuali separati;
- creare screenshot con device frame coerente;
- localizzare claim principali;
- usare screenshot che non mostrino dati personali reali.

### 7.12 Icona internazionale

L’icona non deve contenere parole o lettere specifiche di una lingua.

Consentito:

- simboli universali: ricevuta, cartella, scudo, lucchetto, calendario, check;
- simbolo valuta generico o euro/dollaro solo se non limita troppo la percezione globale.

Preferibile:

- nessun testo;
- nessun bordo;
- immagine piena;
- leggibile anche in dimensioni piccole;
- conforme alle HIG App Icons.

### 7.13 Lingue RTL

Predisporre supporto futuro per lingue right-to-left come arabo ed ebraico:

- evitare layout manuali con `left`/`right`;
- usare `leading`/`trailing`;
- testare almeno che la UI non collassi in RTL;
- non incorporare direzione del testo nelle immagini UI.

---

## 8. Funzionalità MVP v1

### 8.1 Onboarding

Massimo 3 schermate.

Obiettivi:

1. spiegare cosa fa l’app;
2. spiegare privacy locale;
3. far aggiungere il primo documento.

Schermata 1:

```text
Save receipts and warranties
Keep proof of purchase, invoices, and warranty documents organized.
```

Schermata 2:

```text
Never miss a deadline
Get local reminders before return windows and warranties expire.
```

Schermata 3:

```text
Private by design
No account. No tracking. Your documents stay on your device.
```

Localizzare in italiano e inglese.

CTA:

- `Scan first receipt`
- `Add manually`

### 8.2 Home / Deadlines

La home deve mostrare scadenze e urgenze.

Sezioni:

- Return deadlines soon
- Warranties expiring soon
- Active warranties
- Expired
- Empty state

Card acquisto:

- nome prodotto;
- negozio;
- categoria;
- miniatura allegato/foto;
- giorni rimanenti;
- badge tipo scadenza;
- colore stato.

Stati:

- Active
- Expiring soon
- Expired
- No warranty date
- Archived

### 8.3 Archivio acquisti

Lista di tutti gli acquisti.

Funzioni:

- ricerca;
- filtri categoria;
- filtri stato garanzia;
- filtri reso;
- ordinamento.

Ordinamenti:

- newest purchase;
- oldest purchase;
- warranty expiring soon;
- return expiring soon;
- highest price;
- alphabetical.

### 8.4 Scanner documento

Usare VisionKit `VNDocumentCameraViewController` per scansionare documenti fisici.

Requisiti:

- supportare scansione multi-pagina;
- salvare output come immagini o PDF locale;
- gestire cancellazione utente;
- gestire errore scanner;
- richiedere permesso camera solo quando serve;
- usare purpose string chiara per camera.

Purpose string proposta:

English:

```text
Camera access is used to scan receipts, invoices, and warranty documents. Scans stay on your device.
```

Italian:

```text
L’accesso alla fotocamera serve per scansionare scontrini, fatture e documenti di garanzia. Le scansioni restano sul dispositivo.
```

### 8.5 Importazione documenti

Supportare:

- import da Files;
- import da Photos;
- PDF;
- JPEG/PNG/HEIC;
- condivisione tramite Share Sheet se fattibile in v1.1.

### 8.6 Creazione acquisto

Campi minimi:

- nome prodotto;
- data acquisto;
- durata garanzia;
- documento allegato opzionale ma consigliato.

Campi opzionali:

- negozio;
- prezzo;
- valuta;
- categoria;
- data fine reso;
- serial number;
- note;
- foto prodotto;
- tipo garanzia;
- garanzia estesa;
- assicurazione.

### 8.7 Dettaglio acquisto

Mostrare:

- nome prodotto;
- stato garanzia;
- timeline scadenze;
- documenti allegati;
- metadati;
- note;
- azioni rapide.

Azioni:

- apri documento;
- modifica;
- condividi documento;
- esporta scheda PDF;
- archivia;
- elimina.

### 8.8 Notifiche locali

Usare `UserNotifications`.

Requisiti:

- chiedere permesso notifiche solo quando l’utente abilita promemoria o salva un item con promemoria;
- notifiche solo locali;
- nessun push server;
- programmare notifiche per return window e warranty expiration;
- cancellare notifiche quando un acquisto viene eliminato o la scadenza modificata;
- aggiornare notifiche quando cambiano le impostazioni.

Default consigliati:

- reso: 3 giorni prima, 1 giorno prima;
- garanzia: 30 giorni prima, 7 giorni prima, giorno stesso.

Testo notifiche localizzato.

Esempio:

```text
Warranty ending soon
Your warranty for “MacBook Air” ends in 7 days.
```

### 8.9 Protezione Face ID / Touch ID

Usare LocalAuthentication.

Requisiti:

- opzione disattivata di default;
- se attivata, richiedere autenticazione all’apertura;
- fallback passcode se consentito dal sistema;
- messaggio chiaro.

Purpose string / copy:

```text
Use Face ID to protect your saved receipts and warranty documents.
```

### 8.10 Export

Funzionalità obbligatoria per fiducia e portabilità.

Supportare:

- export singola scheda in PDF;
- export documenti associati;
- export archivio in ZIP;
- export dati strutturati in JSON;
- export opzionale CSV.

Il backup completo deve includere:

- `metadata.json`;
- cartella `attachments/`;
- file `README.txt` con spiegazione;
- opzionalmente `checksum.json`.

Per v1, backup non cifrato è accettabile se l’utente sceglie manualmente dove salvarlo. Per una v2, aggiungere backup cifrato con password.

### 8.11 Delete data

L’utente deve poter cancellare:

- singolo acquisto;
- singolo allegato;
- tutto l’archivio.

Aggiungere conferme distruttive chiare.

---

## 9. Funzionalità escluse dalla v1

Non implementare nella v1 salvo esplicita richiesta:

- account utente;
- backend;
- sync iCloud automatico;
- OCR cloud;
- AI cloud;
- lettura automatica email;
- scraping siti venditori;
- social sharing;
- ads;
- abbonamenti;
- statistiche finanziarie complesse;
- tracciamento analytics terze parti.

---

## 10. Roadmap consigliata

### 10.1 Versione 1.0

- SwiftUI app.
- Localizzazione English + Italian.
- String Catalogs.
- Data model locale.
- Lista acquisti.
- Dettaglio acquisto.
- Aggiunta manuale.
- Scanner documento VisionKit.
- Allegati locali.
- Calcolo garanzia e reso.
- Notifiche locali.
- Ricerca e filtri base.
- Face ID opzionale.
- Export PDF singolo.
- Export JSON/ZIP base.
- App privacy / no tracking.
- App Store metadata EN/IT.

### 10.2 Versione 1.1

- Share Extension / import da altre app.
- Widget “upcoming deadlines”.
- OCR on-device base.
- CSV export.
- Tag personalizzati.
- Backup reminder.
- Miglioramenti iPad.

### 10.3 Versione 1.2

- OCR on-device suggerimenti negozio/data/totale.
- Multi-currency reporting locale.
- Miglior supporto accessibilità.
- Più localizzazioni.

### 10.4 Versione 2.0

- Inventario casa.
- Stanze/luoghi.
- Valore totale stimato.
- Export assicurazione.
- Backup cifrato.
- Eventuale iCloud opzionale e disattivato di default.

---

## 11. Architettura tecnica

### 11.1 Stack

- Linguaggio: Swift.
- UI: SwiftUI.
- Persistenza: SwiftData se target iOS moderno; Core Data se serve compatibilità più ampia.
- File storage: FileManager nella sandbox app.
- Scanner: VisionKit.
- Notifiche: UserNotifications.
- Autenticazione locale: LocalAuthentication.
- Import/export: UniformTypeIdentifiers, PDFKit o renderer SwiftUI/PDF.
- Monetizzazione:
  - paid upfront: nessun StoreKit necessario per v1;
  - lifetime unlock: StoreKit 2.
- Localizzazione: String Catalogs `.xcstrings`.

### 11.2 Target iOS

Consigliato:

```text
Minimum deployment target: iOS 17.0
Preferred development target: latest stable Xcode/iOS SDK
```

Se si vuole massima compatibilità, valutare iOS 16, ma SwiftData richiede considerazioni. Se iOS 16 è obbligatorio, preferire Core Data.

### 11.3 Pattern architetturale

Consigliato:

- SwiftUI + MVVM leggero.
- Services separati:
  - `DocumentStorageService`
  - `NotificationScheduler`
  - `PDFExportService`
  - `BackupExportService`
  - `LocalizationPreviewService` se utile nei test
  - `CurrencyService`
  - `WarrantyCalculator`
  - `AuthenticationService`

Evitare view enormi con logica business.

### 11.4 Cartelle progetto

Struttura suggerita:

```text
ReceiptWarrantyVault/
  App/
    ReceiptWarrantyVaultApp.swift
    AppState.swift
  Models/
    PurchaseItem.swift
    Warranty.swift
    ReturnWindow.swift
    Attachment.swift
    Category.swift
    NotificationRule.swift
  Views/
    Onboarding/
    Dashboard/
    Archive/
    Scanner/
    PurchaseDetail/
    PurchaseForm/
    Settings/
    Components/
  ViewModels/
  Services/
    DocumentStorageService.swift
    NotificationScheduler.swift
    WarrantyCalculator.swift
    PDFExportService.swift
    BackupExportService.swift
    AuthenticationService.swift
    CurrencyService.swift
  Resources/
    Localizable.xcstrings
    Assets.xcassets
  Extensions/
  Tests/
```

---

## 12. Data model

### 12.1 PurchaseItem

```swift
struct PurchaseItem {
    var id: UUID
    var name: String
    var categoryId: String?
    var storeName: String?
    var purchaseDate: Date
    var price: Decimal?
    var currencyCode: String
    var notes: String?
    var serialNumber: String?
    var createdAt: Date
    var updatedAt: Date
    var isArchived: Bool
}
```

Note:

- `categoryId` deve essere stabile e non localizzato.
- `currencyCode` ISO 4217.
- `price` Decimal.
- `name` obbligatorio.

### 12.2 Warranty

```swift
struct Warranty {
    var id: UUID
    var purchaseItemId: UUID
    var type: WarrantyType
    var startDate: Date
    var endDate: Date
    var durationMonths: Int?
    var notes: String?
}
```

`WarrantyType`:

```swift
enum WarrantyType: String, Codable, CaseIterable {
    case legal
    case commercial
    case extended
    case insurance
    case custom
}
```

### 12.3 ReturnWindow

```swift
struct ReturnWindow {
    var id: UUID
    var purchaseItemId: UUID
    var startDate: Date
    var endDate: Date
    var storePolicyNotes: String?
    var isCompleted: Bool
}
```

### 12.4 Attachment

```swift
struct Attachment {
    var id: UUID
    var purchaseItemId: UUID
    var type: AttachmentType
    var localFileName: String
    var originalFileName: String?
    var mimeType: String
    var fileSize: Int64?
    var createdAt: Date
}
```

`AttachmentType`:

```swift
enum AttachmentType: String, Codable, CaseIterable {
    case receiptImage
    case receiptPDF
    case invoice
    case warrantyDocument
    case productPhoto
    case manual
    case other
}
```

### 12.5 Category

```swift
struct Category {
    var id: String
    var iconName: String
    var sortOrder: Int
    var isSystem: Bool
}
```

Display name localizzato tramite chiave:

```text
category.electronics
category.appliances
...
```

### 12.6 NotificationRule

```swift
struct NotificationRule {
    var id: UUID
    var purchaseItemId: UUID
    var targetType: NotificationTargetType
    var daysBefore: Int
    var isEnabled: Bool
    var notificationIdentifier: String
}
```

`NotificationTargetType`:

```swift
enum NotificationTargetType: String, Codable {
    case warranty
    case returnWindow
}
```

---

## 13. File storage locale

### 13.1 Strategia raccomandata

Usare database per metadati e FileManager per allegati.

Struttura sandbox:

```text
Application Support/
  ReceiptWarrantyVault/
    Attachments/
      <purchaseItemId>/
        <attachmentId>.pdf
        <attachmentId>.jpg
    Exports/
    Backups/
```

### 13.2 Requisiti

- Non salvare immagini/PDF grandi direttamente nel database.
- Usare nomi file generati internamente, non direttamente nomi originali non sanitizzati.
- Conservare MIME type e original filename come metadata.
- Eliminare file allegati quando si elimina l’acquisto.
- Gestire file mancanti con UI non bloccante.
- Escludere cache temporanee dal backup del dispositivo.
- Valutare file protection attributes.

### 13.3 Backup iCloud dispositivo

Poiché il prodotto è local-first/privacy-first, aggiungere impostazione:

```text
Include documents in device backup
```

Default da decidere:

- privacy massima: disattivare backup automatico documenti e spingere export manuale;
- sicurezza perdita dati: consentire backup dispositivo iCloud gestito da Apple.

Raccomandazione: spiegare chiaramente all’utente. Non attivare sync cloud proprietario.

---

## 14. Calcolo scadenze

### 14.1 Garanzia

Default globale:

```text
24 months
```

Ma deve essere un suggerimento modificabile.

Regola:

```text
warrantyEndDate = purchaseDate + durationMonths
```

Gestire casi calendario correttamente:

- fine mese;
- anni bisestili;
- timezone;
- daylight saving.

Usare Calendar APIs.

### 14.2 Reso

Default globale configurabile:

```text
14 days
```

Opzioni rapide:

- none;
- 7 days;
- 14 days;
- 30 days;
- 60 days;
- 90 days;
- custom date.

### 14.3 Stati

Per una scadenza:

- `expired`: endDate < today start/end logic;
- `today`: endDate is today;
- `soon`: entro soglia configurabile;
- `active`: futura;
- `unknown`: nessuna data.

Non confrontare Date con stringhe.

---

## 15. Privacy, permessi e App Store privacy label

### 15.1 Dati raccolti

Obiettivo v1:

```text
Data collected by developer: none
Tracking: no
Third-party data sharing: no
```

Verificare attentamente prima della submission. Se si aggiunge anche un solo SDK o servizio esterno, aggiornare questa sezione e App Store Connect.

### 15.2 Privacy policy

Anche se non si raccolgono dati, per App Store Connect iOS è richiesta una privacy policy URL. Creare una privacy policy semplice che dica:

- l’app salva dati localmente sul dispositivo;
- lo sviluppatore non riceve ricevute, documenti, prezzi o dati personali;
- non ci sono account;
- non ci sono ads;
- non c’è tracking;
- eventuali export sono azioni manuali dell’utente;
- eventuali backup dispositivo dipendono dalle impostazioni Apple/iCloud dell’utente;
- l’utente può cancellare i dati eliminando elementi nell’app o eliminando l’app.

### 15.3 Purpose strings Info.plist

Inserire e localizzare purpose strings:

#### Camera

Key:

```text
NSCameraUsageDescription
```

English:

```text
Camera access is used to scan receipts, invoices, and warranty documents. Scans stay on your device.
```

Italian:

```text
L’accesso alla fotocamera serve per scansionare scontrini, fatture e documenti di garanzia. Le scansioni restano sul dispositivo.
```

#### Photo Library

Se serve leggere/importare immagini:

```text
NSPhotoLibraryUsageDescription
```

English:

```text
Photo library access is used to import receipt and product images you choose. Imported files stay on your device.
```

Italian:

```text
L’accesso alla libreria foto serve per importare immagini di scontrini e prodotti che scegli tu. I file importati restano sul dispositivo.
```

Se l’app salva immagini nella libreria foto, aggiungere anche key appropriata per add-only usage, ma evitare salvo necessità.

#### Face ID

```text
NSFaceIDUsageDescription
```

English:

```text
Face ID is used to protect access to your saved receipts and warranty documents.
```

Italian:

```text
Face ID viene usato per proteggere l’accesso ai tuoi scontrini e documenti di garanzia salvati.
```

### 15.4 Notifiche

Le notifiche richiedono permesso utente. Chiedere al momento giusto.

Copy pre-permission:

English:

```text
Get reminders before return windows and warranties expire. Notifications are scheduled locally on your device.
```

Italian:

```text
Ricevi promemoria prima che scadano resi e garanzie. Le notifiche vengono programmate localmente sul dispositivo.
```

### 15.5 Minimizzazione dati

Non chiedere:

- posizione;
- contatti;
- calendario;
- tracking permission;
- microfono;
- bluetooth;
- rete locale.

A meno di future feature molto specifiche.

---

## 16. App Store compliance

### 16.1 App Review Guidelines

Prestare attenzione a:

- performance;
- app completa e non placeholder;
- niente crash;
- privacy policy accurata;
- dichiarazioni privacy coerenti;
- niente claim ingannevoli;
- permessi richiesti solo per funzioni reali;
- contenuto generato dall’utente solo locale e controllato dall’utente.

### 16.2 App Privacy Details

Compilare App Store Connect coerentemente con il codice.

Se v1 non invia dati allo sviluppatore:

- nessun dato raccolto;
- nessun tracking;
- nessuna terza parte.

Attenzione: se si aggiungono crash analytics, analytics, support SDK o cloud, la risposta cambia.

### 16.3 Export compliance

Se l’app usa solo crittografia fornita da Apple OS, Keychain, HTTPS Apple APIs, file protection o LocalAuthentication, verificare in App Store Connect le domande di export compliance. Apple indica che app che usano encryption limitata a quella nel sistema operativo possono non richiedere documentazione aggiuntiva, ma la valutazione va fatta in App Store Connect.

Non implementare crittografia proprietaria nella v1. Se si implementa backup cifrato custom in v2, rivalutare export compliance.

### 16.4 In-app purchases

Se si sceglie free + lifetime unlock:

- usare StoreKit 2;
- prodotto non-consumable;
- ripristino acquisti;
- nessun abbonamento;
- paywall chiaro;
- non bloccare accesso ai dati già creati se cambia stato acquisto in modo ambiguo.

Se si sceglie paid upfront:

- non usare IAP nella v1.

### 16.5 Metadati App Store

Evitare claim assoluti non verificabili:

Non dire:

```text
Guaranteed legal protection worldwide.
```

Dire:

```text
Store your receipts and set reminders for warranty and return deadlines.
```

Non dire:

```text
100% secure.
```

Dire:

```text
Designed to keep your documents on your device, without accounts or tracking.
```

---

## 17. Accessibilità

Requisiti minimi:

- supporto Dynamic Type;
- VoiceOver labels per bottoni e card;
- contrasto adeguato;
- non usare solo colore per comunicare scadenza;
- touch target adeguati;
- supporto Reduce Motion;
- supporto Light/Dark Mode;
- testi scalabili;
- icone accompagnate da label;
- accessibilità per PDF/immagini dove possibile.

Esempi:

- Badge rosso “Expired” deve avere anche testo.
- Card con documento deve avere accessibility label: `Receipt for MacBook Air`.

---

## 18. Design UI

### 18.1 Stile

- moderno;
- pulito;
- trust-oriented;
- premium;
- poche schermate;
- card leggibili;
- icone SF Symbols quando possibile;
- colori semantici coerenti;
- no UI troppo “fintech” o contabile.

### 18.2 Tab bar

Tab consigliati:

1. `Deadlines`
2. `Archive`
3. `Scan`
4. `Settings`

In italiano:

1. `Scadenze`
2. `Archivio`
3. `Scansiona`
4. `Impostazioni`

### 18.3 Empty states

Ogni stato vuoto deve guidare l’utente.

Esempio:

English:

```text
No receipts yet
Scan your first receipt and set a warranty reminder in less than a minute.
```

Italian:

```text
Nessuno scontrino salvato
Scansiona il primo scontrino e imposta un promemoria garanzia in meno di un minuto.
```

### 18.4 Colori stato

Usare colori semantici, ma non dipendere solo da essi:

- active: green/accent;
- expiring soon: yellow/orange;
- expired: red;
- archived: gray.

---

## 19. Icona app

### 19.1 Requisiti

- Nessuna scritta.
- Nessun bordo.
- Immagine piena.
- Simboli internazionali.
- Deve funzionare in piccolo.
- Deve rispettare HIG App Icons.
- Asset catalog iOS con immagine app icon 1024 pt.

### 19.2 Concept consigliato

Elementi:

- ricevuta;
- cartella/cassaforte;
- scudo/lucchetto;
- piccolo calendario/check;
- eventuale simbolo valuta discreto.

Non inserire parole come “Receipt”, “Warranty”, “Garanzia”.

---

## 20. App Store metadata iniziali

### 20.1 English

App name:

```text
Warranty Vault
```

Subtitle:

```text
Private receipts & reminders
```

Promotional text:

```text
Keep receipts, invoices, warranties, and return deadlines organized on your device. No account, no tracking, no subscription.
```

Description draft:

```text
Warranty Vault is a private place for your receipts, invoices, warranty documents, and return deadlines.

Scan or import a receipt, add the purchase date, and set warranty or return reminders in seconds. Your documents stay on your device, with no account, no ads, and no tracking.

Features:
• Scan receipts and warranty documents
• Save invoices, product photos, serial numbers, and notes
• Set local reminders before warranties and returns expire
• Organize purchases by category and store
• Protect access with Face ID or Touch ID
• Export your records when you need them
• Works offline
• Designed for privacy

Warranty rules vary by country, seller, and product. Warranty Vault helps you organize your documents and reminders, but it does not provide legal advice.
```

Keywords:

```text
receipt,warranty,invoice,returns,scanner,documents,reminders,offline,privacy
```

### 20.2 Italian

Nome:

```text
Scontrini & Garanzie
```

Sottotitolo:

```text
Ricevute private e scadenze
```

Testo promozionale:

```text
Tieni scontrini, fatture, garanzie e resi in ordine sul tuo dispositivo. Nessun account, nessun tracking, nessun abbonamento.
```

Descrizione draft:

```text
Scontrini & Garanzie è un archivio privato per ricevute, fatture, documenti di garanzia e scadenze di reso.

Scansiona o importa uno scontrino, aggiungi la data di acquisto e imposta promemoria per garanzie e resi in pochi secondi. I tuoi documenti restano sul dispositivo, senza account, pubblicità o tracking.

Funzioni:
• Scansiona scontrini e documenti di garanzia
• Salva fatture, foto prodotto, numeri seriali e note
• Ricevi promemoria locali prima della scadenza di garanzie e resi
• Organizza acquisti per categoria e negozio
• Proteggi l’accesso con Face ID o Touch ID
• Esporta i tuoi dati quando ti servono
• Funziona offline
• Progettata per la privacy

Le regole di garanzia variano in base a paese, venditore e prodotto. L’app aiuta a organizzare documenti e promemoria, ma non fornisce consulenza legale.
```

Keywords:

```text
scontrini,garanzia,fattura,resi,scanner,documenti,promemoria,offline,privacy
```

---

## 21. Impostazioni app

Schermata Settings:

- Default warranty duration
- Default return window
- Default currency
- Notifications
- Face ID / Touch ID lock
- Export data
- Delete all data
- Privacy
- About
- Legal disclaimer
- App language link/instructions if system-based
- Version number

### 21.1 Lingua app

Su iOS, la lingua app può essere gestita dal sistema se l’app è localizzata. Non implementare un sistema custom di lingua salvo necessità. Aggiungere eventualmente un link/istruzione:

```text
To change app language, use iOS Settings > Apps > Warranty Vault > Language.
```

Localizzare.

---

## 22. Legal disclaimer

Inserire nelle impostazioni e nei metadata:

English:

```text
Warranty Vault helps you organize documents and reminders. Warranty and return rules may vary by country, seller, product type, and contract. The app does not provide legal advice.
```

Italian:

```text
L’app aiuta a organizzare documenti e promemoria. Le regole su garanzie e resi possono variare in base a paese, venditore, tipo di prodotto e contratto. L’app non fornisce consulenza legale.
```

---

## 23. Test plan

### 23.1 Unit test

Testare:

- calcolo data garanzia;
- calcolo reso;
- edge case fine mese;
- leap year;
- formattazione valuta;
- formattazione date;
- ordinamento scadenze;
- cancellazione notifiche;
- export JSON.

### 23.2 UI test

Flussi:

1. primo avvio;
2. aggiunta manuale;
3. scansione documento mock;
4. import allegato;
5. modifica garanzia;
6. filtro archivio;
7. ricerca;
8. attiva Face ID mock;
9. export;
10. cancellazione item.

### 23.3 Localization test

Test obbligatori:

- English;
- Italian;
- pseudo-localization se disponibile;
- testi lunghi;
- Dynamic Type extra large;
- RTL smoke test;
- date US vs EU;
- valuta USD/EUR/JPY.

### 23.4 Privacy test

Verificare:

- nessuna chiamata di rete non necessaria;
- nessun SDK terze parti;
- documenti salvati localmente;
- export solo su azione utente;
- permessi richiesti solo quando necessari;
- no ATT prompt.

---

## 24. Acceptance criteria per Codex

L’implementazione è accettabile solo se:

1. L’app compila in Xcode senza errori.
2. La UI principale è SwiftUI.
3. Tutte le stringhe utente sono localizzate tramite String Catalog.
4. Esistono localizzazioni EN e IT complete per le stringhe principali.
5. Date e valute rispettano locale utente.
6. Ogni acquisto supporta valuta ISO diversa.
7. L’app funziona offline.
8. Non è presente backend.
9. Non sono presenti SDK analytics/ads/tracking.
10. La scansione documenti usa VisionKit o fallback documentato.
11. Gli allegati sono salvati localmente con FileManager.
12. Il database salva metadata, non blob enormi.
13. Le notifiche sono locali e cancellate/aggiornate correttamente.
14. Face ID/Touch ID è opzionale.
15. Esiste export almeno per singolo acquisto e backup JSON/ZIP.
16. Privacy strings sono presenti e localizzate.
17. UI supporta Dark Mode e Dynamic Type.
18. Non ci sono claim legali assoluti.
19. Il progetto è predisposto per App Store metadata localizzati.
20. Il codice è modulare e leggibile.

---

## 25. Anti-requisiti

Non implementare:

- Firebase;
- Google Analytics;
- Meta SDK;
- account;
- login;
- server;
- OCR cloud;
- AI cloud;
- subscription;
- ads;
- raccolta email;
- tracciamento;
- hardcoded Italian-only UI;
- hardcoded EUR-only;
- hardcoded 24-month warranty as universal legal truth.

---

## 26. Note operative per Codex

Quando generi codice:

- preferire semplicità e stabilità a over-engineering;
- commentare le scelte privacy;
- separare modello, servizi e viste;
- inserire TODO solo dove inevitabile;
- non lasciare placeholder visibili all’utente;
- usare nomi in inglese nel codice;
- usare localized display strings per la UI;
- creare mock data localizzata per preview;
- non usare network calls;
- non aggiungere dipendenze esterne senza necessità;
- non usare secrets o API keys.

---

## 27. Sequenza di sviluppo consigliata

1. Creare progetto SwiftUI.
2. Configurare localizzazione EN/IT e String Catalog.
3. Creare modelli locali.
4. Implementare storage metadata.
5. Implementare file storage.
6. Implementare Dashboard.
7. Implementare Archive.
8. Implementare Purchase Form.
9. Implementare Purchase Detail.
10. Implementare Scanner VisionKit.
11. Implementare Notifications.
12. Implementare Settings.
13. Implementare Face ID.
14. Implementare Export.
15. Implementare privacy/legal screens.
16. Testare localizzazione.
17. Preparare App Store metadata.

---

## 28. Rischi e mitigazioni

### 28.1 Utente teme perdita dati

Mitigazione:

- export facile;
- reminder backup;
- spiegazione chiara;
- eventualmente backup cifrato v2.

### 28.2 App percepita troppo semplice

Mitigazione:

- UX premium;
- Face ID;
- notifiche;
- export;
- localizzazione;
- privacy forte;
- scanner nativo.

### 28.3 Differenze legali tra paesi

Mitigazione:

- default modificabili;
- disclaimer;
- nessun claim legale assoluto;
- preset regionali solo come suggerimenti.

### 28.4 OCR imperfetto

Mitigazione:

- non promettere OCR nella v1;
- input manuale veloce;
- OCR on-device come enhancement futuro.

---

## 29. KPI di prodotto

Per valutare successo:

- tempo medio per aggiungere primo acquisto < 60 secondi;
- crash-free sessions > 99%;
- percentuale utenti che aggiungono almeno 2 acquisti;
- percentuale utenti che attivano notifiche;
- recensioni App Store con keyword privacy/semplicità;
- conversione paid/lifetime se free trial.

Non usare analytics invasive nella v1. Se servono metriche in futuro, valutare solo analytics privacy-preserving e aggiornare privacy disclosure.

---

## 30. Conclusione

L’app deve essere una piccola utility globale, elegante e affidabile. Il valore non è “AI” o “cloud”, ma:

- ordine;
- promemoria;
- privacy;
- controllo;
- semplicità;
- lancio internazionale.

La direzione corretta è:

```text
One-time payment.
Local-first.
No account.
No tracking.
Global-ready.
Apple-native.
```

Questo documento deve essere trattato come specifica prioritaria per la prima implementazione.
