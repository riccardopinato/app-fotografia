# Direzione visiva, motion design e prestazioni

## Approvazione richiesta

Questa è la specifica da approvare prima di costruire schermate definitive, introdurre motion decorativo o aggiungere dipendenze grafiche. Flutter è l'unica tecnologia applicativa per Android e iOS; Material 3 è la base tecnica e non un tema generico. Il renderer Impeller è quello previsto dalla piattaforma, non una dipendenza esterna.

## Direzione creativa

FrameLab deve ricordare un taccuino editoriale fotografico: preciso, calmo, creativo e Premium senza ostentazione. Le fotografie sono l'elemento dominante; ampi spazi negativi, bordi sottili, ombre leggere e gerarchia tipografica netta danno struttura. Sono esclusi neon, glassmorphism, bagliori, gradienti decorativi e animazioni continue.

## Token iniziali

| Ruolo | Chiaro | Scuro | Uso |
| --- | --- | --- | --- |
| canvas | `#F7F7F4` | `#121313` | sfondo principale |
| surface | `#FFFFFF` | `#1B1D1C` | card e pannelli |
| ink | `#1A1C1B` | `#F2F1EC` | testo primario |
| muted | `#626863` | `#BFC5BE` | testo secondario/bordi |
| accent | `#386A5A` | `#8CC9B0` | azioni e stato attivo |
| focus | `#285EA8` | `#A9C7FF` | focus/accessibilità |
| premium | `#695C2F` | `#D7C77D` | badge o accento discreto |
| danger | `#B3261E` | `#F2B8B5` | errore/distruttivo |

I colori sono semantici, non sono l'unico veicolo di stato e devono essere verificati a contrasto AA. Tipografia: una famiglia sans leggibile di sistema come fallback, con ruoli `display`, `headline`, `title`, `body`, `label`; titoli compatti e corpo ad alta leggibilità. Spaziatura 4 pt (4, 8, 12, 16, 24, 32, 48); raggi 12/16 dp; bordi 1 dp; elevazione minima.

## Navigazione e wireframe

La navigazione primaria ha cinque destinazioni: **Home**, **Esplora**, **Idee**, **Archivio**, **Profilo**. Su telefoni usa NavigationBar; su tablet/ampie larghezze NavigationRail adattiva. Analisi foto è una voce contestuale o strumento secondario, non una destinazione dominante fino alla sua reale implementazione.

```text
Home      [saluto/progresso] [hero: consiglio del giorno] [curiosità] [idea] [sfida]
Esplora   [ricerca] [filtri] [griglia/lista card a ratio stabile] [paginazione]
Idee      [contesto] [preferenze] [proposta spiegabile] [salva/prova]
Archivio  [ricerca] [raccolte] [da provare | provato | completato] [note]
Profilo   [livello] [generi] [attrezzatura] [progresso] [impostazioni]
```

Ogni schermata definisce almeno stati loading (skeleton), empty con azione utile, errore con retry e offline con contenuto locale o messaggio esplicito. Touch target minimo 48×48 dp, focus visibile, etichette semantiche, testo scalabile e layout verificato su piccolo, grande e tablet.

## Specifica motion

Animazioni native Flutter; Hero solo tra immagine/card e dettaglio quando il contenuto è già disponibile. Durate: feedback 120–160 ms, espansione/filtro 180–220 ms, transizione pagina 220–280 ms. Curve: standard ease-out per ingresso, ease-in-out per cambi stato. Il salvataggio, cambio stato archivio, filtri, progresso sfida e stati di elaborazione possono avere feedback breve e funzionale.

Nessuna animazione deve bloccare input o rallentare la navigazione. Rispettare `MediaQuery.disableAnimations`/riduzione movimento: ridurre a dissolvenze brevi o aggiornamenti istantanei. Lottie è ammesso solo per onboarding completato, elaborazione foto, sblocco Premium o stato vuoto importante; non sostituisce gli indicatori di caricamento ordinari e non viene aggiunto prima dell'approvazione.

## Strategia immagini e prestazioni

1. Il backend futuro deve produrre varianti: thumbnail per card, media per anteprima, originale solo per zoom/download consentito.
2. La UI richiede la variante vicina alle dimensioni dipinte, considera densità pixel e fissa `AspectRatio` prima dell'arrivo dei byte; placeholder e skeleton hanno la medesima geometria.
3. Griglie e liste usano lazy loading e paginazione. Precache è limitato al contenuto immediatamente successivo e solo con memoria/rete adeguate.
4. Cache disco e memoria hanno limiti espliciti, TTL e invalidazione con versione dell'asset; gli URL mutati invalidano la cache. Le richieste non più visibili devono essere annullate quando il client lo consente.
5. Gestire errori di rete con fallback stabile e retry; non decodificare o mantenere immagini a risoluzione originale per thumbnail.

Prima del rilascio, profilare scroll, jank, consumo memoria e decoding su almeno un Android di fascia media; verificare che caricamento e sostituzione delle immagini non producano layout shift.

## Paywall

Il paywall segue gli stessi token, con un accento Premium discreto. Presenta beneficio, Free/Remove Ads/Pro, prezzo, periodicità, prova, rinnovo, annullamento, restore e link legali in modo leggibile. Non usa dark pattern. RevenueCat Paywalls remoto e paywall Flutter personalizzato sono alternative da valutare nello step di monetizzazione: la decisione sarà registrata in un ADR prima dell'implementazione.
