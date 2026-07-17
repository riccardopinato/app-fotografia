# Architettura

## Scelta target

Flutter/Dart, Material 3 personalizzato, Riverpod e GoRouter. Il modello è clean architecture pragmatica, feature-first e offline-first. Android e iOS usano il renderer Impeller previsto dalla piattaforma: non è una dipendenza da aggiungere né una tecnologia da configurare come SDK esterno.

```text
lib/
  app/                 bootstrap, router, tema
  core/                errori, utilità, contratti condivisi
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

SQLite/Drift è la fonte locale per profilo, catalogo e archivio. In una fase successiva Firestore sincronizzerà solo dati autorizzati; una coda di operazioni con timestamp e strategia di conflitto documentata eviterà che la rete impedisca lettura o salvataggio.

## Integrazioni future

Firebase Authentication, Firestore, Storage e Remote Config; RevenueCat; AdMob; servizi meteo/astronomici e analisi AI. Nessuna è richiesta per avviare l'MVP. Ogni SDK risiede dietro un'interfaccia di dominio e viene inizializzato solo con configurazione valida.

## Immagini e rendering

La UI richiede un'astrazione per immagini remota/cache quando arriverà il catalogo sincronizzato. L'implementazione deve richiedere varianti thumbnail e dettaglio dimensionate alla superficie reale, mantenere un aspect ratio noto con placeholder/skeleton, usare lazy loading e paginazione, e annullare richieste fuori viewport se il client scelto lo supporta. La cache disco e memoria deve avere limiti, TTL e invalidazione tramite versione o URL firmato; nessuna immagine originale va richiesta per una miniatura. Questi requisiti sono dettagliati in `VISUAL_DIRECTION.md` e non giustificano l'aggiunta anticipata di package.
