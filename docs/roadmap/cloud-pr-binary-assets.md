# Asset binari di piattaforma nelle pull request Cloud

## Motivo

Codex Cloud non supporta file binari nelle pull request. Sono quindi esclusi dal tracciamento solo gli asset placeholder generati automaticamente da `flutter create`, non asset creativi o funzionali definitivi.

## File esclusi

- Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`.
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-*.png`.
- iOS: `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png`, `LaunchImage@2x.png` e `LaunchImage@3x.png`.

## Rigenerazione

Prima della prima build Android o iOS, ripristinare i placeholder con:

```bash
/root/flutter/bin/flutter create --platforms=android,ios .
```

Il comando rigenera gli asset predefiniti mancanti senza rappresentare una scelta di branding. Prima della pubblicazione sugli store, tali placeholder dovranno essere sostituiti con asset finali gestiti tramite un canale compatibile con i binari.
