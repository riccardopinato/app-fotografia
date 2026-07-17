# Schema dati

## Tabelle locali MVP

| Tabella | Chiave | Campi essenziali |
| --- | --- | --- |
| content_items | id | type, titolo, testo, topic, tag, difficoltà, premium, source_id, review_status, date |
| content_sources | id | titolo, autore, licenza, provenienza, riferimento, importata_il |
| user_profile | singleton | livello, preferenze, attrezzatura, obiettivi, aggiornata_il |
| saved_items | id | content_id, raccolta, nota, stato, salvata_il, aggiornata_il |
| collections | id | nome, creata_il |
| idea_rules | id | vincoli normalizzati, proposta, impostazioni, priorità |

Usare UUID generati dal client, timestamp UTC e vincoli di chiave esterna. Serializzare liste/tag in tabelle relazionali o converter Drift tipizzati, non in stringhe delimitate ad hoc.

## Evoluzione

Le migrazioni Drift devono essere versionate e testate. La futura sync aggiungerà identificatori remoti, `syncStatus`, `lastSyncedAt` e tombstone per cancellazioni, senza sostituire indiscriminatamente modifiche locali.
