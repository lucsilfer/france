# F.R.A.N.C.E

**Sistema de Gerenciamento de Lendas** — plataforma digital do RPG de mesa **Tríade das Lendas**: contas, fichas, rolagens, campanhas, Escudo do Mestre e homebrew.

> Versão **Atualização 3.5** sobre a Fase 3. Usa o mesmo banco: só acrescenta duas migrações incrementais.

- O que mudou na 3.5, resultados dos testes e problemas em aberto: [`docs/ATUALIZACAO-3.5.md`](docs/ATUALIZACAO-3.5.md)
- Fase 3 (inventário, poderes, níveis, forma Lenda): [`docs/FASE3.md`](docs/FASE3.md)

- Sistema visual (cores, componentes, logotipo, inicialização): [`docs/DESIGN.md`](docs/DESIGN.md)
- Planejamento e progresso: [`docs/PLANEJAMENTO.md`](docs/PLANEJAMENTO.md)
- Regras extraídas do livro e pontos a confirmar: [`docs/REGRAS-E-PENDENCIAS.md`](docs/REGRAS-E-PENDENCIAS.md)

## Atualizar uma instalação existente (mesmo Supabase)

**Não crie outro banco e não rode de novo as migrações antigas.** Nenhum personagem, conta, poder ou inventário é apagado.

1. **Backup (recomendado)** — no Supabase: *Database → Backups*, ou `supabase db dump`.
2. **Banco** — em *SQL Editor*, execute **somente** as migrações que você ainda não aplicou, nesta ordem:
   - Vindo da **Fase 3** (já tem `20261023000100_fase3_sistemas.sql`): rode só
     1. `supabase/migrations/20261024000000_rules_sync_3_5.sql`
     2. `supabase/migrations/20261024000100_atualizacao_3_5.sql`
   - Vindo da **Fase 2 / redesign**: rode antes as duas da Fase 3 (`20261023000000_rules_sync_fase3.sql` e `20261023000100_fase3_sistemas.sql`) e depois as duas acima.

   Se as migrações anteriores foram aplicadas pela CLI, `supabase db push` aplica só as novas.
   As duas migrações da 3.5 podem ser reaplicadas sem efeito colateral. O que elas fazem com dados existentes:
   - **PV**: o máximo passa a ser (FOR + CON) ÷ 3 — ele é sempre calculado a partir dos atributos, então nada derivado é apagado. Só o **PV atual** que ficou acima do novo máximo é reduzido, e cada ajuste é gravado na tabela `pv_formula_fix_log` (o SQL Editor mostra quantas formas foram ajustadas).
   - **Prodígios**: poderes já criados passam a custar 0 PC.
   - **Habilidades**: nada é apagado. Personagens com habilidades pendentes só ficam impedidos de **subir** de nível até criá-las.
3. **Código** — substitua os arquivos do projeto pelos deste pacote, mantendo seu `.env.local` (ele não vem no ZIP).
4. `npm install && npm run build && npm start` (ou `npm run dev`).

## Instalação do zero

Requisitos: Node 22.6+ e um projeto no [Supabase](https://supabase.com) (o plano gratuito serve).

1. **Banco** — no Supabase, abra *SQL Editor* e execute, **nesta ordem**, os arquivos de `supabase/migrations/`:
   `20261021000000_folkara_schema.sql` → `20261022000000_rules_sync.sql` → `20261022000100_phase2_character.sql` →
   `20261023000000_rules_sync_fase3.sql` → `20261023000100_fase3_sistemas.sql` →
   `20261024000000_rules_sync_3_5.sql` → `20261024000100_atualizacao_3_5.sql`.
   (Com a CLI: `supabase link` e `supabase db push`.)
2. **Autenticação** — em *Authentication → URL Configuration*:
   - *Site URL*: `http://localhost:3000` (depois, a URL de produção)
   - *Redirect URLs*: adicione `http://localhost:3000/auth/callback` (e a de produção)
3. **Variáveis** — copie `.env.example` para `.env.local` e preencha com *Project URL* e *anon public key* (*Project Settings → API*).
4. **Instalar e rodar**
   ```bash
   npm install
   npm run dev        # http://localhost:3000
   ```

## Testes

```bash
npm test           # motor de regras + sincronia regras↔banco (node:test, sem dependências)
npm run rules:sql  # regenera a migração de regras após mudar src/rules
npm run typecheck  # TypeScript do projeto todo
npm run test:db    # migrações + RLS + Fase 2/3 + Atualização 3.5 + paridade motor×banco (1849 casos) num PostgreSQL local
```

`test:db` usa `supabase/tests/00_supabase_shim.sql`, que simula `auth.users`/`auth.uid()` — **não** rode o shim no Supabase real.

## Estrutura

```
src/rules/           motor de regras (TS puro) + dados do livro
src/app/(auth)/      login, cadastro, recuperação de senha
src/app/(app)/       painel, perfil, campanhas, convite, homebrew, personagens
  personagens/[id]/  ficha (abas em panel/), criar/ (assistente), lenda/ (forma Lenda)
src/components/      UI compartilhada
src/lib/             Supabase, validação (Zod), consultas
supabase/migrations  esquema, RLS e funções
supabase/tests       testes de permissão, regras e paridade
```

## Segurança

- Nunca coloque a `service_role` key em variáveis `NEXT_PUBLIC_*`.
- Toda permissão é aplicada no banco (RLS); a interface só reflete o que o banco permite.
- Custos de poder, limites de perícia, modificadores de arma e gasto de PC são validados no banco (triggers e funções `security definer`), não só no navegador. Rolagens de ataque e poder acontecem no servidor.
