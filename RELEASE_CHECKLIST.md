# Checklist di rilascio

## Prodotto e qualità

- [ ] Flussi MVP verificati offline e dopo riavvio.
- [ ] Nessun contenuto non approvato è esposto.
- [ ] Accessibilità, testo scalato, temi e localizzazione verificati per `en`, `it`, `es`, `fr`, `de` e `pt-BR`; inglese verificato come fallback globale.
- [ ] Lingua del dispositivo, selezione manuale e ripristino automatico verificati; nessuna bandiera rappresenta una lingua.
- [ ] Layout LTR/RTL, stringhe tedesche lunghe, caratteri accentati/non latini, plurali, parametri e formati regionali verificati senza clipping o larghezze fisse.
- [ ] Pacchetto della lingua selezionata, ricerca localizzata e fallback offline verificati; cambio lingua senza perdita di preferiti o progressi.
- [ ] Crash, analytics e messaggi di errore rispettano la privacy.

## Sicurezza e legale

- [ ] Privacy policy, termini e contatti di supporto pubblicati.
- [ ] Licenze e attribuzioni editoriali verificate.
- [ ] Ogni traduzione pubblicata conserva lingua originale, versione fonte, metodo/data di traduzione, revisione e terminologia fotografica approvata; le traduzioni obsolete o non approvate non sono esposte.
- [ ] Nessun segreto nel repository o nel bundle.
- [ ] Retention, export e cancellazione dati documentati.

## Store e monetizzazione

- [ ] Icone, screenshot, descrizioni e rating store pronti.
- [ ] Acquisti, restore e entitlement testati in sandbox.
- [ ] Paywall, benefici Premium, prova, rinnovo, restore, termini e privacy sono localizzati; prezzi e valute provengono dallo store senza formattazione o conversione manuale.
- [ ] Formati e consenso annunci configurati prima dell'attivazione.
- [ ] Piano rollback e canale supporto definiti.
