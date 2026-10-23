# Publicar o F.R.A.N.C.E na internet (GitHub + Vercel + Supabase)

O site fica hospedado na **Vercel** (Next.js), os dados e as imagens no **Supabase** e o código no **GitHub**. Depois de configurado, cada `git push` na branch principal publica uma nova versão sozinho — o seu computador não precisa ficar ligado.

> Este guia foi preparado sem acesso às suas contas: nenhuma publicação foi feita por mim. Siga os passos com as suas contas.

## 0. Antes de começar

- Banco atualizado: todas as migrações do README aplicadas no seu projeto Supabase (inclusive as duas da 6.0).
- Bucket `france-media` aparece em *Storage → Buckets* como **Private** (criado pela migração da Fase 5).
- Em mãos, no Supabase (*Project Settings → API*): **Project URL** e **anon public key**. **Não** use a `service_role`.

## 1. Enviar o projeto ao GitHub

O projeto já está no repositório `lucsilfer/france`. Para mandar esta versão, veja [`GITHUB.md`](GITHUB.md). Em resumo: commit na branch de trabalho, push, e merge em `main` (a branch que a Vercel publica).

## 2. Conectar o repositório à Vercel

1. Entre em <https://vercel.com> com a sua conta do GitHub.
2. *Add New… → Project* → escolha o repositório `france` → *Import*.
3. *Framework Preset*: **Next.js** (detectado sozinho). *Root Directory*: a raiz. *Build Command*: `npm run build`. *Install Command*: `npm install`. *Output*: padrão.
4. *Node.js Version* (em *Settings → General*, depois do primeiro deploy): **22.x**.

## 3. Variáveis de ambiente (Vercel → Project → Settings → Environment Variables)

| Nome | Valor | Ambientes |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Project URL do Supabase (`https://xxxx.supabase.co`) | Production, Preview, Development |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | anon public key | Production, Preview, Development |
| `NEXT_PUBLIC_SITE_URL` | o endereço público do site, ex.: `https://france.vercel.app` (ou seu domínio) | Production |

- São as mesmas variáveis do `.env.local` — o código não usa nenhuma outra.
- Se `NEXT_PUBLIC_SITE_URL` não for definida, o app usa o domínio de produção que a Vercel informa; definir deixa os e-mails sempre corretos.
- **Nunca** cadastre a `service_role` key: o app não precisa dela.
- Mudou uma variável? *Deployments → … → Redeploy* (variáveis `NEXT_PUBLIC_*` entram no build).

Clique em **Deploy**. Ao terminar, a Vercel mostra o endereço (ex.: `https://france-xxxx.vercel.app`).

## 4. Endereços de autenticação no Supabase

*Supabase → Authentication → URL Configuration*:

- **Site URL**: o endereço de produção (ex.: `https://france.vercel.app`).
- **Redirect URLs** (adicione todos):
  - `https://france.vercel.app/auth/callback`
  - `https://*-lucsilfer.vercel.app/auth/callback` (prévias da Vercel; ajuste ao padrão dos seus endereços de preview)
  - `http://localhost:3000/auth/callback` (desenvolvimento local)

Se usar domínio próprio, troque `france.vercel.app` pelo domínio nas três telas (Vercel → *Domains*, `NEXT_PUBLIC_SITE_URL` e Supabase).

## 5. Validar em produção (roteiro de 10 minutos)

1. Abrir o site → tela de login com a animação de inicialização.
2. **Cadastro** com um e-mail real → chega o e-mail de confirmação → o link volta para `/auth/callback` e cai no painel. (Se cair em `localhost`, revise a etapa 4 e `NEXT_PUBLIC_SITE_URL`.)
3. **Recuperar senha** → o link abre `/redefinir-senha` no site publicado.
4. Criar personagem até o fim (com **foto**): a foto aparece na ficha e no cartão do painel.
5. Criar uma campanha, abrir o convite numa janela anônima com outra conta, entrar, vincular personagem, aceitar como Mestre.
6. No Escudo: criar um monstro no Homebrew, adicionar 2 cópias ao combate, iniciar, rolar um **confronto** e ver o resultado na central da campanha (outra conta) **ao vivo**.
7. Jogador ataca pela ficha escolhendo um alvo → o Mestre vê o confronto pendente e aplica o dano.
8. Rolagem privada do jogador: o Mestre vê, outro jogador não.

Se o “Ao vivo” ficar em “Reconectando…”, confira em *Supabase → Database → Publications → supabase_realtime* se as tabelas `combats`, `character_forms`, `roll_log`, `combat_confrontations` etc. estão marcadas.

## 6. Atualizar o site depois

Cada commit enviado para `main` gera uma nova publicação automaticamente; commits em outras branches geram **prévias** (endereço próprio) para testar antes. Quando uma versão trouxer migração nova, aplique-a no Supabase **antes** de fazer o merge em `main`. Para voltar atrás: *Vercel → Deployments → (versão anterior) → Promote to Production* (o banco não volta sozinho; as migrações do F.R.A.N.C.E são só aditivas, então versões anteriores do código continuam funcionando).

## Limites do plano gratuito (referência)

Supabase (gratuito) pausa projetos sem uso por um período e limita armazenamento e banda; a Vercel (Hobby) é para uso não comercial. Para um grupo de RPG costuma bastar; acompanhe os painéis de uso das duas plataformas.
