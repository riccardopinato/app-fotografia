# Step 9C — Piano di espansione a 90+ schede

Il catalogo attuale contiene 30 schede pubblicabili. Questo piano definisce il
lotto successivo: 60 nuove schede, per un totale minimo di 90. Una scheda entra
nel pacchetto pubblico solo quando ha contenuto originale revisionato, sette
traduzioni complete, fonte/licenza verificata, asset coerente e superamento dei
gate `quality`.

## Matrice editoriale

| Area | Nuove schede | Obiettivo |
|---|---:|---|
| Esposizione e misurazione | 8 | istogramma, compensazione, alte luci, zone, bracketing |
| Luce naturale e artificiale | 8 | finestra, controluce, flash, riflettori, colore della luce |
| Composizione | 8 | spazio negativo, simmetria, livelli, ritmo, punto di vista |
| Paesaggio e ambiente | 7 | scala, tempo atmosferico, acqua, panorama, foreground |
| Ritratto e persone | 7 | posa, espressione, sfondo, luce laterale, movimento |
| Macro e dettaglio | 6 | profondità ridotta, stacking, texture, stabilità |
| Notturna e lunga esposizione | 6 | stelle, scie, treppiede, rumore, fuoco manuale |
| Urban e architettura | 5 | linee, prospettiva, geometria, vetro, attese |
| Workflow e tecnica | 5 | backup, selezione, metadati, colore, stampa |
| **Totale** | **60** | **30 esistenti + 60 nuove = 90** |

## Regole di inserimento

1. Ogni record usa un ID stabile, una versione e un tipo già supportato.
2. Ogni record pubblicabile contiene traduzioni `en`, `it`, `es`, `fr`, `de`,
   `pt` e `pt-BR`, con `sourceVersion` coerente.
3. Le nuove schede devono ampliare concetti e difficoltà, non duplicare titoli,
   sommari, corpi o combinazioni di tag già presenti.
4. Le fonti e le licenze vengono registrate prima della pubblicazione; le
   evidenze private restano nel workspace editoriale e non vengono esportate.
5. Il pacchetto passa `validate` e `quality` prima dell'importazione SQLite.
6. L'inserimento avviene per lotti verificabili, aggiornando `packageVersion`.

## Sequenza dei lotti

- Lotto A: esposizione, luce e composizione — 24 schede.
- Lotto B: paesaggio, ritratto, macro — 20 schede.
- Lotto C: notturna, urban e workflow — 16 schede.

Il primo lotto viene considerato completo solo con sette traduzioni e sign-off
editoriale; fino ad allora le bozze restano nel workspace privato e non nel
catalogo pubblico.
