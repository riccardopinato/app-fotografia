# ADR 0005 — Contenuti localizzati normalizzati

- **Stato:** Accettata
- **Decisione:** `ContentItem` conserva solo metadati concettuali; `ContentTranslation` conserva testo e stato per locale, con unicità `(contentId, locale)` e fallback `locale completo → lingua base → en → indisponibile`.
- **Conseguenze:** le traduzioni sono eliminate con il contenuto, non esistono colonne per lingua né JSON opaco, e il repository pubblico restituisce solo contenuti/traduzioni pubblicati con almeno una fonte dai diritti pubblicabili.
