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

## Step 7A — Fondamenta tecniche Archivio personale

**Step 7A.** Implementati dominio Library, schema Drift v4 e migrazione non distruttiva v3 → v4, repository locale e wiring nel bootstrap per salvataggi, raccolte, note e stati. Le interfacce per salvare dal catalogo e consultare/modificare l'archivio sono esplicitamente rimandate agli Step 7B e 7C.

## Step 7B — Salvataggio dal dettaglio e Archivio in sola lettura

**Step 7B.** Implementati il toggle localizzato e accessibile `Salva`/`Salvato` nel dettaglio catalogo e la pagina Archivio in sola lettura, alimentata dai salvataggi locali e dai contenuti catalogo nella lingua attiva. Le mutazioni non sono ottimistiche e restano recuperabili in caso di errore. Note, raccolte, filtri, ricerca, modifica dello stato e rimozione dalla lista sono rimandati allo Step 7C.

## Step 7C — Gestione completa dell’Archivio personale

**Step 7C.** Completato l’Archivio locale con ricerca su contenuti e note, filtri combinabili per stato e raccolta, modifica di nota/stato/raccolta, rimozione con conferma e creazione, rinomina ed eliminazione delle raccolte. Le mutazioni attendono l’esito del repository e mostrano errori recuperabili; l’eliminazione di una raccolta conserva i salvataggi senza raccolta. Interfaccia e semantica sono localizzate nelle lingue di lancio. Lo schema Drift resta alla versione 4; hardening generale e test d’integrazione end-to-end restano allo Step 8.
| 8 | Hardening MVP | test integrazione, accessibilità e screenshot | da fare |
| 9 | Pipeline editoriale | importazione/revisione separata e tracciabile | da fare |
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
