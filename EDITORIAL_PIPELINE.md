# Pipeline editoriale offline — Step 9A

## Confine e struttura



Il contratto JSON `1.0` separa:

- metadati del pacchetto (`formatVersion`, ID/versione stabili, timestamp UTC, lingua base e lingue incluse);
- `contents`, identità logiche indipendenti dal titolo, tipo/stato/versione, classificazione e riferimenti;
- traduzioni complete annidate nel contenuto, con locale, stato, metodo, versione sorgente, revisione e termini di ricerca;
- `sources`, provenienza, verifica, licenza, attribuzione e diritti;
- `tags`, con ID/codice stabili ed etichette localizzate;
- `assets`, con percorso locale, MIME, dimensioni, byte, checksum FNV-1a 64, alt text/didascalia, credito, fonte, licenza, ruolo, focal point e stato.

Il versionamento ha due livelli: `formatVersion` cambia quando cambia il contratto; `packageVersion` identifica la consegna. Ogni contenuto ha una propria versione intera crescente. Un import con la stessa versione è un no-op; una versione maggiore aggiorna la stessa identità; un downgrade è bloccante. Tipi futuri (Cheat Sheet e Percorsi) richiederanno una nuova versione del contratto e mapping esplicito: non sono accettati oggi e non sono state create tabelle speculative.

## Comandi

```sh
dart run bin/framelab_editorial.dart validate editorial/example/package.json
dart run bin/framelab_editorial.dart validate editorial/invalid/package.json
dart run bin/framelab_editorial.dart import editorial/example/package.json /tmp/framelab.sqlite

```

Il report, ordinato deterministicamente, mostra pacchetto, conteggi, severità (`ERROR`, `WARNING`, `INFO`), percorso JSON, spiegazione e correzione. Gli errori restituiscono exit code `1`; uso errato `64`. L'import parte solo dopo una validazione completa.

## Regole editoriali

1. Creare un ID stabile, non derivato dal titolo, e aumentare la versione per ogni modifica pubblicabile.
2. Usare un tipo/stato già supportato e dichiarare tag e fonti prima di referenziarli.
3. Fornire una traduzione canonica completa. Le lingue supportate sono `en`, `it`, `es`, `fr`, `de`, `pt`, `pt-BR`; le traduzioni incomplete sono rifiutate. Il catalogo conserva il fallback esistente: locale completo, lingua base compatibile, inglese, indisponibile, senza mescolare campi.
4. Pubblicare solo traduzioni `published` di contenuti `published`. Record completi ma `needsReview`, come nell'esempio, restano fuori dalle query pubbliche.
5. Per ogni fonte registrare provenienza e verifica. Le licenze ammesse in v1 sono `CC0-1.0`, `CC-BY-4.0`, `CC-BY-SA-4.0` e `FrameLab-Proprietary`. Un URL pubblico non dimostra i diritti; attribuzione obbligatoria, licenza non riconosciuta o fonte irrisolta bloccano il pacchetto.
6. Inserire asset solo nel pacchetto, mai con path assoluti o `..`. Aggiornare byte size e checksum dopo ogni modifica. Non vengono scaricati file; gli asset sono validati ma, non esistendo una tabella compatibile, non sono ancora importati o mostrati dall'app.

## Importazione e dati personali

L'importer usa una singola transazione Drift e upsert per ID stabile sulle sole tabelle editoriali esistenti. Non elimina contenuti assenti dal pacchetto. Aggiorna relazioni, tag e traduzioni del contenuto soltanto per una versione maggiore; una seconda importazione non duplica righe. Un errore di validazione o SQLite produce zero scritture/rollback completo.

Le tabelle `user_profiles`, `collections` e `saved_items` non sono scritte. Poiché `saved_items.content_id` continua a riferire lo stesso ID logico, salvataggio, raccolta, nota e stato sopravvivono agli aggiornamenti. Lo schema resta v4: metadati sorgente non rappresentabili integralmente e asset restano nel contratto sorgente revisionabile; una loro futura persistenza richiederà valutazione e autorizzazione di migrazione.

## Limiti correnti


- Non sono elaborati raster, scaricati asset, creati pacchetti remoti o aggiunti nuovi tipi.
- Il checksum v1 è `fnv1a64`; un algoritmo differente richiede evoluzione esplicita del contratto.
- La prova legale resta responsabilità editoriale: il validatore verifica coerenza e presenza, non certifica la titolarità.
