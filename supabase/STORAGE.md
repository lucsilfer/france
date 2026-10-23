# Supabase Storage — configuração do F.R.A.N.C.E (Fase 5)

Tudo é criado pela migração `migrations/20261026000100_fase5_homebrew.sql` (seção 7). Não é preciso clicar em nada no painel; este arquivo documenta o que ela faz e como conferir.

## Bucket

| Item | Valor |
|---|---|
| Nome / id | `france-media` |
| Público | **não** (privado — só links assinados) |
| Tamanho máximo | 2 MB por arquivo |
| Tipos aceitos | `image/webp`, `image/png`, `image/jpeg` |

As imagens são recortadas e comprimidas **no navegador** (WebP, 600×750 para retratos e 640×640 para imagens quadradas) antes do envio. O banco guarda **só o caminho** do arquivo — nada de base64.

## Pastas

| Caminho | O que é | Quem envia/troca/apaga | Quem lê |
|---|---|---|---|
| `characters/<personagem>/<arquivo>` | Foto de uma forma do personagem (humana ou Lenda, cada uma com seu arquivo) | só o **dono** do personagem | quem pode ver a ficha: o dono e o Mestre de campanha com **vínculo aceito** |
| `homebrew/<usuário>/<arquivo>` | Imagem de um conteúdo Homebrew (monstro, NPC, arma, item…) | só o **autor** | o autor; jogadores de campanha em que o conteúdo foi **disponibilizado**; jogadores quando a imagem está num NPC **visível** ou num combatente **não oculto**; quem vê a ficha onde há um item copiado desse modelo |
| `npcs/<campanha>/<arquivo>` | Imagem de NPC/monstro criado direto na campanha | só o **Mestre** da campanha | o Mestre; jogadores, se o NPC estiver **visível** ou o combatente **não oculto** |

Nomes de arquivo: `[A-Za-z0-9_-]{1,80}.(webp|png|jpg|jpeg)`, sem subpastas. Qualquer outro caminho é recusado.

## Políticas (em `storage.objects`)

- `france_media_read` — `select` quando `public.can_read_media(name)`.
- `france_media_insert` / `france_media_update` / `france_media_delete` — quando `public.can_write_media(name)`.

As duas funções são `security definer` e usam as mesmas regras de permissão das tabelas (`can_view_character`, `owns_character`, `is_campaign_master`, compartilhamentos). Os links assinados são gerados com a sessão de quem está vendo a página — se a política não deixa ler, o link não é gerado.

Proteções extras no banco:
- `character_forms.portrait_path` só aceita arquivo da pasta do próprio personagem e só o dono pode mudar.
- `homebrew.image_path` só aceita arquivo da pasta do autor.
- `npcs.image_path` e `combatants.image_path` só aceitam a pasta da campanha ou a do Mestre.
- `items.image_path` só aceita a imagem de um modelo que quem grava consegue ler (evita "apontar" para a imagem privada de outra pessoa para ganhar acesso).

## Conferir no painel do Supabase

1. *Storage → Buckets*: `france-media` aparece como **Private**.
2. *Storage → Policies* (ou *Database → Policies*, tabela `storage.objects`): as quatro políticas `france_media_*`.
3. Nenhuma chave `service_role` é usada pelo app — envio e leitura usam a sessão do usuário.
