# Product Bible — FrameLab

## Visione

Aiutare un fotografo a capire **cosa** provare, **come** impostare lo scatto e **come** ricordare ciò che ha imparato, senza trasformare l'app in un feed generico di suggerimenti.

## Utenti e problema

| Persona | Esigenza principale | Risposta del prodotto |
| --- | --- | --- |
| Aspirante | Imparare senza gergo eccessivo | consigli guidati e sfide brevi |
| Intermedio | Trovare esercizi e idee contestuali | catalogo filtrabile e generatore a regole |
| Avanzato | Organizzare riferimenti pratici | archivio, note e attrezzatura nel profilo |

## Proposta di valore

Contenuti editoriali revisionati, organizzati per tipo e genere fotografico, personalizzati in base a livello e attrezzatura, disponibili anche offline e nella lingua scelta dall'utente. La qualità editoriale e della traduzione viene prima della generazione automatica.

## Flussi principali dell'MVP

1. L'utente completa onboarding con livello, generi e attrezzatura.
2. La home mostra un consiglio, una curiosità, un'idea e una mini-sfida pertinenti.
3. L'utente esplora, cerca e filtra il catalogo, poi legge il dettaglio.
4. Può salvare un elemento, aggiungere una nota e impostarne lo stato: da provare, provato o completato.
5. Dal profilo aggiorna le preferenze che influenzano le proposte.

## MVP incluso

- onboarding e profilo locale;
- home personalizzata su contenuti locali;
- catalogo di consigli, tecniche, curiosità, idee, guide, checklist, sfide e glossario;
- ricerca, filtri, dettaglio e salvataggi locali;
- archivio con note e stato;
- design system, accessibilità e persistenza offline;
- interfaccia localizzata con inglese come fallback globale e lancio in inglese, italiano, spagnolo, francese, tedesco e portoghese brasiliano;
- contenuti editoriali localizzabili e scaricabili per lingua, senza scaricare tutte le traduzioni sul dispositivo;
- base dati editoriale seed, soggetta a revisione.

## Fuori dall'MVP

- autenticazione, sync Firestore e caricamento foto;
- dashboard di importazione di PDF/documenti;
- RevenueCat, store billing, AdMob e offerte reali;
- calcolatori completi, meteo, alba/tramonto;
- analisi AI, crediti, community e notifiche push.

## Metriche di prodotto

- completamento onboarding;
- contenuti letti e salvati per utente attivo;
- sfide avviate/completate;
- retention D7 e D30;
- conversione free → Remove Ads/Pro quando il paywall sarà introdotto.

## Vincoli editoriali

Ogni contenuto ha fonte e licenza tracciabili. Testi estratti da opere protette non possono essere pubblicati automaticamente: il flusso editoriale è `importato → elaborato → da revisionare → approvato → pubblicato`.

## Internazionalizzazione

La localizzazione è un requisito di prodotto fin dalla prima implementazione, non un'aggiunta successiva. L'utente può seguire la lingua del dispositivo, scegliere manualmente una lingua o ripristinare la selezione automatica; le lingue sono rappresentate da nomi localizzati, mai da bandiere. Inglese (`en`) è il fallback globale. Le lingue di lancio sono `en`, `it`, `es`, `fr`, `de` e `pt-BR`; giapponese, coreano, cinese semplificato, arabo e hindi sono previste per estensioni successive.

Tutti i testi visibili — inclusi navigazione, onboarding, profilo, archivio, filtri, errori, stati vuoti, offline, notifiche, accessibilità, impostazioni, testi legali e le future superfici di autenticazione, pubblicità e monetizzazione — devono poter essere tradotti. Il contenuto editoriale conserva lingua e versione originali ed è pubblicato in una lingua solo dopo revisione della relativa traduzione; una traduzione automatica non è una verifica editoriale.
