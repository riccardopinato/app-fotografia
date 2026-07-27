# Strategia di test

## Piramide

- **Unit:** entità, use case, ranking delle `IdeaRule`, mapper, validazione, migrazioni e policy di fallback delle traduzioni.
- **Widget:** componenti design system, filtri, stati vuoti/errori, ARB/plurali-parametri e accessibilità base.
- **Integration:** onboarding → home → salvataggio → archivio con database locale, cambio lingua senza perdita di preferiti/progressi e pacchetto linguistico offline. Lo Step 8A verifica direttamente repository e controller su un file SQLite temporaneo. Lo Step 8B pilota invece `FrameLabApp`, router, scope e pagine reali; la stessa definizione del percorso è verificata dal test widget host e preparata nell'entry point in `integration_test/`, che resta il gate nativo Android e richiede un dispositivo o simulatore supportato.
- **Manuale:** tema chiaro/scuro, testo scalato, assenza di rete, lettore schermo e dispositivi Android/iOS rappresentativi, inclusi schermi piccoli, grandi, tablet e Android di fascia media; verifiche LTR/RTL, tedesco lungo, caratteri accentati e alfabeti non latini.

## Gate per ogni step

1. formatter e analisi statica;
2. test impattati;
3. test completi quando la base Flutter esisterà;
4. controllo manuale della UI per modifiche percepibili.

I seed editoriali devono essere verificati per campi obbligatori, tipo valido, fonte/licenza e stato `pubblicato` prima di essere visibili all'utente.

Le verifiche di localizzazione coprono le sei lingue di lancio (`en`, `it`, `es`, `fr`, `de`, `pt-BR`), con inglese come fallback. Testare l'ordine `locale completo → lingua base compatibile → inglese → indisponibile`, assenza di pagine con frammenti di lingue diverse, pluralizzazione, parametri, formati regionali e semantica accessibile localizzata. I dati test devono verificare che una modifica al contenuto canonico renda obsolete le traduzioni collegate e che solo le traduzioni `published` siano esposte; le traduzioni generate richiedono revisione.

Le schermate con immagini devono essere controllate per ratio stabile, assenza di layout shift, miniature dimensionate correttamente, errore rete e memoria durante scorrimento prolungato. Le animazioni devono essere testate con riduzione del movimento attiva e non devono impedire l'interazione.
