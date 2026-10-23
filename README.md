# F.R.A.N.C.E

**Sistema de Gerenciamento de Lendas** — plataforma digital do RPG de mesa **Tríade das Lendas**: contas, fichas, rolagens, campanhas, Escudo do Mestre, homebrew e fotos de personagens.

> **Versão 6.0** — combate por rolagens opostas, granadas, layout da ficha revisado e preparação para publicação (GitHub + Vercel + Supabase). Usa o mesmo banco das versões anteriores: só acrescenta duas migrações incrementais.

| Documento | Conteúdo |
|---|---|
| [`docs/VERSAO6.md`](docs/VERSAO6.md) | O que mudou na 6.0, resultados dos testes e pendências |
| [`docs/DEPLOY-VERCEL.md`](docs/DEPLOY-VERCEL.md) | Publicar na internet (Vercel + Supabase) |
| [`docs/GITHUB.md`](docs/GITHUB.md) | Enviar novas versões ao mesmo repositório, preservando o histórico |
| [`supabase/STORAGE.md`](supabase/STORAGE.md) | Bucket de imagens e políticas |
| [`docs/REGRAS-E-PENDENCIAS.md`](docs/REGRAS-E-PENDENCIAS.md) | Regras extraídas do livro, decisões e pontos a confirmar |
| [`docs/FASE5.md`](docs/FASE5.md) · [`docs/FASE4.md`](docs/FASE4.md) · [`docs/ATUALIZACAO-3.5.md`](docs/ATUALIZACAO-3.5.md) · [`docs/FASE3.md`](docs/FASE3.md) | Histórico das versões |
| [`docs/DESIGN.md`](docs/DESIGN.md) · [`docs/PLANEJAMENTO.md`](docs/PLANEJAMENTO.md) | Sistema visual e planejamento |

## Requisitos

- Node.js **22.18 ou mais novo** (o motor de regras usa arquivos `.ts` executados direto pelo Node nos testes).
- Um projeto no [Supabase](https://supabase.com) (o plano gratuito serve).

## Banco de dados — migrações

Execute no *SQL Editor* do Supabase **só as que faltam**, sempre nesta ordem (ou `supabase db push` com a CLI). Nenhuma apaga dados.

| # | Arquivo | Versão |
|---|---|---|
| 1 | `20261021000000_folkara_schema.sql` | Fase 1 |
| 2 | `20261022000000_rules_sync.sql` | Fase 2 |
| 3 | `20261022000100_phase2_character.sql` | Fase 2 |
| 4 | `20261023000000_rules_sync_fase3.sql` | Fase 3 |
| 5 | `20261023000100_fase3_sistemas.sql` | Fase 3 |
| 6 | `20261024000000_rules_sync_3_5.sql` | 3.5 |
| 7 | `20261024000100_atualizacao_3_5.sql` | 3.5 |
| 8 | `20261025000000_rules_sync_fase4.sql` | Fase 4 |
| 9 | `20261025000100_fase4_campanhas.sql` | Fase 4 |
| 10 | `20261026000100_fase5_homebrew.sql` | Fase 5 (configura também o Storage) |
| 11 | `20261027000000_rules_sync_v6.sql` | **6.0** |
| 12 | `20261027000100_v6_finalizacao.sql` | **6.0** |

### Atualizar a partir da Fase 5

1. **Backup** — *Database → Backups* (ou `supabase db dump`).
2. Rode **11** e depois **12**. O que elas fazem com dados existentes:
   - Regras do motor sincronizadas (classificação do d100, confronto, granadas) — nada guardado muda.
   - Nova tabela `combat_confrontations` (histórico dos confrontos) e `item_uses` (impede consumo duplo). Combates antigos continuam iguais.
   - Granadas: o item genérico antigo continua nas fichas que já o têm; os 5 tipos novos entram no catálogo. Demolidores que já receberam o kit **não** recebem granadas de novo.
   - `campaign_party` passa a devolver a foto da forma ativa (colegas de campanha veem as fotos do grupo).
   - `combat_confrontations` entra na publicação Realtime.
3. Atualize o código (veja [`docs/GITHUB.md`](docs/GITHUB.md)). Na Vercel, cada `git push` publica sozinho.

## Instalação local

```bash
git clone https://github.com/<seu-usuario>/france.git
cd france
cp .env.example .env.local      # preencha com Project URL e anon key (Supabase → Project Settings → API)
npm install
npm run dev                     # http://localhost:3000
```

No Supabase, em *Authentication → URL Configuration*: *Site URL* `http://localhost:3000` e, em *Redirect URLs*, `http://localhost:3000/auth/callback`.

## Scripts

```bash
npm run dev        # desenvolvimento
npm run build      # build de produção (o mesmo que a Vercel roda)
npm start          # servir o build
npm run typecheck  # TypeScript do projeto todo
npm test           # motor de regras + sincronia regras↔banco (node:test, sem dependências)
npm run check      # typecheck + test
npm run rules:sql  # regenera a migração de regras e os testes de paridade após mudar src/rules
npm run test:db    # todas as migrações + testes de banco num PostgreSQL local (RLS, fases 2–6, paridade, Storage simulado)
```

`test:db` usa `supabase/tests/00_supabase_shim.sql`, que simula `auth` e um `storage.objects` mínimo — **não** rode o shim no Supabase real.

## Estrutura

```
src/rules/           motor de regras (TS puro) + dados do livro; opposed.ts = combate por rolagens opostas
src/app/(auth)/      login, cadastro, recuperação de senha
src/app/(app)/       painel, perfil, personagens, campanhas (central + escudo/), convite, homebrew
src/components/      UI compartilhada (campaign/, homebrew/, media/, sheet/, ui/)
src/lib/             Supabase, validação (Zod), consultas, imagens, rolagens
supabase/migrations  esquema, RLS, funções e Storage (incrementais)
supabase/tests       testes de permissão, regras, paridade motor×banco e Storage
scripts/             geradores da migração de regras e dos testes de paridade
docs/                guias e histórico
```

## Segurança

- Só a **anon key** vai para o navegador. Nunca coloque a `service_role` key em variáveis `NEXT_PUBLIC_*` nem no código — o app não precisa dela.
- Toda permissão é aplicada no banco (RLS + funções `security definer`); a interface só reflete o que o banco permite.
- **Dados que decidem o jogo são rolados no banco**: confrontos (os dois d100 e o dano), granadas em combate e rolagens livres da campanha. O valor da perícia de um personagem é calculado no banco a partir da ficha — não é aceito do navegador.
- Pedidos repetidos não descontam duas vezes (PV, PC, granadas, técnicas, dano de confronto).
- Imagens no bucket privado `france-media`; o banco guarda só o caminho; links assinados com a sessão de quem vê.
- Entrar por convite sempre torna a pessoa **jogadora**. O Mestre só vê fichas com vínculo aceito e só altera PV/PC/condições se o jogador autorizar.
