# Pipeline editoriale offline — Step 9A–9D

## Confine e struttura



Il contratto JSON `1.0` separa:

- metadati del pacchetto (`formatVersion`, ID/versione stabili, timestamp UTC, lingua base e lingue incluse);
- `contents`, identità logiche indipendenti dal titolo, tipo/stato/versione, classificazione e riferimenti;
- traduzioni complete annidate nel contenuto, con locale, stato, metodo, versione sorgente, revisione e termini di ricerca;
- `sources`, provenienza, verifica, licenza, attribuzione e diritti;
- `tags`, con ID/codice stabili ed etichette localizzate;
- `assets`, con percorso locale, MIME, dimensioni, byte, checksum FNV-1a 64, alt text/didascalia, credito, fonte, licenza, ruolo, focal point e stato.

Il versionamento ha due livelli: `formatVersion` cambia quando cambia il contratto; `packageVersion` identifica la consegna. Ogni contenuto ha una propria versione intera crescente e ogni traduzione deve dichiarare lo stesso `sourceVersion` del contenuto. Un import con la stessa versione è un no-op; una versione maggiore aggiorna la stessa identità, rende obsolete le traduzioni non incluse e un downgrade è bloccante. Tipi futuri (Cheat Sheet e Percorsi) richiederanno una nuova versione del contratto e mapping esplicito: non sono accettati oggi e non sono state create tabelle speculative.

## Comandi

```sh
dart run bin/framelab_editorial.dart validate editorial/example/package.json
dart run bin/framelab_editorial.dart validate editorial/invalid/package.json
dart run bin/framelab_editorial.dart import editorial/example/package.json /tmp/framelab.sqlite
dart run bin/framelab_editorial.dart quality editorial/catalog/package.json

```

Lo Step 9D aggiunge un workspace privato e incrementale:

```sh
dart run bin/framelab_workspace.dart init editorial/workspace/private/library.sqlite
dart run bin/framelab_workspace.dart ingest editorial/workspace/private/library.sqlite editorial/workspace/example_ingest.json
dart run bin/framelab_workspace.dart search editorial/workspace/private/library.sqlite "exposure compensation"
dart run bin/framelab_workspace.dart draft editorial/workspace/private/library.sqlite editorial/workspace/example_draft.json
dart run bin/framelab_workspace.dart queue editorial/workspace/private/library.sqlite
dart run bin/framelab_workspace.dart review editorial/workspace/private/library.sqlite editorial/workspace/example_review.json
dart run bin/framelab_workspace.dart export editorial/workspace/private/library.sqlite it editorial/workspace/exports/package-it.json
```

La guida completa, gli esempi e il confine legale sono in
`editorial/workspace/README.md`.

Il report, ordinato deterministicamente, mostra pacchetto, conteggi, severità (`ERROR`, `WARNING`, `INFO`), percorso JSON, spiegazione e correzione. Gli errori restituiscono exit code `1`; uso errato `64`. L'import parte solo dopo una validazione completa.

Il comando `quality` aggiunge i gate di rilascio del catalogo bundle: quantità e distribuzione minime, copertura dei locali, ID e tag stabili, testi completi e non duplicati e assenza di placeholder. È un controllo automatico di coerenza, non sostituisce il sign-off umano su titolarità, accuratezza, traduzioni e terminologia. Le evidenze e i sign-off residui sono registrati in `docs/roadmap/step-08c-09-signoff.md`.

## Regole editoriali

1. Creare un ID stabile, non derivato dal titolo, e aumentare la versione per ogni modifica pubblicabile.
2. Usare un tipo/stato già supportato e dichiarare tag e fonti prima di referenziarli.
3. Fornire una traduzione canonica completa. Le lingue supportate sono `en`, `it`, `es`, `fr`, `de`, `pt`, `pt-BR`; le traduzioni incomplete sono rifiutate. Il catalogo conserva il fallback esistente: locale completo, lingua base compatibile, inglese, indisponibile, senza mescolare campi.
4. Pubblicare solo traduzioni `published` di contenuti `published`. Record completi ma `needsReview`, come nell'esempio, restano fuori dalle query pubbliche.
5. Per ogni fonte registrare provenienza e verifica. Le licenze ammesse in v1 sono `CC0-1.0`, `CC-BY-4.0`, `CC-BY-SA-4.0`, `FrameLab-Proprietary`, `Public-Domain` e `Licensed-Agreement`; quest'ultima richiede evidenza documentata nel workspace privato. Un URL pubblico non dimostra i diritti; attribuzione obbligatoria, licenza non riconosciuta o fonte irrisolta bloccano il pacchetto.
6. Inserire asset solo nel pacchetto, mai con path assoluti o `..`. Aggiornare byte size e checksum dopo ogni modifica. Non vengono scaricati file; gli asset sono validati ma, non esistendo una tabella compatibile, non sono ancora importati o mostrati dall'app.

## Importazione e dati personali

L'importer usa una singola transazione Drift e upsert per ID stabile sulle sole tabelle editoriali esistenti. Non elimina contenuti assenti dal pacchetto. Aggiorna relazioni, tag e traduzioni del contenuto soltanto per una versione maggiore; una seconda importazione non duplica righe. Un errore di validazione o SQLite produce zero scritture/rollback completo.

Le tabelle `user_profiles`, `collections` e `saved_items` non sono scritte. Poiché `saved_items.content_id` continua a riferire lo stesso ID logico, salvataggio, raccolta, nota e stato sopravvivono agli aggiornamenti. Lo schema v5 aggiunge soltanto il registro tecnico del catalogo bundle: a parità di `packageId` e `packageVersion`, se il catalogo installato è integro, l'avvio evita lettura, validazione e import del pacchetto. Metadati sorgente non rappresentabili integralmente e asset restano nel contratto sorgente revisionabile; una loro futura persistenza richiederà valutazione e autorizzazione di migrazione.

## Limiti correnti


- Non sono elaborati raster, scaricati asset, creati pacchetti remoti o aggiunti nuovi tipi.
- Il checksum v1 è `fnv1a64`; un algoritmo differente richiede evoluzione esplicita del contratto.
- La prova legale resta responsabilità editoriale: il validatore verifica coerenza e presenza, non certifica la titolarità.
- PDF, fotografie e testo OCR delle riviste restano nel workspace privato e non sono esportati nell'app. Step 9D accetta testo già estratto, ma non integra OCR, scraping o download.
