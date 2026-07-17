# ADR 0004 — Direzione visiva e prestazioni immagini

- **Stato:** Accettata
- **Contesto:** il valore del prodotto dipende da immagini di qualità, ma il caricamento non può compromettere fluidità e accessibilità.
- **Decisione:** Flutter/Material 3 personalizzato con Impeller di piattaforma; design sobrio centrato sulle fotografie; immagini responsive con ratio stabile, lazy loading, paginazione e cache limitata/invalida.
- **Conseguenze:** nessun package grafico o motion viene introdotto prima dell'approvazione del design system; le integrazioni immagine future devono rispettare la specifica `VISUAL_DIRECTION.md`.
