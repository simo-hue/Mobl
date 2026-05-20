// Bilingual Translation Dictionary (EN / IT)
const translations = {
  en: {
    // Navigation
    nav_home: "Home",
    nav_privacy: "Privacy",
    nav_support: "Support",
    nav_terms: "Terms",
    
    // Index Page - Hero
    hero_badge: "🔒 100% Private & Local",
    hero_title: "Never Lose a Receipt Again.",
    hero_subtitle: "Scan receipts, track warranties and returns, and keep purchase documents organized privately on your iPhone. No account, no ads, no subscription.",
    mockup_logo_text: "Warranties Vault",
    mockup_c1_title: "iPhone 15 Pro Max",
    mockup_c1_sub: "Apple Store — $1,199",
    mockup_c1_badge: "18 Months Left",
    mockup_c2_title: "Office Desk Chair",
    mockup_c2_sub: "IKEA — $249",
    mockup_c2_badge: "Expires in 6 Days",
    mockup_c3_title: "Coffee Machine",
    mockup_c3_sub: "Amazon — $599",
    mockup_c3_badge: "3 Years Left",
    mockup_c4_title: "Sony Headphones",
    mockup_c4_sub: "Amazon — $349",
    mockup_c4_badge: "9 Months Left",
    
    // Index Page - Features
    features_label: "Capabilities",
    features_title: "Designed for Your Purchase Archives",
    f1_title: "Scan Receipts & Invoices",
    f1_desc: "Use the native iOS document scanner to capture receipts before ink fades, or import PDFs directly from your Files application.",
    f2_title: "Track Warranty Deadlines",
    f2_desc: "Input warranty duration and purchase dates. The app calculates exact expiration dates and highlights critical timelines.",
    f3_title: "Smart Local Reminders",
    f3_desc: "Receive automatic notifications on your device before a return window closes or a manufacturer warranty expires.",
    f4_title: "Face ID / Touch ID Security",
    f4_desc: "Secure your purchase data. Enable optional biometric authentication to keep invoices and receipts protected from prying eyes.",
    f5_title: "Native PDF & Zip Backup",
    f5_desc: "Export individual receipts as high-quality PDFs or output a compressed ZIP backup containing your entire structural data archive.",
    f6_title: "Offline Independence",
    f6_desc: "No cloud services required. All processing, document scanning, and text recognition occurs strictly on your device.",

    // Index Page - Privacy Callout
    priv_badge: "🔒 Zero Tracking",
    priv_title: "Your Data Stays on Your Device. Period.",
    priv_desc: "Warranties Vault is designed from the ground up to respect your digital privacy. We don't host databases, collect logs, or track your behavior. Everything you save remains locked securely inside your iOS sandbox.",
    priv_m1: "Accounts",
    priv_m2: "Offline-first",
    priv_m3: "Ads / Trackers",

    // Footer
    footer_tagline: "Keep receipts, invoices, and warranties organized and private on your iPhone.",
    footer_title_legal: "Compliance",
    footer_title_support: "Support",
    footer_copyright: "© 2026 Simo. All rights reserved.",
    footer_legal_notes: "Warranties Vault is an independent application. App Store and iOS are trademarks of Apple Inc.",

    // Privacy Policy Page
    priv_page_title: "Privacy Policy",
    priv_page_subtitle: "Effective date: May 20, 2026",
    priv_sec1_title: "1. Local-First Architecture",
    priv_sec1_desc1: "Warranties Vault is built as a local-first application. This means that all receipts, invoices, warranty documents, product photos, prices, notes, and reminders are stored exclusively on your individual iOS device. They never leave your device unless you explicitly decide to share or export them.",
    priv_sec1_desc2: "As the developer, I do not receive, collect, store, or have access to any of your documents, purchase data, notes, or personal information.",
    priv_sec2_title: "2. Device Permissions Used",
    priv_sec2_desc1: "To perform its functions natively, the app requests standard iOS permissions when necessary:",
    priv_sec2_li1: "<strong>Camera Access:</strong> Used solely to capture physical receipts using the built-in document scanner.",
    priv_sec2_li2: "<strong>Photo Library / Files:</strong> Used only when you manually choose to import existing receipt photos, product images, or PDF invoices.",
    priv_sec2_li3: "<strong>Face ID / Touch ID:</strong> Optional biometric security used exclusively to restrict access to the app on your physical device.",
    priv_sec2_li4: "<strong>Notifications:</strong> Used only to trigger local alerts on your device for upcoming warranty or return deadlines. No external servers are involved in scheduling notifications.",
    priv_sec3_title: "3. Data Sharing & Tracking",
    priv_sec3_desc1: "We respect your digital footprint:",
    priv_sec3_li1: "<strong>No Tracking:</strong> The application does not track your online activities across websites or other third-party apps.",
    priv_sec3_li2: "<strong>No SDKs:</strong> There are no advertising SDKs, third-party analytics trackers, or social sign-ins compiled in the application code.",
    priv_sec3_li3: "<strong>Third-Party Sharing:</strong> Zero data is shared with third parties. All processing is processed completely offline on your silicon.",
    priv_sec4_title: "4. App Store Declarations",
    priv_sec4_desc1: "In accordance with Apple Store review guidelines, the declared specifications for Warranties Vault v1 are:",
    priv_sec4_li1: "<strong>Tracking:</strong> No",
    priv_sec4_li2: "<strong>Data Collected by Developer:</strong> None",
    priv_sec4_li3: "<strong>Third-party Data Sharing:</strong> None",
    priv_sec5_title: "5. Data Retention & Backups",
    priv_sec5_desc1: "Since all data is saved in the local app container, you maintain absolute control over retention:",
    priv_sec5_desc2: "You can delete individual purchases or attachments, purge all database files directly from the app's settings screen, or completely remove the application from your device to erase all structural archives. Backups are created only if you trigger an active ZIP export or depend on standard iCloud device backups.",
    sidebar_priv_title: "Privacy Summary",
    sidebar_priv_desc: "Warranties Vault does not collect, sell, or receive any user documents or personal details. The app operates completely offline-first.",
    sidebar_support_title: "Need Clarity?",
    sidebar_support_desc: "If you have any questions about how your local permissions are handled, feel free to contact support.",
    sidebar_support_btn: "Get Support",

    // Support Page
    sup_page_title: "Support & Help Desk",
    sup_page_subtitle: "Frequently asked questions and direct technical support",
    sup_faq_title: "Frequently Asked Questions",
    sup_q1: "Where is my data stored?",
    sup_a1: "All files, scanned receipts, databases, and configuration settings are stored locally on your device within the app sandbox. There is no external database or server storing your documents.",
    sup_q2: "What happens if I lose or change my iPhone?",
    sup_a2: "Because Warranties Vault is entirely local and does not sync to custom databases, we recommend using standard iOS/iCloud system backups or manually exporting a compressed ZIP backup from the Settings screen inside the app to save elsewhere.",
    sup_q3: "Can I import digital invoices (PDFs)?",
    sup_a3: "Yes! You can choose to import existing PDF invoices, camera images, or physical scans from either your Files app or your photo library directly into your digital archive.",
    sup_q4: "Is biometric protection available?",
    sup_a4: "Absolutely. You can enable optional Face ID or Touch ID lock inside the in-app settings panel to require authentication every time you open your receipt archive.",
    sup_form_title: "Email Support",
    sup_form_desc: "Having technical difficulties? Have suggestions for future releases? Use the form below to open a prefilled email to the developer.",
    sup_form_name: "Full Name",
    sup_form_email: "Email Address",
    sup_form_msg: "Support Message / Issue Description",
    sup_form_submit: "Open Email",
    sup_form_success: "Email draft opened. If it does not open automatically, write to mattioli.simone.10@gmail.com.",
    sidebar_contact_title: "Direct Contact",
    sidebar_contact_desc: "You can also write directly via email regarding queries, business requests, or legal matters.",

    // Terms Page
    terms_page_title: "Terms of Service",
    terms_page_subtitle: "Terms of Use & End User License Agreement (EULA)",
    terms_sec1_title: "1. Introduction & Terms",
    terms_sec1_desc1: "By downloading, installing, or accessing the Warranties Vault application from the iOS App Store, you agree to comply with and be legally bound by these Terms of Service. If you do not accept these terms, do not install or use the app.",
    terms_sec1_desc2: "We reserve the right to modify these terms at any time. Your continued use of the application following updates constitutes your acceptance of the revised conditions.",
    terms_sec2_title: "2. App Store License & Distribution",
    terms_sec2_desc1: "Warranties Vault is licensed to you under a limited, non-transferable, non-exclusive, revocable license for personal, non-commercial use on Apple products that you own or control, in accordance with the Apple App Store Terms of Service (EULA).",
    terms_sec2_desc2: "The application is distributed through the App Store. There are no compiled ads, recurring subscriptions, in-app purchases, or hidden StoreKit paywalls in the current version.",
    terms_sec3_title: "3. Data Responsibility & Offline Limits",
    terms_sec3_desc1: "Warranties Vault is designed as a local-first software utility. Document scanning, PDF rendering, file protection, and storage operate locally in your device container.",
    terms_sec3_desc2: "Critical Backup Obligation: Because the developer has no cloud servers or network databases containing your receipts and files, you have complete and exclusive responsibility to back up your purchase data using either Apple's built-in iCloud system backup utilities or manually exporting ZIP archive bundles from the Settings section within the app.",
    terms_sec3_desc3: "The developer is not liable for any data loss, database corruption, structural failure, or hardware damage resulting in the loss of your documents.",
    terms_sec4_title: "4. Warranty & Return Deadlines",
    terms_sec4_desc1: "Warranty and return regulations are governed by contracts, retail agreements, store policies, and local state laws. The deadline dates, reminders, and alerts calculated inside the app are meant purely as a structured organization tool.",
    terms_sec4_desc2: "Warranties Vault does not guarantee successful warranty fulfillment, refunds, or retail store returns, and does not provide legal, financial, or consumer advice. Please verify exact store policies manually.",
    terms_sec5_title: "5. Disclaimer of Warranties",
    terms_sec5_desc1: "The application is provided 'AS IS' and 'AS AVAILABLE' without warranties of any kind, either express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, or non-infringement.",
    sidebar_terms_title: "EULA Policy",
    sidebar_terms_desc: "Standard license terms are governed by Apple's Standard End User License Agreement (EULA). All documents are processed completely offline."
  },
  it: {
    // Navigazione
    nav_home: "Home",
    nav_privacy: "Privacy",
    nav_support: "Supporto",
    nav_terms: "Termini",
    
    // Index Page - Hero
    hero_badge: "🔒 100% Privato & Locale",
    hero_title: "Non Perdere Mai Più uno Scontrino.",
    hero_subtitle: "Tieni scontrini, fatture, garanzie e resi in ordine sul tuo dispositivo. Nessun account, nessun tracking, nessun abbonamento.",
    mockup_logo_text: "Scontrini & Garanzie",
    mockup_c1_title: "iPhone 15 Pro Max",
    mockup_c1_sub: "Apple Store — 1.199 €",
    mockup_c1_badge: "18 Mesi Rimasti",
    mockup_c2_title: "Sedia da Scrivania",
    mockup_c2_sub: "IKEA — 249 €",
    mockup_c2_badge: "Scade in 6 Giorni",
    mockup_c3_title: "Macchina del Caffè",
    mockup_c3_sub: "Amazon — 599 €",
    mockup_c3_badge: "3 Anni Rimasti",
    mockup_c4_title: "Sony Cuffie",
    mockup_c4_sub: "Amazon — 349 €",
    mockup_c4_badge: "9 Mesi Rimasti",
    
    // Index Page - Funzioni
    features_label: "Funzionalità",
    features_title: "Progettato per il tuo archivio privato",
    f1_title: "Scansiona Scontrini e Fatture",
    f1_desc: "Usa lo scanner di documenti nativo di iOS per acquisire scontrini prima che l'inchiostro sbiadisca, o importa PDF direttamente dai File.",
    f2_title: "Traccia le Garanzie",
    f2_desc: "Inserisci la durata della garanzia e la data di acquisto. L'app calcola la data di scadenza esatta ed evidenzia le scadenze critiche.",
    f3_title: "Promemoria Locali Intelligenti",
    f3_desc: "Ricevi notifiche automatiche sul tuo dispositivo prima che si chiuda un periodo di reso o scada una garanzia del produttore.",
    f4_title: "Sicurezza Face ID / Touch ID",
    f4_desc: "Proteggi i tuoi dati di acquisto. Abilita l'autenticazione biometrica opzionale per tenere al sicuro fatture e scontrini da sguardi indiscreti.",
    f5_title: "Esportazione PDF & Backup ZIP",
    f5_desc: "Esporta singoli scontrini in PDF ad alta qualità o effettua un backup ZIP completo contenente l'intero archivio strutturato.",
    f6_title: "Funzionamento Offline",
    f6_desc: "Nessun servizio cloud richiesto. Tutte le elaborazioni, la scansione dei documenti e il riconoscimento del testo avvengono offline sul dispositivo.",

    // Index Page - Privacy
    priv_badge: "🔒 Zero Tracciamento",
    priv_title: "I tuoi dati restano sul dispositivo. Sempre.",
    priv_desc: "L'app è progettata da zero per rispettare la tua privacy digitale. Non ospitiamo database, non raccogliamo log e non tracciamo il tuo comportamento. Tutto rimane memorizzato in sicurezza nella sandbox del tuo iPhone.",
    priv_m1: "Account",
    priv_m2: "Offline",
    priv_m3: "Tracker / Ad",

    // Footer
    footer_tagline: "Organizza scontrini, fatture e garanzie in totale privacy sul tuo iPhone.",
    footer_title_legal: "Conformità",
    footer_title_support: "Supporto",
    footer_copyright: "© 2026 Simo. Tutti i diritti riservati.",
    footer_legal_notes: "Scontrini & Garanzie è un'applicazione indipendente. App Store e iOS sono marchi registrati di Apple Inc.",

    // Privacy Policy Page
    priv_page_title: "Politica sulla Privacy",
    priv_page_subtitle: "Data di decorrenza: 20 Maggio 2026",
    priv_sec1_title: "1. Architettura Locale-First",
    priv_sec1_desc1: "Scontrini & Garanzie è progettata come un'applicazione locale-first. Ciò significa che tutti gli scontrini, le fatture, i documenti di garanzia, le foto, i prezzi, le note e i promemoria sono memorizzati esclusivamente sul tuo dispositivo iOS. Non lasciano mai il dispositivo a meno che tu non decida esplicitamente di esportarli.",
    priv_sec1_desc2: "Come sviluppatore, non ricevo, raccolgo, memorizzo né ho accesso a nessuno dei tuoi documenti, dati di acquisto, note o informazioni personali.",
    priv_sec2_title: "2. Permessi del Dispositivo Utilizzati",
    priv_sec2_desc1: "Per svolgere le sue funzioni, l'applicazione richiede permessi standard di iOS solo quando necessario:",
    priv_sec2_li1: "<strong>Accesso Fotocamera:</strong> Utilizzato esclusivamente per acquisire scontrini cartacei tramite lo scanner di documenti integrato.",
    priv_sec2_li2: "<strong>Libreria Foto / File:</strong> Utilizzato solo quando scegli manualmente di importare foto di scontrini, immagini prodotto o fatture PDF.",
    priv_sec2_li3: "<strong>Face ID / Touch ID:</strong> Protezione biometrica opzionale utilizzata esclusivamente per proteggere l'accesso all'app sul tuo dispositivo.",
    priv_sec2_li4: "<strong>Notifiche:</strong> Utilizzate solo per attivare avvisi locali sul tuo dispositivo per le scadenze imminenti di resi e garanzie. Nessun server esterno è coinvolto nella pianificazione.",
    priv_sec3_title: "3. Condivisione dei Dati & Tracciamento",
    priv_sec3_desc1: "Rispettiamo la tua impronta digitale:",
    priv_sec3_li1: "<strong>Nessun Tracciamento:</strong> L'applicazione non traccia le tue attività online su siti web o altre applicazioni.",
    priv_sec3_li2: "<strong>Nessun SDK Esterno:</strong> Nel codice dell'applicazione non sono presenti SDK pubblicitari, tracciatori analitici di terze parti o sistemi di accesso social.",
    priv_sec3_li3: "<strong>Condivisione con Terzi:</strong> Nessun dato viene condiviso. Tutte le elaborazioni avvengono completamente offline sul tuo processore.",
    priv_sec4_title: "4. Dichiarazioni App Store",
    priv_sec4_desc1: "In conformità con le linee guida di Apple Store, le specifiche dichiarate per la versione v1 sono:",
    priv_sec4_li1: "<strong>Tracciamento:</strong> No",
    priv_sec4_li2: "<strong>Dati Raccolti dallo Sviluppatore:</strong> Nessuno",
    priv_sec4_li3: "<strong>Condivisione con terze parti:</strong> Nessuna",
    priv_sec5_title: "5. Conservazione dei Dati & Backup",
    priv_sec5_desc1: "Poiché tutti i dati sono salvati nel contenitore locale dell'app, mantieni il controllo assoluto sulla loro conservazione:",
    priv_sec5_desc2: "Puoi eliminare singoli acquisti o allegati, svuotare completamente il database dalle impostazioni dell'app o rimuovere l'applicazione dal dispositivo per cancellare tutto l'archivio. I backup vengono creati solo se effettui un'esportazione ZIP manuale o tramite il backup iCloud globale del dispositivo.",
    sidebar_priv_title: "Sintesi Privacy",
    sidebar_priv_desc: "Scontrini & Garanzie non raccoglie, vende o riceve alcun documento o dato personale dell'utente. Funziona completamente offline.",
    sidebar_support_title: "Domande?",
    sidebar_support_desc: "In caso di dubbi sulla gestione dei permessi locali, non esitare a contattare l'assistenza.",
    sidebar_support_btn: "Ottieni Supporto",

    // Support Page
    sup_page_title: "Supporto & Assistenza",
    sup_page_subtitle: "Domande frequenti e supporto tecnico diretto",
    sup_faq_title: "Domande Frequenti (FAQ)",
    sup_q1: "Dove sono memorizzati i miei dati?",
    sup_a1: "Tutti i file, gli scontrini scansionati, il database e le impostazioni sono salvati localmente sul dispositivo all'interno della sandbox dell'app. Non c'è alcun database esterno.",
    sup_q2: "Cosa succede se perdo o cambio il mio iPhone?",
    sup_a2: "Poiché l'app è completamente offline, ti consigliamo di utilizzare i backup di sistema iOS/iCloud o di esportare periodicamente un archivio ZIP dalle impostazioni dell'app da salvare in sicurezza.",
    sup_q3: "Posso importare fatture digitali in formato PDF?",
    sup_a3: "Sì! Puoi importare fatture PDF, foto esistenti o scansioni direttamente dall'applicazione File o dalla tua libreria fotografica.",
    sup_q4: "È disponibile la protezione biometrica?",
    sup_a4: "Certamente. Puoi abilitare lo sblocco tramite Face ID o Touch ID dalle impostazioni interne dell'app per richiedere l'autenticazione a ogni apertura.",
    sup_form_title: "Supporto via Email",
    sup_form_desc: "Hai riscontrato problemi tecnici? Hai suggerimenti per le prossime versioni? Usa il modulo per aprire una bozza email indirizzata allo sviluppatore.",
    sup_form_name: "Nome Completo",
    sup_form_email: "Indirizzo Email",
    sup_form_msg: "Messaggio / Descrizione del Problema",
    sup_form_submit: "Apri Email",
    sup_form_success: "Bozza email aperta. Se non si apre automaticamente, scrivi a mattioli.simone.10@gmail.com.",
    sidebar_contact_title: "Contatto Diretto",
    sidebar_contact_desc: "Puoi anche scrivere direttamente via email per richieste commerciali, tecniche o legali.",

    // Terms Page
    terms_page_title: "Termini di Servizio",
    terms_page_subtitle: "Condizioni d'Uso e Accordo di Licenza con l'Utente Finale (EULA)",
    terms_sec1_title: "1. Introduzione e Condizioni",
    terms_sec1_desc1: "Scaricando, installando o accedendo all'applicazione Scontrini & Garanzie dall'App Store di Apple, accetti di rispettare ed essere vincolato dai presenti Termini di Servizio. Se non accetti queste condizioni, non installare o utilizzare l'applicazione.",
    terms_sec1_desc2: "Ci riserviamo il diritto di modificare questi termini in qualsiasi momento. L'uso continuato dell'app costituisce accettazione delle condizioni aggiornate.",
    terms_sec2_title: "2. Licenza App Store e Distribuzione",
    terms_sec2_desc1: "L'applicazione ti viene concessa in licenza limitata, non trasferibile, non esclusiva e revocabile per uso personale e non commerciale sui dispositivi Apple di tua proprietà, in conformità con i Termini dell'App Store (EULA).",
    terms_sec2_desc2: "L'applicazione è distribuita tramite App Store. Nella versione attuale non ci sono annunci pubblicitari, abbonamenti ricorrenti, acquisti in-app o paywall StoreKit nascosti.",
    terms_sec3_title: "3. Responsabilità dei Dati e Limiti dell'Offline",
    terms_sec3_desc1: "Scontrini & Garanzie è un software locale-first. Scansione documenti, rendering PDF, protezione file e archiviazione avvengono localmente nel contenitore dell'app.",
    terms_sec3_desc2: "Obbligo di Backup: Poiché non disponiamo di server cloud o database di rete contenenti le tue ricevute, l'utente è l'unico responsabile del backup dei propri dati, da effettuare tramite iCloud o esportando l'archivio ZIP dell'app.",
    terms_sec3_desc3: "Lo sviluppatore non è responsabile di alcuna perdita di dati, corruzione del database o problemi hardware che comportino la perdita dei documenti.",
    terms_sec4_title: "4. Scadenze di Garanzie e Resi",
    terms_sec4_desc1: "Le regole su garanzie e resi sono regolate dai singoli contratti, negozi e leggi locali. Le date e i promemoria forniti dall'app hanno solo scopo organizzativo.",
    terms_sec4_desc2: "L'app non garantisce il rimborso o l'accettazione del reso da parte dei negozi, né fornisce consulenza legale o finanziaria. Si prega di verificare manualmente le politiche dei venditori.",
    terms_sec5_title: "5. Esclusione di Garanzia",
    terms_sec5_desc1: "L'applicazione viene fornita 'COSÌ COM'È' e 'COME DISPONIBILE', senza garanzie di alcun tipo, esplicite o implicite.",
    sidebar_terms_title: "Accordo EULA",
    sidebar_terms_desc: "I termini di licenza standard sono regolati dall'accordo EULA standard di Apple. Tutti i documenti sono elaborati offline."
  }
};

// State Variables
let currentLanguage = 'en';

// Set language dynamics with CSS fade-in
function setLanguage(lang) {
  if (!translations[lang]) return;
  currentLanguage = lang;
  
  // Save preferences
  localStorage.setItem('warranties_vault_lang', lang);
  
  // Highlight active button
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.remove('active');
  });
  
  const activeBtn = document.getElementById(`lang-${lang}`);
  if (activeBtn) activeBtn.classList.add('active');

  // Set HTML lang attribute
  document.documentElement.setAttribute('lang', lang);
  
  // Set dynamic layout language classes on body
  document.body.className = `lang-${lang}`;

  // Select and translate elements
  const elements = document.querySelectorAll('[data-i18n]');
  
  // Apply a quick transition fade effect
  elements.forEach(el => {
    el.classList.add('fade-out');
  });

  setTimeout(() => {
    elements.forEach(el => {
      const key = el.getAttribute('data-i18n');
      if (translations[lang][key]) {
        // Handle elements with HTML structures
        if (el.tagName === 'LI' && el.innerHTML.includes('<strong>')) {
          // Keep structure but translate text parts (for permission rules)
          const boldText = el.querySelector('strong').textContent;
          // Determine key matching inside the HTML
          el.innerHTML = translations[lang][key];
        } else {
          el.innerHTML = translations[lang][key];
        }
      }
      el.classList.remove('fade-out');
    });
  }, 180);
}

// Interactive FAQs Accordions
document.addEventListener('DOMContentLoaded', () => {
  // Load saved language preference or default to browser language or 'en'
  const savedLang = localStorage.getItem('warranties_vault_lang');
  const browserLang = navigator.language.split('-')[0];
  
  if (savedLang) {
    setLanguage(savedLang);
  } else if (browserLang === 'it') {
    setLanguage('it');
  } else {
    setLanguage('en');
  }

  // Setup FAQs click triggers
  const faqQuestions = document.querySelectorAll('.faq-question');
  faqQuestions.forEach(question => {
    question.addEventListener('click', () => {
      const item = question.parentElement;
      const isActive = item.classList.contains('active');
      
      // Close other items
      document.querySelectorAll('.faq-item').forEach(faq => {
        faq.classList.remove('active');
      });
      
      if (!isActive) {
        item.classList.add('active');
      }
    });
  });

  // Setup Header Active navigation page state check
  const currentPath = window.location.pathname;
  const navLinks = document.querySelectorAll('.nav-link');
  
  navLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (currentPath.endsWith(href) || (currentPath === '/' && href === 'index.html')) {
      navLinks.forEach(l => l.classList.remove('active'));
      link.classList.add('active');
    }
  });
});

// Open a prefilled email draft for support requests.
function handleFormSubmit(event) {
  event.preventDefault();
  
  const form = document.getElementById('contactForm');
  const submitBtn = form.querySelector('.form-submit-btn');
  const statusMsg = document.getElementById('statusMessage');
  
  // Capture values
  const name = document.getElementById('nameInput').value;
  const email = document.getElementById('emailInput').value;
  const message = document.getElementById('messageInput').value;
  
  if (!name || !email || !message) return;
  
  // Disable submission while the mail client opens.
  submitBtn.disabled = true;
  const originalText = submitBtn.innerHTML;
  submitBtn.innerHTML = currentLanguage === 'it' ? 'Apertura email...' : 'Opening email...';

  const subject = encodeURIComponent('Warranties Vault support request');
  const body = encodeURIComponent(`Name: ${name}\nEmail: ${email}\n\n${message}`);
  window.location.href = `mailto:mattioli.simone.10@gmail.com?subject=${subject}&body=${body}`;

  statusMsg.style.display = 'block';
  statusMsg.textContent = currentLanguage === 'it'
    ? 'Bozza email aperta. Se non si apre automaticamente, scrivi a mattioli.simone.10@gmail.com.'
    : 'Email draft opened. If it does not open automatically, write to mattioli.simone.10@gmail.com.';

  setTimeout(() => {
    submitBtn.disabled = false;
    submitBtn.innerHTML = originalText;
  }, 1200);
}
