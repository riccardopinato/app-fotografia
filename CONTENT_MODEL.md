# Modello dei contenuti

## ContentItem

| Campo | Descrizione |
| --- | --- |
| id | identificatore stabile UUID |
| type | consiglio, tecnica, curiosità, idea, errore, guida, checklist, sfida, glossario, storia |
| category | categoria concettuale del contenuto |
| canonicalLocale | locale della versione originale/canonica |
| publicationStatus | stato di pubblicazione del contenuto concettuale |
| version | versione del contenuto, usata per invalidare traduzioni obsolete |
| topics, tags | classificazione concettuale per ricerca e filtro |
| difficulty | principiante, intermedio, avanzato |
| estimatedMinutes | tempo di lettura/azione stimato |
| requiredGear | attrezzatura opzionale richiesta o consigliata |
| premium | disponibilità commerciale futura |
| sourceId | collegamento a fonte, autore, licenza e versione della fonte |
| createdAt, updatedAt | audit editoriale |

Il testo tradotto non è un campo di `ContentItem`: è separato in `ContentTranslation`, con `id`, `contentId`, `locale`, `title`, `summary`, `body`, tag e sinonimi ricercabili nel locale, `translationStatus`, `translationMethod`, `sourceVersion`, `translatedAt`, `reviewedAt`, `reviewerId` e `updatedAt`. Gli stati sono `missing → generated → needsReview → approved → published → outdated`. Quando cambia la versione canonica, le traduzioni con `sourceVersion` precedente diventano `outdated`. Solo una traduzione `published`, con fonte/licenza valide, è visualizzabile nel relativo locale; le versioni generate non sono automaticamente verificate.

I topic iniziali includono ritratto, paesaggio, street, macro, wildlife, sport, eventi, notturna, astrofotografia, smartphone, composizione, illuminazione, editing e attrezzatura.

## Terminologia e fallback

Un glossario fotografico multilingua, revisionato editorialmente e separato dai testi UI, conserva termini approvati per apertura, tempo di esposizione, sensibilità ISO, lunghezza focale, profondità di campo, distanza iperfocale, compensazione dell'esposizione, gamma dinamica, bilanciamento del bianco, filtro ND, crop factor, bracketing e focus stacking. La risoluzione usa prima il locale completo (ad esempio `pt-BR`), poi una lingua base compatibile quando appropriato, quindi inglese; se non esiste una traduzione completa, il contenuto è indisponibile invece di mescolare lingue nella stessa pagina.

## Pipeline editoriale multilingua

La pipeline separata dall'app rileva la lingua del documento, estrae il testo nella lingua originale, crea o aggiorna il contenuto canonico e conserva fonte, autore, licenza e versione della fonte. Genera quindi solo le traduzioni richieste, applica il glossario fotografico e le invia in revisione. Soltanto le traduzioni approvate possono passare a `published`; le traduzioni generate automaticamente passano da `generated` a `needsReview` e non sono mai pubblicate in automatico. Ogni aggiornamento del canonico invalida le traduzioni derivate tramite `sourceVersion`.

## Dati utente

`UserProfile` raccoglie livello, generi preferiti, corpi macchina, obiettivi, smartphone, interessi e obiettivi di apprendimento. `SavedItem` lega utente e contenuto, con raccolta opzionale, nota, stato e data di salvataggio. Le foto associate sono fuori MVP e richiedono policy di retention.

## Idee a regole

Una `IdeaRule` definisce vincoli opzionali (luogo, ora, meteo, attrezzatura, genere, durata, difficoltà), testo della proposta e impostazioni consigliate. Il motore assegna un punteggio alle regole compatibili e spiega i criteri usati; non presenta risultati AI come fatti oggettivi.

## Implementazione Step 3

Le entità implementate usano codici enum persistenti per le dieci tipologie, difficoltà, stato editoriale (`imported`, `processed`, `needsReview`, `approved`, `published`, `archived`), stato di traduzione e metodo (`original`, `machine`, `human`, `machineReviewed`). `ContentSource` è normalizzata e collegata molti-a-molti ai contenuti; tag e relative traduzioni sono tabelle separate.
