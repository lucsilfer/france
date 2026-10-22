# F.R.A.N.C.E (antigo Folkara) — Planejamento técnico e progresso

Documento vivo: requisitos, arquitetura e o que está pronto em cada fase. Atualizar ao fim de cada entrega.

## Arquitetura

```
Navegador (Next.js App Router, React 19, Tailwind 4, Motion)
   │  Server Components / Server Actions (validação Zod no servidor)
   ▼
Supabase
   ├─ Auth (senhas com hash, confirmação e recuperação por e-mail)
   ├─ PostgreSQL + RLS (toda permissão é checada no banco)
   ├─ Funções RPC (rolagens no servidor, gasto de PC idempotente, convites)
   └─ Realtime (fichas, combates, rolagens da campanha)

src/rules  ← motor de regras em TypeScript puro, sem dependências e sem React.
             Mesmo código roda no servidor e no navegador. Testado com node:test.
```

**Princípios**
- O motor de regras não conhece a interface. Atualizar o livro = editar `src/rules/data/*` e `src/rules/config.ts`.
- Rolagens que definem a ficha (atributos, evolução de nível) são feitas **no banco** com `gen_random_bytes` e gravadas; recarregar a página devolve a mesma rolagem pendente.
- Valores-base, bônus de classe, outros bônus e temporários são guardados separados; o valor final é sempre calculado.
- Operações sensíveis a clique duplo (gastar PC, rolar nível) usam chave única no banco.

## Módulos

| Módulo | Onde |
|---|---|
| Autenticação | `src/app/(auth)`, `src/app/auth/callback`, `src/lib/supabase`, `src/proxy.ts` |
| Personagens | lista em `painel/CharactersPanel.tsx` · criação `personagens/[id]/criar` · ficha `personagens/[id]` (abas em `[id]/panel/`) · Lenda `personagens/[id]/lenda` |
| Motor de regras | `src/rules` |
| Dados (rolagens) | `src/rules/dice.ts`, `src/rules/d100.ts`, `src/rules/combat.ts`, RPCs `roll_attribute_set`, `roll_simple_dice` |
| Inventário | `src/rules/catalog.ts`, `inventory-actions.ts`, tabelas `items`, `item_modifiers` (triggers de validação) |
| Poderes | `src/rules/powers.ts`, tabela `powers` (custo recalculado por `compute_power_cost`), RPCs `use_power`, `advance_effect`, `end_effect` |
| Níveis | RPC `set_character_level`, tabela `level_progressions` |
| Campanhas | `src/app/(app)/campanhas`, `src/app/(app)/convite`, RPCs de convite |
| Escudo do Mestre | tabelas `npcs`, `combats`, `combatants(+_public)`, `investigations`, `clues`, `reports`, `campaign_notes` · UI na Fase 4 |
| Homebrew | `src/app/(app)/homebrew`, tabela `homebrew` |

## Rotas

| Rota | Acesso | Fase |
|---|---|---|
| `/entrar`, `/cadastro`, `/recuperar-senha` | público | 1 ✅ |
| `/auth/callback` | link do e-mail | 1 ✅ |
| `/redefinir-senha` | sessão de recuperação | 1 ✅ |
| `/painel?aba=personagens\|campanhas\|homebrew` | logado | 1 ✅ |
| `/perfil` | logado | 1 ✅ |
| `/campanhas/nova` | logado | 1 ✅ |
| `/convite/[codigo]` | logado | 1 ✅ |
| `/homebrew/novo`, `/homebrew/[id]` | dono | 1 ✅ (formulário básico; editores de monstro/NPC na 5) |
| `/personagens/[id]/criar` (assistente) | dono | 2 ✅ |
| `/personagens/[id]` (ficha) | dono / Mestre autorizado | 2 ✅ · 3 ✅ (inventário, poderes, níveis, formas) |
| `/personagens/[id]/lenda` (assistente da Lenda) | dono (Artificial) | 3 ✅ |
| `/campanhas/[id]` e `/campanhas/[id]/escudo` | membros / Mestre | 4 |

## Banco de dados (resumo)

`profiles` · `characters` → `character_forms` (base / lenda) → `form_attributes`, `form_skills`, `attribute_rolls`, `level_progressions`, `pc_transactions` · `items` → `item_modifiers` · `powers` · `active_effects` · `roll_log` · `campaigns` → `campaign_members`, `campaign_invites`, `campaign_characters` (com `master_can_edit`) · `npcs` · `combats` → `combatants` · `investigations` → `investigation_secrets`, `clues` · `reports` · `campaign_notes` · `homebrew` · `audit_log`.

Inventário e poderes pendem do **personagem** (compartilhados entre as formas do Artificial); atributos, perícias, PV/PC e progressão pendem da **forma**.

Permissões (RLS): dono vê/edita tudo do seu personagem; Mestre vê fichas vinculadas à campanha e edita só com `master_can_edit = true` (autorização dada pelo dono ao vincular, revogável); ninguém troca o dono; jogadores não leem notas privadas, segredos de investigação, pistas não reveladas, combatentes ocultos, código do convite nem rolagens privadas do Mestre. Tudo coberto por `supabase/tests/01_rls_tests.sql`.

## Progresso

### Fase 1 — Fundação ✅
- [x] Leitura dos PDFs e extração de regras para `src/rules/data`
- [x] Motor de regras com testes (dados sem eval, d100, atributos, perícias, PV/PC, classes reversíveis, custo de poderes, limites por nível, progressão, ataque) — 44 testes
- [x] Documento de pendências de regras
- [x] Esquema completo do banco + RLS + funções + realtime — testado em PostgreSQL 16
- [x] Identidade visual (tokens, tipografia, componentes base, foco visível, reduzir animações)
- [x] Cadastro, login, recuperação de senha, nova senha, sair
- [x] Perfil (nome de usuário, nome de exibição, reduzir animações, trocar senha)
- [x] Painel com Personagens / Campanhas / Homebrew
- [x] Campanhas: criar, convite por link, prévia do convite, entrar como Jogador, novo link, excluir, sair
- [x] Homebrew: criar, editar, duplicar, excluir, pesquisar, filtrar
- [ ] Compilar o Next.js — o ambiente de desenvolvimento continuou sem acesso ao npm na Fase 2; rodar `npm install && npm run typecheck && npm run build`

### Ajustes pós-Fase 1 ✅
- [x] Limite de PC por habilidade = 15 + 3 × (nível − 1); dados extras pela tabela
- [x] Armas de fogo → perícia Arma de Fogo; outras de longa distância → Pontaria
- [x] Regras do banco geradas a partir do motor (`npm run rules:sql`), com teste de sincronia

### Fase 2 — Personagens ✅
- [x] "Criar personagem" cria um rascunho no Supabase e abre o assistente (`/personagens/[id]/criar`)
- [x] Barra de 6 etapas; voltar sem perder nada; etapa atual salva (`creation_step`) e retomada ao reabrir
- [x] Etapa 1: rolagem no servidor (3 × 3d6×5), dados 3D animados com os valores reais, maior destacado, descartados apagados; atribuição só a atributo vazio; rolagem pendente sobrevive a recarregar; banco impede editar atributo-base no rascunho
- [x] Etapa 2: origens em lista vertical, expansão por hover/toque, traços por tipo, Caminho do Prodígio obrigatório
- [x] Etapa 3: classes em grade com benefícios, equipamento, bônus e dados de evolução; prévia ao vivo; troca de classe sem acumular bônus
- [x] Etapa 4: distribuição de perícias (4 / 150 / 75; Detalhista 200 / 95), bônus de classe à parte, salvamento automático
- [x] Etapa 5: identidade e história com salvamento automático
- [x] Etapa 6: revisão completa; finalização revalidada no servidor pelo motor; PV/PC começam cheios
- [x] Ficha digital: registro, nível, barras de PV/PC com ajuste ±1 atômico, atributos e perícias (normal/bom/extremo) com edição por lápis (base, outros, temporário), abas Habilidades de Classe (com bloqueio por nível) e Descrição (salvamento automático)
- [x] Clique em atributo/perícia rola d100 no servidor, mostra classificação e grava no histórico (`roll_log`) — adiantado da Fase 3
- [x] Mestre autorizado edita a ficha; sem autorização, ficha somente leitura

### Redesign F.R.A.N.C.E (atualização da Fase 2) ✅
- [x] Novo nome, paleta holográfica centralizada em tokens, tipografia técnica
- [x] Logotipo oficial tratado (transparente, contorno para fundo escuro, favicon)
- [x] Animação de inicialização (CSS puro, 1×/sessão, pular, respeita reduzir animações)
- [x] Login dividido (identidade + painel de acesso), central de controle com módulos, cartões com brilho
- [x] Criação de personagem, ficha, barras de PV/PC, rolagem holográfica e modo de edição no novo visual
- [x] Componentes reutilizáveis em `src/components/hud` e `src/components/brand`
- [ ] Conferir visualmente em navegador (o ambiente de desenvolvimento não tem navegador nem npm)

### Fase 3 — Sistemas avançados de personagem ✅
- [x] **Correção do limite de perícia**: 75 é o valor TOTAL (base + pontos + bônus de classe/outros); Detalhista total 95 com 200 pontos; pontos automáticos de classe contam no limite. Motor + trigger no banco + testes. Fichas antigas acima do limite mostram alerta e só podem ser reduzidas
- [x] Cinco abas funcionais: Inventário Rápido · Inventário · Habilidades de Classe · Poderes Próprios · Descrição
- [x] Inventário: dinheiro com salvamento automático; "+ Adicionar item" com Catálogo oficial (busca + filtro), Biblioteca Homebrew e Criar item; cartões compactos expansíveis com editar/remover; ★ envia ao Inventário Rápido
- [x] Modificadores de arma: só os compatíveis com a categoria; efeitos aplicados automaticamente no ataque, condições exibidas; remover; limites validados no banco
- [x] Item personalizado: tipos de efeito Dano/Cura/Condição/Utilidade/Personalizado, configuração de arma (tipo de ataque, dano, perícia, categorias), parser de dados seguro (sem eval). Vai para a ficha **e** para a biblioteca; cópias editadas separadamente
- [x] Ataque pelo Inventário Rápido: d100 com a perícia do tipo de arma (Luta / Pontaria / Arma de Fogo), opções situacionais, extremo ×1,5, 1 natural ×2 (não acumulam), falha sem dano, falha crítica com aviso; dados e dano final exibidos e gravados
- [x] Criador de poderes com "CUSTO: X PC" ao vivo, tabelas do livro, área, turnos contínuos, limite de PC e de dados extras por nível (bloqueia e mostra em vermelho com o máximo), redução do Amaldiçoado; custo recalculado pelo banco
- [x] Uso de poder: confere e desconta PC uma única vez (idempotente), sem teste de acerto, rola só os dados de efeito, grava no histórico; efeito contínuo com estado ativo, turnos restantes, PC por turno e botão encerrar
- [x] Aba de habilidades com desbloqueios por nível (Prodígio, Receptáculo, Muto, Remanescente, Amaldiçoado)
- [x] Níveis 1–20: seletor, overlay animado com os dados da classe; Prodígio 1d12+2 PV e sem PC; cada nível rolado uma vez e guardado; saltos resolvem nível a nível; descer suspende sem apagar
- [x] Ficha secundária do Artificial: "Alternar forma — Lenda", assistente na primeira vez (atributos e perícias, sem origem/classe), atributos/perícias/PV/PC/nome/descrição próprios, inventário e poderes compartilhados, transição holográfica
- [x] Descrição física independente por forma
- [x] Histórico de rolagens com testes, ataques, poderes e turnos
- [ ] Conferir em navegador e compilar com `npm install && npm run build` (o ambiente de desenvolvimento não tem npm nem navegador)

### Atualização 3.5 ✅
- [x] PV = (FOR + CON) ÷ 3 no motor, banco e dados existentes (com registro)
- [x] Vagas de habilidades (2 + 1 por nível par), indicador, bloqueio de evolução no front e no banco; exceções Muto/Elo; Prodígio por Caminho
- [x] Equipamento inicial das classes: escolhas na criação, itens reais ao finalizar, resgate sem duplicar
- [x] Prodígio: sem PC, sem limites, abas Técnicas de Arsenal / Aparatos Tecnológicos / Inventário Místico
- [x] Velocidade das rolagens no perfil, janelas empilhadas sem barras de rolagem
- [x] Atualização otimista, menos consultas, abas mantidas montadas
- [x] Troca instantânea de forma do Artificial e tema corrompido da Lenda
- [ ] Conferir em navegador e `npm run build` (sem npm/navegador no ambiente de desenvolvimento)

### Fase 4 — Campanhas
- [ ] Vínculo de personagem com aviso de permissão
- [ ] Escudo do Mestre: Agentes, Combates, Investigação, Relatórios, Dados, Anotações
- [ ] Tempo real

### Fase 5 — Homebrew
- [ ] Editores de monstro e NPC; adicionar modelos a fichas (cópia independente) e a combates

### Fase 6 — Finalização
- [ ] Revisão visual, testes de ponta a ponta, desempenho, publicação
