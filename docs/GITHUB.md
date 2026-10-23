# Manter o F.R.A.N.C.E no GitHub

O projeto já está conectado ao repositório **`lucsilfer/france`** — não crie outro. Cada versão foi enviada numa branch própria:

| Branch | Conteúdo |
|---|---|
| `main` | Fase 3 |
| `atualizacao-3.5` | 3.5 |
| `fase-4` | Fase 4 (contém a 3.5) |
| `fase-5` | Fase 5 (contém a 4) |
| `versao-6` | **6.0** (contém todas as anteriores) |

## Levar a 6.0 para `main` (recomendado antes de publicar na Vercel)

Pelo site do GitHub: *Pull requests → New pull request* → base `main`, compare `versao-6` → *Create* → *Merge*. O histórico de todas as fases fica preservado.

Pelo terminal:

```bash
git checkout main
git pull
git merge --no-ff versao-6 -m "F.R.A.N.C.E 6.0"
git push origin main
```

## Atualizar o projeto no seu computador

```bash
git clone https://github.com/lucsilfer/france.git   # só na primeira vez
cd france
git pull                                           # nas próximas
npm install
```

O `.env.local` nunca vai para o GitHub (está no `.gitignore`): copie de `.env.example` em cada computador.

## Enviar uma nova versão (sem perder histórico)

1. Crie uma branch: `git checkout -b minha-mudanca`
2. Edite, depois confira: `npm run check` (e `npm run build` antes de publicar)
3. Se mudou regras em `src/rules`: `npm run rules:sql` gera a **próxima** migração de regras (as antigas ficam congeladas) — aplique-a no Supabase.
4. `git add -A && git commit -m "Descrição da mudança"`
5. `git push -u origin minha-mudanca` → a Vercel cria uma **prévia** para testar.
6. Abra um Pull Request para `main` e faça o merge → a Vercel publica em produção.

## Recebeu um ZIP novo (como o FRANCE-versao-6.0.zip)?

```bash
cd france                       # sua cópia ligada ao GitHub
git checkout -b versao-nova
# copie o conteúdo da pasta FRANCE/ do ZIP por cima (mantenha a pasta .git e o seu .env.local)
git add -A
git commit -m "F.R.A.N.C.E — versão nova"
git push -u origin versao-nova
```

Depois, Pull Request para `main`. Nunca apague a pasta `.git` nem force push (`--force`) em `main`.

## O que nunca deve ir para o repositório

`.env.local` e qualquer `.env.*` (exceto `.env.example`), senhas, chaves `service_role`, tokens, `node_modules/`, `.next/`, `.vercel/`, ZIPs e logs. O `.gitignore` já cobre tudo isso. Se uma chave vazar por engano, **gere uma nova no Supabase** (*Project Settings → API*) — apagar o commit não basta.
