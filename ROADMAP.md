# Roadmap

Ogni step produce un risultato verificabile e non include lavoro degli step successivi.

| # | Step | Esito verificabile | Stato |
| --- | --- | --- | --- |
| 0 | Fondazione prodotto e design direction | documentazione, decisioni, confini e specifica visiva/motion approvati | completato |
| 1 | Bootstrap Flutter | app compilabile, lint e struttura feature-first | completato |
| 2 | Design system e navigazione | tema, componenti base e shell accessibile | completato |
| 3 | Dominio, database locale e localizzazione dei contenuti | entità localizzabili, migrazioni e repository contenuti/profilo offline | completato |
| 4 | Onboarding e profilo | preferenze locali modificabili | completato |
| 5 | Catalogo e dettaglio | seed revisionati, ricerca, filtri e lettura offline | completato |
| 6 | Home e idee a regole | proposte personalizzate spiegabili | completato |
| 7 | Archivio personale | salvataggi, cartelle, note e stati | completato (7A–7C) |
| 8 | Hardening e validazione MVP | percorso critico, avvio APK Android, polish visuale, matrice manuale e test Android | in corso (8A–8D) |
| 9 | Pipeline e catalogo editoriale | import offline, catalogo multilingua, archivio sorgenti privato, gate di pubblicazione ed espansione contenuti | in corso: 9A–9B, 9D e 9E implementati, 9C pianificato |

## Step 7A — Fondamenta tecniche Archivio personale

**Step 7A.** Implementati dominio Library, schema Drift v4 e migrazione non distruttiva v3 → v4, repository locale e wiring nel bootstrap per salvataggi, raccolte, note e stati. Le interfacce per salvare dal catalogo e consultare/modificare l'archivio sono esplicitamente rimandate agli Step 7B e 7C.

## Step 7B — Salvataggio dal dettaglio e Archivio in sola lettura

**Step 7B.** Implementati il toggle localizzato e accessibile `Salva`/`Salvato` nel dettaglio catalogo e la pagina Archivio in sola lettura, alimentata dai salvataggi locali e dai contenuti catalogo nella lingua attiva. Le mutazioni non sono ottimistiche e restano recuperabili in caso di errore. Note, raccolte, filtri, ricerca, modifica dello stato e rimozione dalla lista sono rimandati allo Step 7C.

## Step 7C — Gestione completa dell’Archivio personale

**Step 7C.** Completato l’Archivio locale con ricerca su contenuti e note, filtri combinabili per stato e raccolta, modifica di nota/stato/raccolta, rimozione con conferma e creazione, rinomina ed eliminazione delle raccolte. Le mutazioni attendono l’esito del repository e mostrano errori recuperabili; l’eliminazione di una raccolta conserva i salvataggi senza raccolta. Interfaccia e semantica sono localizzate nelle lingue di lancio. Lo schema Drift era alla versione 4; hardening generale e test d’integrazione end-to-end restano allo Step 8.


| 10 | Account e sync | auth opzionale, Firestore e conflitti gestiti | da fare |
| 11 | Monetizzazione | entitlement, paywall, acquisti e annunci con consenso | da fare |
| 12 | Strumenti e AI | calcolatori, dati esterni e analisi foto a crediti | da fare |

## Step 1 — Bootstrap Flutter

**Step 1 — Bootstrap Flutter.** Completato con Flutter 3.44.6/Dart 3.12.2: progetto Android/iOS, shell Material 3 con tema chiaro/scuro centralizzato, struttura iniziale `lib/app` e `lib/features/home/presentation`, schermata placeholder non commerciale e widget test. Non sono stati aggiunti Firebase, RevenueCat, AdMob, chiavi o package applicativi. Le schermate definitive, animazioni decorative e dipendenze grafiche restano bloccate fino allo Step 2.

## Step 2 — Design system e navigazione

**Step 2 — Design system e navigazione.** Completato con palette semantiche chiara/scura, tipografia, spaziature, raggi, elevazioni, layout e motion token centralizzati; shell GoRouter responsive con NavigationBar/NavigationRail, cinque route nominate e placeholder accessibili. La localizzazione usa ARB e `gen_l10n`, rileva la lingua del dispositivo e include inglese, italiano, spagnolo, francese, tedesco e portoghese brasiliano. Non sono stati implementati contenuti, persistenza, autenticazione o logica di business.

## Step 3 — Dominio, database locale e localizzazione dei contenuti

**Step 3 — Dominio, database locale e localizzazione dei contenuti.** Implementato: entità concettuali e traduzioni separate, database Drift/SQLite v1, mapper, repository offline per contenuti e profilo e test di vincoli/migrazione. Implementa la policy di fallback `locale completo → lingua base compatibile → inglese → indisponibile`, pacchetti per il solo locale selezionato, indici di ricerca localizzati e invalidazione delle traduzioni obsolete. Non implementa onboarding, UI di scelta lingua, catalogo, seed editoriali definitivi, pipeline di traduzione, sync, autenticazione o monetizzazione: tali esperienze restano negli step successivi.

## Step 4 — Onboarding e profilo

**Step 4 — Onboarding e profilo.** Implementato: il primo avvio richiede le preferenze locali per livello, interessi fotografici, obiettivi di apprendimento e lingua; il profilo permette di modificarle in seguito. La lingua può seguire il dispositivo oppure essere impostata manualmente fra le lingue di lancio, indicate con nomi localizzati. Drift passa allo schema v2 con una migrazione esplicita che conserva le precedenti preferenze di lingua. Non implementa ancora catalogo, proposte personalizzate, archivio, account o sincronizzazione.

## Step 5A — Fondamenta dati, ricerca SQL e repository paginato

**Step 5A.** Implementato il fondamento dati: ricerca FTS5 locale, repository set-based paginato e contratto per dettaglio.

**Step 5B.** Completata la localizzazione editoriale del seed: tutti i 10 contenuti hanno traduzioni complete nelle sette lingue di lancio (inglese, italiano, spagnolo, francese, tedesco, portoghese europeo e portoghese brasiliano).

**Step 5C.** Completata l’interfaccia catalogo Esplora con ricerca locale debounce, filtri combinabili, stati accessibili e paginazione controllata dal repository SQLite.

**Step 5D.** Completata la route GoRouter deep-linkable `/explore/content/:contentId` e la schermata dettaglio offline con caricamento tramite repository pubblicabile, fallback locale coerente, metadati, fonti, licenze, stati localizzati e layout accessibile/responsive. Step 5 è completato; archivio, salvataggi, home a regole, cloud e monetizzazione restano negli step successivi.

## Step 6 — Home e idee a regole

**Step 6.** Completata la Home offline con suggerimenti spiegabili, calcolati da regole deterministiche locali su profilo, livello, attrezzatura, tag e lingua. Non usa AI generativa, rete, analytics o monetizzazione; lo schema Drift resta alla versione 3.

## Step 8A — Hardening del percorso MVP critico

**Step 8A.** Verificato il percorso locale dal profilo al catalogo localizzato e all'Archivio con un test d'integrazione su database Drift persistente, inclusi modifica atomica, ricerca e filtri, ricostruzione dei repository e cambio lingua senza perdita dei dati personali. Rafforzate la semantica delle card, la robustezza del layout compatto con testo scalato e la protezione da mutazioni concorrenti delle raccolte. Lo schema Drift era alla versione 4. Le verifiche manuali su dispositivi rappresentativi e gli altri interventi di hardening restano nello Step 8.

## Step 8B — Percorso UI critico su host

**Step 8B.** Il percorso UI critico attraversa onboarding/profilo, catalogo, dettaglio e Archivio su SQLite persistente, ricostruisce completamente l'app, riapre il database e cambia lingua senza perdere i dati personali. Il test host `test/step_8b_app_ui_host_test.dart` è stato riconfermato il 30 luglio 2026. L'entry point equivalente in `integration_test/` resta il gate automatico da eseguire su Android.

## Step 8C — Validazione Android e matrice manuale

**Step 8C.** L'installazione e l'avvio dell'APK su Android sono stati confermati dall'utente il 30 luglio 2026. Questa evidenza sblocca il problema di boot/build osservato sul runner precedente, ma non sostituisce l'esecuzione dell'entry point d'integrazione su Android. Restano inoltre aperti la matrice manuale Android/iOS, accessibilità, temi, testo scalato, locali/fallback, form factor rappresentativi e screenshot. Step 8 non è ancora dichiarato completato.

## Step 8D — Gerarchia visuale editoriale

**Step 8D.** Rafforzata l'identità visiva senza dipendenze o asset esterni: copertine editoriali deterministiche differenziate per argomento, hero Home con titolo, sintesi e motivo della raccomandazione, card Esplora più leggibili, testata visuale nel dettaglio e temi Material 3 personalizzati per campi, chip, pulsanti, pannelli e navigazione. Le copertine sono decorative, non contengono testo e si adattano a tema chiaro/scuro. Nei viewport bassi il dettaglio riduce la testata per mantenere l'azione Salva sopra la piega. Le future fotografie revisionate potranno sostituire queste copertine tramite il contratto asset senza modificare la gerarchia.

## Step 9A — Contratto, validazione e importazione editoriale offline

**Step 9A.** Implementati contratto JSON v1 revisionabile, validatore/report CLI deterministico e importer Drift atomico/idempotente con controllo di downgrade. Fonti, diritti, traduzioni e asset sono validati offline; le sole strutture catalogo v4 compatibili vengono importate, conservando integralmente profilo e Archivio. Il seed esistente resta compatibile; lo schema era alla versione 4. Cheat Sheet, Percorsi, CMS, rete e persistenza degli asset restano fuori scope. Lo Step 8 rimane in corso per le validazioni Android e manuali residue.

## Step 9B — Catalogo multilingua e gate di pubblicazione

**Step 9B.** Consegnato un catalogo offline di 30 contenuti pubblicabili, bilanciato fra consigli, curiosità e idee, con sette locali completi (`en`, `it`, `es`, `fr`, `de`, `pt`, `pt-BR`), ricerca localizzata, asset locali e bootstrap SQLite atomico e idempotente. Il validatore di qualità e i nove test dedicati sono stati riconfermati il 30 luglio 2026; il record `needsReview` resta escluso da catalogo, ricerca e Home. La chiusura formale dello Step 9 richiede ancora l'approvazione umana documentata di titolarità/licenze, traduzioni e terminologia fotografica.

## Step 9C — Espansione della biblioteca fotografica

**Step 9C — pianificato.** Portare il catalogo da 30 ad almeno 90 contenuti pubblicabili senza ricorrere a varianti generiche. L'espansione deve riequilibrare paesaggio, macro, ritratto, notturna, urban e focus, introdurre tecniche, errori comuni, guide, checklist, sfide, glossario e storia fotografica e includere un livello avanzato reale. Ogni contenuto segue lo stesso gate multilingua e legale dello Step 9B; i record non revisionati restano `needsReview` e invisibili nell'app.

## Step 9D — Workspace editoriale incrementale

**Step 9D.** Implementato un archivio SQLite locale e separato dall'app per fonti, documenti, testo estratto, frammenti deduplicati e ricercabili full-text, bozze e revisioni. La CLI importa output manuali, `pdftotext` o OCR, mantiene versioni stabili, riapre tutti i gate dopo ogni aggiornamento e produce snapshot JSON compatibili con lo Step 9A. L'export include solo schede approvate per accuratezza, originalità, diritti, terminologia e lingua, collegate a fonti verificate e pubblicabili; testo estratto, evidenze private e file originali non escono dal workspace. OCR, scraping, cloud, CMS e generazione automatica restano fuori scope. Lo Step 9 resta aperto per l'espansione 9C e per i sign-off umani residui.

## Step 9E — Bootstrap incrementale e coerenza delle traduzioni

**Step 9E.** Il database Drift passa alla versione 5 con un registro locale del catalogo bundle installato. A parità di ID e versione del pacchetto l'avvio successivo evita di leggere, validare e reimportare JSON e asset; una modifica del pacchetto richiede quindi l'aumento di `packageVersion`. L'importer invalida atomically tutte le traduzioni precedenti quando sale la versione di un contenuto e il repository pubblica soltanto traduzioni con `sourceVersion` coerente, applicando il fallback alla lingua valida successiva. Il registro non contiene dati utente e profilo, Archivio e salvataggi restano invariati.
