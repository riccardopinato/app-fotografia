# ADR 0001 — Offline-first per l'MVP

- **Stato:** Accettata
- **Contesto:** consigli e archivio devono funzionare anche in luoghi senza connettività.
- **Decisione:** SQLite/Drift è la fonte locale; i servizi cloud sono un'estensione futura dietro repository.
- **Conseguenze:** occorrono migrazioni e seed locali; la sync richiederà in seguito gestione conflitti esplicita.
