# Strategia di test

## Piramide

- **Unit:** entità, use case, ranking delle `IdeaRule`, mapper, validazione, migrazioni e policy di fallback delle traduzioni.
- **Widget:** componenti design system, filtri, stati vuoti/errori, ARB/plurali-parametri e accessibilità base.

- **Manuale:** tema chiaro/scuro, testo scalato, assenza di rete, lettore schermo e dispositivi Android/iOS rappresentativi, inclusi schermi piccoli, grandi, tablet e Android di fascia media; verifiche LTR/RTL, tedesco lungo, caratteri accentati e alfabeti non latini.

## Gate per ogni step

1. formatter e analisi statica;
2. test impattati;
3. test completi quando la base Flutter esisterà;
4. controllo manuale della UI per modifiche percepibili.

I seed editoriali devono essere verificati per campi obbligatori, tipo valido, fonte/licenza e stato `pubblicato` prima di essere visibili all'utente.

Lo Step 9A aggiunge test del contratto e del report, incluso exit code CLI, più test con SQLite reale per idempotenza, upgrade/downgrade, rollback transazionale, fallback, publication gate e conservazione di salvataggio, nota, stato e raccolta. Il pacchetto valido e quello intenzionalmente invalido devono essere entrambi eseguiti nei gate.

Lo Step 9D verifica su SQLite reale importazione idempotente, frammentazione, versionamento delle bozze, ricreazione della coda di revisione, blocco dei downgrade, gate dei diritti, approvazioni per lingua e validità del pacchetto esportato. I file originali, il testo estratto e le evidenze private non devono comparire nell'export.

Lo Step 9E verifica la migrazione allo schema v5, il fast-path del catalogo bundle senza nuove letture di JSON o asset, l'invalidazione atomica delle traduzioni non aggiornate e il fallback alla traduzione con versione coerente. Gli aggiornamenti non devono modificare profilo, Archivio, note, raccolte o stati personali.


Le verifiche di localizzazione coprono le sei lingue di lancio (`en`, `it`, `es`, `fr`, `de`, `pt-BR`), con inglese come fallback. Testare l'ordine `locale completo → lingua base compatibile → inglese → indisponibile`, assenza di pagine con frammenti di lingue diverse, pluralizzazione, parametri, formati regionali e semantica accessibile localizzata. I dati test devono verificare che una modifica al contenuto canonico renda obsolete le traduzioni collegate e che solo le traduzioni `published` siano esposte; le traduzioni generate richiedono revisione.

Le schermate con immagini devono essere controllate per ratio stabile, assenza di layout shift, miniature dimensionate correttamente, errore rete e memoria durante scorrimento prolungato. Le animazioni devono essere testate con riduzione del movimento attiva e non devono impedire l'interazione.
