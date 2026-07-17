# Step 1 — Risoluzione ambiente Flutter

- **Stato:** risolto.
- **Evidenza:** Flutter 3.44.6 e Dart 3.12.2 sono disponibili tramite `/root/flutter/bin/flutter` e `/root/flutter/bin/dart`, anche quando la loro risoluzione automatica dal `PATH` non è affidabile.
- **Esito:** lo Step 1 è stato completato usando esclusivamente i percorsi assoluti. Gli avvisi di `flutter doctor -v` relativi a Android SDK, Chrome, toolchain Linux e Xcode non bloccano il bootstrap Android/iOS in questo ambiente.
