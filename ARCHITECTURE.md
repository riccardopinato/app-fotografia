# Architettura

## Scelta target

Flutter/Dart, Material 3 personalizzato, Riverpod e GoRouter. Il modello è clean architecture pragmatica, feature-first, offline-first e localizzato fin dall'origine. Android e iOS usano il renderer Impeller previsto dalla piattaforma: non è una dipendenza da aggiungere né una tecnologia da configurare come SDK esterno.

```text
lib/
  app/                 bootstrap, router, tema
  core/                errori, localizzazione, utilità, contratti condivisi
  features/
    catalog/           presentation | domain | data
    home/              presentation | domain
    library/           presentation | domain | data
    profile/           presentation | domain | data
    onboarding/        presentation | domain | data
```

## Confini

- **Presentation:** pagine, widget, controller Riverpod e stato UI.
- **Domain:** entità immutabili, use case e contratti repository.
- **Data:** DTO, database Drift/SQLite, mapper e implementazioni repository.
- **Core:** primitive non legate a feature e policy trasversali.

## Dati e sincronizzazione

SQLite/Drift è la fonte locale per profilo, catalogo e archivio. Il catalogo è localizzato per pacchetti linguistici: il dispositivo conserva e aggiorna separatamente la lingua selezionata, con indici di ricerca per locale e aggiornamenti incrementali; non scarica automaticamente tutte le traduzioni. Preferiti e progressi restano associati all'identità concettuale del contenuto, quindi il cambio lingua non li perde. In una fase successiva Firestore sincronizzerà solo dati autorizzati; una coda di operazioni con timestamp e strategia di conflitto documentata eviterà che la rete impedisca lettura o salvataggio.

## Localizzazione

La UI usa esclusivamente il sistema ufficiale Flutter: `flutter_localizations`, `intl`, `gen_l10n` e file ARB. Le chiavi ARB sono semantiche e stabili; i widget non contengono testo visibile hard-coded, non concatenano frammenti per formare frasi e usano messaggi parametrizzati, plurali e genere grammaticale quando necessario. La configurazione dell'app espone delegati e locale supportati, usa `en` come fallback globale e gestisce `pt-BR` prima della lingua base compatibile; se manca anche l'inglese, mostra uno stato di contenuto non disponibile senza crash.

I formati di data, ora, numeri, decimali, valute e unità dipendono dal locale tramite `intl`; le future offerte usano prezzo e valuta restituiti dallo store, senza composizione manuale né conversioni autonome. Layout, ordine di lettura e componenti devono rispettare `Directionality`, incluse lingue RTL. Le immagini non contengono testo, salvo varianti localizzate gestite esplicitamente.

La selezione della lingua (dispositivo, manuale, ripristino automatico) è una preferenza locale. Il dominio espone una policy di risoluzione delle traduzioni in ordine: locale completo richiesto, lingua base compatibile quando appropriato, inglese, quindi indisponibile. Una pagina usa una sola traduzione risolta, evitando frammenti di lingue differenti salvo fallback dichiarato.

## Integrazioni future

Firebase Authentication, Firestore, Storage e Remote Config; RevenueCat; AdMob; servizi meteo/astronomici e analisi AI. Nessuna è richiesta per avviare l'MVP. Ogni SDK risiede dietro un'interfaccia di dominio e viene inizializzato solo con configurazione valida.

## Immagini e rendering

La UI richiede un'astrazione per immagini remota/cache quando arriverà il catalogo sincronizzato. L'implementazione deve richiedere varianti thumbnail e dettaglio dimensionate alla superficie reale, mantenere un aspect ratio noto con placeholder/skeleton, usare lazy loading e paginazione, e annullare richieste fuori viewport se il client scelto lo supporta. La cache disco e memoria deve avere limiti, TTL e invalidazione tramite versione o URL firmato; nessuna immagine originale va richiesta per una miniatura. Questi requisiti sono dettagliati in `VISUAL_DIRECTION.md` e non giustificano l'aggiunta anticipata di package.

## RecommendationEngine (Step 6)

La Home legge i soli contenuti pubblicabili dal repository esistente e passa entità di dominio al `RecommendationEngine`, puro e senza dipendenze Flutter o Drift. Il motore deduplica per id, assegna pesi espliciti (interesse 40, obiettivo 24, livello 18, attrezzatura 12, locale esatto 4, penalità premium 3), conserva le motivazioni e risolve i pareggi per id. Con un profilo incompleto offre una selezione editoriale locale, senza inventare contenuti e senza AI generativa.
