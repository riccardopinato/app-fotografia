# Design System

## Principi

L'interfaccia deve evocare uno strumento creativo affidabile: gerarchia chiara, immagini al servizio del contenuto, superfici sobrie e azioni facilmente raggiungibili. Adottare Material 3 come base tecnica, ma non come aspetto predefinito: token e componenti centralizzati costruiscono un'identità FrameLab riconoscibile. La specifica approvabile di direzione visiva, wireframe, motion e immagini è in `VISUAL_DIRECTION.md`.

## Fondazioni

- Modalità chiara e scura, con contrasto WCAG AA per testo e controlli; la palette semantica è definita nella direzione visiva.
- Scala di spaziatura a 4 pt: 4, 8, 12, 16, 24, 32, 48.
- Raggio: 12 per card, 16 per contenitori principali, pill solo per filtri/tag.
- Tipografia: ruoli display, title, body, label definiti nel tema; mai dimensioni sparse nei widget.
- Icone con etichetta accessibile; target interattivo minimo 48×48 dp.

## Componenti iniziali

App scaffold, barra di navigazione, card contenuto, chip filtro/tag, stato vuoto, skeleton/loading, badge Premium, pulsante salva, selettore stato archivio e banner informativo. Ogni componente deve prevedere stato disabled, errore, offline e focus dove applicabile. Le card riservano lo spazio dell'immagine con ratio costante e non causano layout shift.

## Accessibilità e localizzazione

Supportare screen reader, ordine di focus logico, testo scalabile senza clipping e rispetto di `reduce motion`. Non affidare stato o significato al solo colore. Italiano è la lingua iniziale; stringhe e formati non devono essere hard-coded nei widget per consentire la futura localizzazione.
