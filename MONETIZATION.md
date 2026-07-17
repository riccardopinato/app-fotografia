# Monetizzazione

| Piano | Accesso |
| --- | --- |
| Free | catalogo base, archivio illimitato, strumenti base, annunci non invasivi |
| Remove Ads | acquisto una tantum che elimina solo gli annunci |
| Pro | nessun annuncio, strumenti completi, contenuti e percorsi Premium, offline esteso; in futuro quota analisi |

## Paywall e regole

- Remove Ads e Pro sono entitlement distinti.
- Nessun annuncio interstitial durante la lettura; eventuali rewarded ad devono essere opzionali.
- Paywall, prodotti e prezzi sono configurabili da remoto solo dopo validazione legale e store.
- RevenueCat diventerà la fonte di verità degli entitlement; l'app deve gestire restore acquisti e stato offline con scadenza prudente.
- Il paywall deve dichiarare vantaggi, prezzo reale, periodicità, prova eventuale, rinnovo automatico, annullamento, ripristino acquisti, termini e privacy. Nessun countdown falso, urgenza artificiale, preselezione ingannevole o chiusura nascosta.
- Prima dell'implementazione documentare la scelta tra RevenueCat Paywalls remoti e paywall Flutter personalizzato; la scelta deve preservare accessibilità, trasparenza e coerenza visiva.
- Il confronto con la versione senza annunci può essere informativo, ma non deve peggiorare artificialmente l'esperienza Free. Gli annunci non devono essere aggressivi o interrompere la lettura.
- Non implementare SDK, ID unità pubblicitarie o chiavi prima dello step dedicato.
