# Evidenze e sign-off — Step 8C e Step 9

Data verifica: 30 luglio 2026.

## Evidenze acquisite

| Area | Evidenza | Esito |
| --- | --- | --- |
| Android | Installazione e avvio dell'APK su un target Android, confermati dall'utente | superato, copertura parziale |
| Suite host completa | `flutter test --no-pub` | 91/91 superati |
| Analisi statica | `flutter analyze --no-pub` | nessun problema |
| Percorso UI host | `flutter test --no-pub test/step_8b_app_ui_host_test.dart` | 1/1 superato |
| Catalogo multilingua | `flutter test --no-pub test/step_9b_multilingual_catalog_test.dart` | 9/9 superati |
| Qualità editoriale automatica | `dart run bin/framelab_editorial.dart quality editorial/catalog/package.json` | `VALID`, 0 errori, 0 warning |
| Publication gate | Il record `editorial-draft-reflection-study` in `needsReview` è escluso da catalogo, ricerca e Home | superato |

Il report automatico copre 31 record, 211 traduzioni, una fonte e sei asset. Trenta record risultano pubblicabili e completi nei sette locali del catalogo (`en`, `it`, `es`, `fr`, `de`, `pt`, `pt-BR`).

## Gate ancora aperti

- eseguire `integration_test/step_8b_app_ui_journey_test.dart` su un dispositivo Android con boot completo;
- completare la matrice manuale Android/iOS, inclusi offline/riavvio, temi, testo fino a 2×, form factor, locali/fallback, TalkBack/VoiceOver e screenshot;
- far attestare da un responsabile editoriale la titolarità dei testi e dei sei asset dichiarati `FrameLab-Proprietary`, conservando la relativa prova;
- far approvare da revisori linguistici identificabili le traduzioni pubblicate e la terminologia fotografica per ogni locale.

## Sign-off richiesti

| Gate | Responsabile | Evidenza da allegare | Stato |
| --- | --- | --- | --- |
| Diritti e attribuzioni | responsabile legale/editoriale | registro di titolarità o autorizzazione per fonte e asset | aperto |
| Inglese canonico | editor fotografia | revisione contenuti e accuratezza tecnica | aperto |
| `it`, `es`, `fr`, `de`, `pt`, `pt-BR` | revisore madrelingua per locale | nome/reviewer ID, data, versione fonte e glossario approvato | aperto |
| Android integration test | QA | log del test su device ID e versione Android | aperto |
| Matrice manuale mobile | QA | matrice compilata e screenshot | aperto |

Lo Step 9 può essere dichiarato completato solo dopo i primi tre sign-off. Lo Step 8 richiede gli ultimi due. Fino ad allora lo Step 10 resta in progettazione e non in implementazione.
