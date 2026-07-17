# Modello dei contenuti

## ContentItem

| Campo | Descrizione |
| --- | --- |
| id | identificatore stabile UUID |
| type | consiglio, tecnica, curiosità, idea, errore, guida, checklist, sfida, glossario, storia |
| title, summary, body | testo editoriale strutturato |
| topics, tags | classificazione per ricerca e filtro |
| difficulty | principiante, intermedio, avanzato |
| estimatedMinutes | tempo di lettura/azione stimato |
| requiredGear | attrezzatura opzionale richiesta o consigliata |
| premium | disponibilità commerciale futura |
| sourceId | collegamento a fonte e licenza |
| reviewStatus | stato editoriale |
| createdAt, updatedAt | audit editoriale |

I topic iniziali includono ritratto, paesaggio, street, macro, wildlife, sport, eventi, notturna, astrofotografia, smartphone, composizione, illuminazione, editing e attrezzatura.

## Dati utente

`UserProfile` raccoglie livello, generi preferiti, corpi macchina, obiettivi, smartphone, interessi e obiettivi di apprendimento. `SavedItem` lega utente e contenuto, con raccolta opzionale, nota, stato e data di salvataggio. Le foto associate sono fuori MVP e richiedono policy di retention.

## Idee a regole

Una `IdeaRule` definisce vincoli opzionali (luogo, ora, meteo, attrezzatura, genere, durata, difficoltà), testo della proposta e impostazioni consigliate. Il motore assegna un punteggio alle regole compatibili e spiega i criteri usati; non presenta risultati AI come fatti oggettivi.
