# F.R.A.N.C.E — Sistema visual

Redesign da interface (antes "Folkara") como atualização da Fase 2. **Nenhuma regra, tabela, rota de dados ou estrutura do banco foi alterada.**

## Onde fica cada coisa

| O quê | Arquivo |
|---|---|
| Paleta, fontes, sombras (tokens) | `src/app/globals.css` → bloco `@theme` |
| Classes de interface (`hud-panel`, `hud-tag`, `hud-card`, `field-input`, `chamfer`, `scanline`, `text-glow`) | `src/app/globals.css` → `@layer components` |
| Animação de inicialização | `src/components/brand/BootSequence.tsx` + CSS `.boot*` em `globals.css` |
| Logotipo (componentes e caminhos) | `src/components/brand/Logo.tsx` |
| Arquivos do logotipo | `public/brand/`, favicon em `src/app/icon.png` e `src/app/apple-icon.png` |
| Painel, indicador de status | `src/components/hud/Panel.tsx` |
| Barra de recurso (PV/PC) | `src/components/hud/ResourceBar.tsx` |
| Leitura de atributo/perícia (normal/bom/extremo) | `src/components/hud/StatReadout.tsx` |
| Tela de carregamento | `src/components/hud/LoadingScreen.tsx` |
| Aparição progressiva | `src/components/hud/Reveal.tsx` |
| Botão, campo, modal, avisos | `src/components/ui/*` |

Para trocar uma cor do site inteiro, edite só o token em `@theme`.

## Paleta

| Token | Cor | Uso |
|---|---|---|
| `void` | #050A12 | fundo principal |
| `panel` / `panel-2` / `panel-3` | #0B1626 / #102037 / #08111F | painéis |
| `line` / `line-strong` | #235377 / #2F7AAD | bordas |
| `fg` / `fg-dim` / `fg-muted` | #F1F8FF / #8BA8BF / #5F7D95 | texto |
| `primary` / `primary-deep` | #159BFF / #0B4F86 | azul principal |
| `holo` | #48C7FF | azul holográfico, PV |
| `cyan` / `cyan-dim` | #73E8FF / #3AA6C2 | ciano, PC |
| `ok` | #5EF0C0 | confirmações |
| `alert` | #FF7A90 | erros, exclusão, falha crítica |

`alert` é o único tom fora do azul: erros e ações destrutivas precisam se diferenciar. Ele sempre vem acompanhado de ícone ou texto (nunca só cor).

## Logotipo

O arquivo enviado não foi redesenhado. `npm run logo` (script `scripts/prepare-logo.py`) gera:

- `france-logo-original.png` — o arquivo como foi enviado;
- `france-logo.png` — fundo branco **externo** removido (só o branco ligado à borda da imagem; os brancos internos do desenho ficam);
- `france-logo-contorno*.png` — mesma remoção + o branco do próprio desenho mantido como contorno. É a versão usada sobre o fundo escuro, porque o preto do personagem sumiria sem esse contorno;
- `icon.png` (64 px) e `apple-icon.png` (180 px).

## Animação de inicialização

- ~2,9 s: linha horizontal → logotipo com anéis girando e linhas de energia → `F.R.A.N.C.E // INICIALIZANDO SISTEMA` + barra → `SISTEMA ONLINE` com brilho → a camada some.
- CSS puro: começa antes do JavaScript e a página real carrega por baixo (não bloqueia).
- Aparece uma vez por sessão do navegador, e não reaparece numa nova aba aberta em até 30 min.
- Não aparece com "reduzir animações" (perfil ou sistema operacional).
- Pular: botão, Esc, Enter ou espaço.

## Acessibilidade e desempenho

- Foco visível em ciano; navegação por teclado nas abas (setas).
- Status sempre com texto ("Ficha ativa", "Em criação", "baixo").
- Em celular, a varredura contínua e o anel secundário são desligados.
- "Reduzir animações" desliga transições, dados 3D e a inicialização.
