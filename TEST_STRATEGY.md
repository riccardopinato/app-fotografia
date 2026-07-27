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

Lo Step 9B applica inoltre gate deterministici al catalogo distribuito: almeno 30 pubblicati, sette locali completi, corpi tra 180 e 1400 caratteri, 2–4 tag per contenuto, almeno 8 elementi per ciascun tipo principale e per i livelli principiante/intermedio, ID e tag normalizzati, nessun placeholder, titolo/corpo duplicato o tag orfano. Test con SQLite su file verificano bootstrap, seconda apertura, conservazione personale, FTS multilingua, filtri, paginazione, fallback e bozza esclusa.

Le verifiche di localizzazione coprono le sei lingue di lancio (`en`, `it`, `es`, `fr`, `de`, `pt-BR`), con inglese come fallback. Testare l'ordine `locale completo → lingua base compatibile → inglese → indisponibile`, assenza di pagine con frammenti di lingue diverse, pluralizzazione, parametri, formati regionali e semantica accessibile localizzata. I dati test devono verificare che una modifica al contenuto canonico renda obsolete le traduzioni collegate e che solo le traduzioni `published` siano esposte; le traduzioni generate richiedono revisione.

Le schermate con immagini devono essere controllate per ratio stabile, assenza di layout shift, miniature dimensionate correttamente, errore rete e memoria durante scorrimento prolungato. Le animazioni devono essere testate con riduzione del movimento attiva e non devono impedire l'interazione.
