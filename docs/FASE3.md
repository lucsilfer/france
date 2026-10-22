# F.R.A.N.C.E — Fase 3: sistemas avançados de personagem

Atualização incremental sobre o redesign F.R.A.N.C.E (Fase 2). Mesmo banco, mesmos dados, mesmo visual, logotipo e animação de inicialização.

## Como atualizar

Veja o passo a passo em [`README.md › Atualizar uma instalação existente`](../README.md#atualizar-uma-instalação-existente-mesmo-supabase). Resumo: aplique **apenas** as duas migrações novas, nesta ordem:

1. `supabase/migrations/20261023000000_rules_sync_fase3.sql`
2. `supabase/migrations/20261023000100_fase3_sistemas.sql`

Elas não recriam tabelas nem apagam dados: usam `create or replace`, `add column if not exists`, `drop trigger/policy if exists`. A antiga `20261022000000_rules_sync.sql` continua no projeto, congelada, porque já foi aplicada.

## O que foi implementado

| # | Funcionalidade | Onde |
|---|---|---|
| 1 | **Limite de perícia corrigido**: 75 é o valor total da perícia (base + pontos + bônus de classe e outros permanentes). Detalhista: total 95 e 200 pontos. Pontos automáticos de classe contam no limite. A criação mostra, por perícia, base, bônus de classe, pontos, total/limite e quantos pontos ainda cabem | `src/rules/character.ts`, `criar/StepSkills.tsx`, trigger `validate_form_skill` |
| 2 | Personagens antigos acima do limite: nada é apagado; a ficha marca "acima do limite" e mostra o alerta; reduzir é permitido, aumentar não (no motor e no banco) | `SkillsSection.tsx`, `checkSkillEdit` |
| 3 | Cinco abas funcionais na ficha: Inventário Rápido, Inventário, Habilidades de Classe, Poderes Próprios, Descrição (a última aba usada é lembrada no navegador) | `[id]/RightPanel.tsx`, `[id]/panel/*` |
| 4 | Dinheiro com salvamento automático | `InventoryTab.tsx › MoneyField` |
| 5 | "+ Adicionar item": Catálogo oficial (busca + filtro por tipo), Biblioteca Homebrew e Criar item | `InventoryTab.tsx › AddItemModal` |
| 6 | Cartões de item compactos e expansíveis com editar, remover e ★ para o Inventário Rápido | `InventoryTab.tsx › ItemCard` |
| 7 | Modificadores de arma: só aparecem os compatíveis com as categorias da arma; efeitos numéricos aplicados no ataque; condições exibidas; remover; máximo de 2 permanentes (1 temporário só Prodígio Arsenal) validado no banco | `equipment.ts`, `combat.ts`, trigger `validate_item_modifier` |
| 8 | Item personalizado: Dano/Cura/Condição/Utilidade/Personalizado, configuração de arma (tipo de ataque, tipo de dano, perícia, categorias), dados validados por parser próprio (sem `eval`) no navegador, no servidor e no banco. Vai para a ficha **e** para a biblioteca; a cópia na ficha e o modelo são editados separadamente (editar o modelo na biblioteca preserva os campos de arma) | `ItemForm.tsx`, `createCustomItem`, `dice.ts`, `is_valid_dice` |
| 9 | Ataque: d100 com Luta (corpo a corpo), Pontaria (distância) ou Arma de Fogo, ou a perícia definida no item; opções situacionais (modificadores, Esotérico, Rato, Atirador); extremo ×1,5 e 1 natural ×2 sem acumular; falha não causa dano; falha crítica mostra o aviso; dados, multiplicador e dano final no resultado e no histórico | `actions-ui.tsx › AttackDialog`, `attackWithItem`, `RollTray.tsx` |
| 10 | Criador de poderes com "CUSTO: X PC" ao vivo, tabelas do Capítulo V, área, cura contínua/condições/melhorias por turno, limite de PC e de dados extras do nível (bloqueia, fica vermelho e mostra o máximo), redução do Amaldiçoado | `PowersTab.tsx › PowerCreator`, `powers.ts`, `compute_power_cost` |
| 11 | Uso de poder: confere PC, desconta uma única vez por uso (idempotente), sem teste de acerto, rola só os dados de efeito no servidor e grava. Contínuo: fica ativo, mostra turnos restantes e PC por turno, "Próximo turno" e "Encerrar" | `UsePowerButton`, `ActiveEffects`, `use_power`, `advance_effect`, `end_effect` |
| 12 | Aba de habilidades com desbloqueios por nível | `unlocks.ts`, `RightPanel.tsx › AbilitiesTab` |
| 13 | Nível 1–20: seletor, overlay animado com os dados holográficos; dados da classe; Prodígio 1d12+2 PV e sem PC; cada nível rolado uma vez e guardado; saltos resolvem nível a nível; descer suspende os ganhos sem apagar ("registro recuperado" ao subir de novo) | `LevelControl.tsx`, `set_character_level` |
| 14 | Artificial: "ALTERNAR FORMA — LENDA"; na primeira vez abre o assistente (atributos e perícias, sem origem e classe); atributos, perícias, PV, PC, nome e descrição próprios; inventário, poderes e Inventário Rápido compartilhados; transição holográfica ao alternar | `FormSwitcher.tsx`, `[id]/lenda/*`, `create_lenda_form`, `complete_lenda_form` |
| 15 | Descrição física independente por forma | `RightPanel.tsx › DescriptionTab` |
| 16 | Histórico de rolagens com testes, ataques, poderes e turnos | `RollTray.tsx` |

Segurança: todas as validações de custo, limite, modificador e gasto de PC também estão no banco. Efeitos ativos e evolução de nível só mudam por funções `security definer` que checam `can_edit_character` (dono, ou Mestre autorizado da campanha). Nenhuma chave secreta no projeto.

## Testes executados

Ambiente: Node 22 (`node:test`, sem dependências) e PostgreSQL 16 local com um *shim* de `auth.uid()`. Comandos: `npm test` e `npm run test:db`.

| Resultado | Conjunto |
|---|---|
| ✅ 83/83 | Motor de regras (`npm test`), incluindo `fase3.test.ts` e o teste de sincronia motor ↔ SQL gerado |
| ✅ | `01_rls_tests.sql` — TODOS OS TESTES DE RLS PASSARAM |
| ✅ | `02_phase2_tests.sql` — TESTES DA FASE 2 PASSARAM |
| ✅ | `03_fase3_tests.sql` — TESTES DA FASE 3 PASSARAM |
| ✅ 1523 casos | `04_power_parity_tests.sql` — custo de poder idêntico no motor e no banco |
| ✅ | TypeScript do projeto todo, checado com declarações simplificadas das bibliotecas externas (o npm está bloqueado no ambiente) |

### Os 16 testes da Fase 3

| # | Teste | Motor | Banco |
|---|---|---|---|
| 1 | Perícia com base 20 aceita no máximo 55 pontos (total 75); 56 é recusado | ✅ | ✅ |
| 2 | Bônus de classe conta no limite (Atirador, Brawler) | ✅ | ✅ |
| 3 | Detalhista: total 95 e 200 pontos; forma Lenda não herda | ✅ | ✅ |
| 4 | Bônus temporário não conta no limite | ✅ | — |
| 5 | Ficha antiga acima do limite: reduzir permitido, aumentar recusado | ✅ | ✅ |
| 6 | Modificador incompatível recusado; terceiro permanente recusado; temporário só Arsenal | ✅ | ✅ |
| 7 | Expressão de dados inválida recusada no item | ✅ | ✅ |
| 8 | Perícia do ataque por tipo de arma (Luta / Pontaria / Arma de Fogo / definida no item) | ✅ | — |
| 9 | Extremo ×1,5; crítico ×2 sem somar o ×1,5; bom/normal sem multiplicador | ✅ | — |
| 10 | Falha e falha crítica não causam dano | ✅ | — |
| 11 | Custo do poder calculado pelo banco (valor enviado é ignorado); Amaldiçoado paga metade arredondada para cima | ✅ | ✅ |
| 12 | Limite de PC e de dados extras por nível recusam o poder | ✅ | ✅ |
| 13 | Uso desconta PC uma vez; clique repetido não desconta de novo; PC insuficiente recusado | — | ✅ |
| 14 | Contínuo: cobra o inicial, cobra cada turno uma vez, encerra após os turnos, efeito encerrado não cobra, cliente não edita efeitos | — | ✅ |
| 15 | Nível 1→5 resolve 2..5; descer preserva; subir de novo não rola; Prodígio 1d12+2 sem PC; estranho não muda nível; cliente não grava evolução | — | ✅ |
| 16 | Lenda: assistente exige atributos, perícias e nome; recursos próprios; inventário e poderes compartilhados; forma só ativa depois de concluída | ✅ | ✅ |

## O que não foi testado aqui

- `npm install`, `next build` e execução no navegador: o ambiente de desenvolvimento não tem acesso ao registro do npm nem a um navegador. Rode `npm install && npm run typecheck && npm run build` antes de publicar e confira as telas.
- Supabase real (Auth/RLS em produção): os testes de banco rodam num PostgreSQL local com simulação de `auth.uid()`.

## Pendências

- Conferência visual em navegador (abas, modais, overlay de nível, transição de forma) e build do Next.js.
- Confirmar com o autor os pontos marcados em `docs/REGRAS-E-PENDENCIAS.md` (decisões 36–48 desta fase, além das anteriores).
- Não automatizado por depender do Mestre: talismã de energia, vantagem do Demolidor com arremessáveis, efeitos narrativos de origem, condições dos modificadores (exibidas para o Mestre aplicar).
- Fase 4: vínculo com campanha, Escudo do Mestre e tempo real.
