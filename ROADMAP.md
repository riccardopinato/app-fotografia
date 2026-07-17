# Roadmap

Ogni step produce un risultato verificabile e non include lavoro degli step successivi.

| # | Step | Esito verificabile | Stato |
| --- | --- | --- | --- |
| 0 | Fondazione prodotto e design direction | documentazione, decisioni, confini e specifica visiva/motion approvati | completato |
| 1 | Bootstrap Flutter | app compilabile, lint e struttura feature-first | completato |
| 2 | Design system e navigazione | tema, componenti base e shell accessibile | completato |
| 3 | Dominio e database locale | entità, migrazioni e repository contenuti/profilo | da fare |
| 4 | Onboarding e profilo | preferenze locali modificabili | da fare |
| 5 | Catalogo e dettaglio | seed revisionati, ricerca, filtri e lettura offline | da fare |
| 6 | Home e idee a regole | proposte personalizzate spiegabili | da fare |
| 7 | Archivio personale | salvataggi, cartelle, note e stati | da fare |
| 8 | Hardening MVP | test integrazione, accessibilità e screenshot | da fare |
| 9 | Pipeline editoriale | importazione/revisione separata e tracciabile | da fare |
| 10 | Account e sync | auth opzionale, Firestore e conflitti gestiti | da fare |
| 11 | Monetizzazione | entitlement, paywall, acquisti e annunci con consenso | da fare |
| 12 | Strumenti e AI | calcolatori, dati esterni e analisi foto a crediti | da fare |

## Step 1 — Bootstrap Flutter

**Step 1 — Bootstrap Flutter.** Completato con Flutter 3.44.6/Dart 3.12.2: progetto Android/iOS, shell Material 3 con tema chiaro/scuro centralizzato, struttura iniziale `lib/app` e `lib/features/home/presentation`, schermata placeholder non commerciale e widget test. Non sono stati aggiunti Firebase, RevenueCat, AdMob, chiavi o package applicativi. Le schermate definitive, animazioni decorative e dipendenze grafiche restano bloccate fino allo Step 2.

## Step 2 — Design system e navigazione

**Step 2 — Design system e navigazione.** Completato con palette semantiche chiara/scura, tipografia, spaziature, raggi, elevazioni, layout e motion token centralizzati; shell GoRouter responsive con NavigationBar/NavigationRail, cinque route nominate e placeholder accessibili. La localizzazione usa ARB e `gen_l10n`, rileva la lingua del dispositivo e include inglese, italiano, spagnolo, francese, tedesco e portoghese brasiliano. Non sono stati implementati contenuti, persistenza, autenticazione o logica di business.
