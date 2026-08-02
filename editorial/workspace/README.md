# Workspace editoriale privato — Step 9D

Questo workspace serve a costruire e aggiornare nel tempo una biblioteca
fotografica ampia senza inserire riviste, PDF o testi estratti nell'APK.
È un archivio SQLite separato dal database dell'app e non contiene dati utente.

## Flusso

1. Conservare il file originale in `editorial/workspace/private/`, escluso da
   Git.
2. Estrarre il testo con uno strumento esterno (`pdftotext`, OCR o trascrizione
   manuale). Step 9D non incorpora un motore OCR.
3. Compilare un manifest come `example_ingest.json`, indicando fonte, metodo di
   estrazione, licenza, stato dei diritti ed evidenza disponibile.
4. Importare il manifest. Il testo viene diviso in frammenti con ID stabili,
   checksum, rilevamento dei duplicati e indice di ricerca full-text.
5. Scrivere una scheda originale come `example_draft.json`, collegandola alle
   fonti e ai frammenti usati.
6. Approvare accuratezza tecnica, originalità, diritti, terminologia e ogni
   lingua con un revisore nominativo.
7. Esportare il pacchetto per la lingua desiderata. Solo le schede interamente
   approvate, con fonti verificabili e pubblicabili, entrano nell'export.
8. Validare e importare il pacchetto con la pipeline Step 9A.

## Comandi

```sh
dart run bin/framelab_workspace.dart init editorial/workspace/private/library.sqlite
dart run bin/framelab_workspace.dart ingest editorial/workspace/private/library.sqlite editorial/workspace/example_ingest.json
dart run bin/framelab_workspace.dart search editorial/workspace/private/library.sqlite "exposure compensation"
dart run bin/framelab_workspace.dart draft editorial/workspace/private/library.sqlite editorial/workspace/example_draft.json
dart run bin/framelab_workspace.dart queue editorial/workspace/private/library.sqlite
dart run bin/framelab_workspace.dart review editorial/workspace/private/library.sqlite editorial/workspace/example_review.json
dart run bin/framelab_workspace.dart export editorial/workspace/private/library.sqlite it editorial/workspace/exports/package-it.json
dart run bin/framelab_workspace.dart status editorial/workspace/private/library.sqlite
```

Per vedere decisioni già prese, il comando `queue` accetta anche `approved`,
`rejected` o `changesRequested`.

Una decisione di revisione ha questa forma:

```json
{
  "taskId": "editorial-workspace-metering-check:technicalAccuracy:all:v1",
  "reviewer": "Nome e cognome",
  "decision": "approved",
  "note": "Verifica completata il 30 luglio 2026."
}
```

Le decisioni ammesse sono `approved`, `changesRequested` e `rejected`. Una
nuova versione della scheda elimina le decisioni precedenti e ricrea l'intera
coda; un downgrade è bloccato.

## Aggiornamenti

Ogni nuova fonte usa ID stabili e un nuovo manifest. Ogni modifica editoriale
pubblicabile aumenta `version` nella bozza. L'export è uno snapshot completo
con `packageVersion` crescente; l'importer dell'app applica solo contenuti nuovi
o con versione maggiore, senza toccare profilo e Archivio personale.

Il backup va eseguito a CLI chiusa copiando il file `.sqlite`. I percorsi
`private/`, `exports/` e i file SQLite sono ignorati da Git.

## Confine legale ed editoriale

- Il possesso o l'acquisto di una rivista non concede automaticamente il
  diritto di ripubblicarne testi o fotografie.
- I frammenti e il testo OCR sono materiale di lavoro privato: non vengono mai
  inclusi nell'export.
- La scheda finale deve essere originale, in pubblico dominio o coperta da una
  licenza/accordo che autorizzi l'uso. `Licensed-Agreement` richiede evidenza
  documentata; attribuzione e restrizioni vanno registrate.
- `tdmReserved` documenta l'eventuale riserva sul text and data mining, ma non
  sostituisce una licenza di pubblicazione.
- Il software verifica completezza e coerenza dei metadati; la titolarità e
  l'accuratezza richiedono comunque una decisione umana.

## Limiti dello Step 9D

Non sono inclusi cloud, account, sincronizzazione, scraping, download
automatico, OCR integrato, generazione automatica dei testi o interfaccia CMS.
L'archivio è locale e pensato per un team editoriale ristretto.
