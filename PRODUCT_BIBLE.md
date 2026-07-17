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

Contenuti editoriali revisionati, organizzati per tipo e genere fotografico, personalizzati in base a livello e attrezzatura, disponibili anche offline. La qualità editoriale viene prima della generazione automatica.

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
