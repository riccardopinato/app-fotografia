# Strategia di test

## Piramide

- **Unit:** entità, use case, ranking delle `IdeaRule`, mapper e validazione.
- **Widget:** componenti design system, filtri, stati vuoti/errori e accessibilità base.
- **Integration:** onboarding → home → salvataggio → archivio con database locale.
- **Manuale:** tema chiaro/scuro, testo scalato, assenza di rete, lettore schermo e dispositivi Android/iOS rappresentativi, inclusi schermi piccoli, grandi, tablet e Android di fascia media.

## Gate per ogni step

1. formatter e analisi statica;
2. test impattati;
3. test completi quando la base Flutter esisterà;
4. controllo manuale della UI per modifiche percepibili.

I seed editoriali devono essere verificati per campi obbligatori, tipo valido, fonte/licenza e stato `pubblicato` prima di essere visibili all'utente.

Le schermate con immagini devono essere controllate per ratio stabile, assenza di layout shift, miniature dimensionate correttamente, errore rete e memoria durante scorrimento prolungato. Le animazioni devono essere testate con riduzione del movimento attiva e non devono impedire l'interazione.
