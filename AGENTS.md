# Istruzioni per i contributori

## Direzione del progetto

FrameLab è un prodotto mobile Flutter per l'apprendimento della fotografia. Il primo rilascio privilegia un'esperienza veloce, accessibile e utilizzabile senza rete; non introdurre dipendenze cloud, chiavi o SDK commerciali senza uno step esplicito della roadmap.

## Regole operative

- Leggere `PRODUCT_BIBLE.md`, `ROADMAP.md` e `PROJECT_RULES.md` prima di modificare il progetto.
- In Codex Cloud preferire `flutter` e `dart` dal `PATH` quando disponibili; in alternativa usare `/root/flutter/bin/flutter` e `/root/flutter/bin/dart`. Non dichiarare il progetto bloccato prima di aver verificato entrambi i percorsi assoluti.
- Codex Cloud non può includere file binari nelle pull request. Gli asset binari di piattaforma generati da Flutter esclusi dal repository devono essere rigenerati con Flutter prima di una build nativa.
- Implementare un solo step di roadmap per change set; non anticipare gli step successivi.
- Usare Dart/Flutter con struttura feature-first e separazione presentation/domain/data.
- Usare esclusivamente Flutter per Android e iOS; non introdurre React Native, SwiftUI, Jetpack Compose o librerie del loro ecosistema.
- Mantenere i contenuti editoriali separati da UI e persistenza; non copiare testo da fonti protette.
- Non aggiungere segreti, file `.env` reali, chiavi Firebase, AdMob o RevenueCat al repository.
- Aggiornare la documentazione quando una decisione o un confine di prodotto cambia.
- Eseguire soltanto i controlli pertinenti allo step e riportarne l'esito.

## Qualità

Le interfacce devono rispettare Material 3 personalizzato e la direzione definita in `VISUAL_DIRECTION.md`, supportare testo scalabile e semantica accessibile, e funzionare con connettività assente. Non aggiungere animazioni decorative o dipendenze grafiche prima dell'approvazione del design system. Scrivere test per logica di dominio e flussi critici quando viene introdotto codice.
