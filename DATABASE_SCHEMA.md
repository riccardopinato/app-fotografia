# Schema dati

## Tabelle locali MVP

| Tabella | Chiave | Campi essenziali |
| --- | --- | --- |
| content_items | id | type, category, difficulty, premium, canonical_locale, publication_status, version, source_id, created_at, updated_at |
| content_translations | id | content_id, locale, title, summary, body, translation_status, translation_method, source_version, translated_at, reviewed_at, reviewer_id, updated_at |
| content_translation_terms | translation_id + term | tag, sinonimi e termini ricercabili per locale |
| content_sources | id | titolo, autore, licenza, provenienza, riferimento, source_version, importata_il |
| user_profile | singleton | livello, preferenze, attrezzatura, obiettivi, language_mode, selected_locale, aggiornata_il |
| saved_items | id | content_id, raccolta, nota, stato, salvata_il, aggiornata_il |
| collections | id | nome, creata_il |
| idea_rules | id | vincoli normalizzati, proposta concettuale, impostazioni, priorità |
| language_packs | locale | versione installata, stato aggiornamento, aggiornata_il |
| photography_glossary_terms | id | chiave concettuale, locale, termine approvato, stato revisione, aggiornata_il |

Usare UUID generati dal client, timestamp UTC e vincoli di chiave esterna. `content_translations` è univoca per `(content_id, locale)` e non sono ammessi campi per lingua come `titleEn` o `bodyIt`. Serializzare liste/tag in tabelle relazionali o converter Drift tipizzati, non in stringhe delimitate ad hoc. Indicizzare locale, stato di pubblicazione e i campi di ricerca localizzati (titolo, corpo, tag e sinonimi); i pacchetti linguistici consentono download, aggiornamento incrementale e invalidazione indipendenti.

## Evoluzione

Le migrazioni Drift devono essere versionate e testate, incluse quelle che marcano `outdated` le traduzioni con `source_version` precedente alla versione canonica. La futura sync aggiungerà identificatori remoti, `syncStatus`, `lastSyncedAt` e tombstone per cancellazioni, senza sostituire indiscriminatamente modifiche locali.

## Implementazione Step 5A

Lo schema Drift `v3` aggiunge l’indice virtuale FTS5 `content_search`, con tokenizer `unicode61 remove_diacritics 2`, per titolo, sommario, corpo, tag localizzati e codici tag. La migrazione esplicita v2 → v3 crea indice e trigger, esegue il backfill e non modifica le tabelle esistenti; le chiavi esterne restano abilitate. I trigger ricostruiscono le righe interessate quando sono inserite o aggiornate traduzioni, relazioni contenuto-tag o traduzioni tag. Il repository usa FTS, filtri e `LIMIT/OFFSET` in SQLite, con una riga completa di traduzione risolta in ordine locale esatto, lingua base, inglese.

## Implementazione Step 4

Lo schema Drift `v2` implementa i contenuti dello Step 3 e il profilo locale dello Step 4. `user_profiles` conserva la modalità lingua (`device` o `manual`), il locale manuale facoltativo e liste tipizzate serializzate tramite converter Drift JSON versionato per interessi, corpi, obiettivi, smartphone e obiettivi di apprendimento. Il converter normalizza, deduplica e ordina i codici validi ed è retrocompatibile con il primo formato array di v2. La migrazione esplicita da v1 aggiunge questi campi e converte il precedente `preferred_locale` in una selezione manuale, senza eliminare dati locali. I timestamp sono interi SQLite in millisecondi epoch UTC; i mapper li convertono con `DateTime.fromMillisecondsSinceEpoch(..., isUtc: true)`. Le chiavi esterne sono abilitate all'apertura e le relazioni di contenuto usano eliminazione a cascata.
