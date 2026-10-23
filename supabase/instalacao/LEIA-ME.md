# SQL para colar no Supabase (SQL Editor)

Gerados a partir de `supabase/migrations/` (mesmo conteúdo, só juntos). Nenhum apaga dados e todos podem ser executados de novo.

| Situação | Arquivo |
|---|---|
| Projeto Supabase **novo** (ex.: o criado pelo Lovable) | `FRANCE-SQL-instalacao-completa.sql` — ou, se o editor reclamar do tamanho, `parte1`, `parte2` e `parte3`, nessa ordem |
| Banco que **já tem a Fase 5** | `FRANCE-SQL-atualizar-a-partir-da-fase5.sql` |

Depois: *Storage → Buckets* deve mostrar `france-media` como **Private**; em *Authentication → URL Configuration*, configure Site URL e Redirect URLs (veja `docs/DEPLOY-VERCEL.md`).
