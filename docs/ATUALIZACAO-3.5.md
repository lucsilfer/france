# F.R.A.N.C.E — Atualização 3.5

Correção de regras, desempenho, equipamento inicial, vagas de habilidades, Prodígios e tema corrompido da Lenda. Atualização incremental sobre a Fase 3: mesmo banco Supabase, mesmos IDs, nada apagado.

Como instalar/atualizar: [`README.md`](../README.md#atualizar-uma-instalação-existente-mesmo-supabase). Migrações novas:

1. `supabase/migrations/20261024000000_rules_sync_3_5.sql` — gerada a partir do motor (`npm run rules:sql`): regras 3.5, `form_pv_max`, `ability_granted`, `ability_status`.
2. `supabase/migrations/20261024000100_atualizacao_3_5.sql` — colunas novas, validações, uso de poderes, bloqueio de evolução e ajuste seguro dos dados existentes.

## O que mudou

### 1. Fórmula de PV corrigida — (FOR + CON) ÷ 3
- Motor (`config.ts › pvFormula: "sum_div3"`): soma antes da divisão, arredondada para baixo. FOR 60 + CON 45 = **35**.
- Bônus de atributo da classe entram antes da divisão (Brawler +4 FOR); bônus de PV da classe (Tank +20), ganhos de nível e "bônus no máximo" entram depois.
- Vale para criação, ficha, edição de atributos, evolução e as duas formas do Artificial.
- Banco: `form_pv_max(forma)` faz a mesma conta. `adjust_form_resource` passa a limitar o PV pelo máximo calculado pelo próprio banco (não confia no valor enviado). `set_character_level` e a edição de atributos também mantêm o PV atual dentro do máximo.
- Personagens existentes: a rotina `fix_pv_after_formula_change()` (executada pela migração, reaplicável) reduz só o **PV atual** que passou do novo máximo e registra cada caso em `pv_formula_fix_log`. Registros de evolução não são tocados.

### 2. Vagas de habilidades e bloqueio de evolução
- Regra geral: **2 no nível 1, +1 a cada nível par** (nível 20 = 12). Disponíveis = adquiridas − criadas. Motor: `src/rules/abilities.ts`; banco: `ability_granted` / `ability_status`.
- Indicador "N HABILIDADES DISPONÍVEIS" acima das abas e contador na aba de poderes; clicar abre a aba. Sem vagas, nada aparece.
- Criar consome uma vaga (bloqueado no navegador, na ação do servidor e no trigger `validate_power`). Editar não consome. Excluir (com confirmação) devolve.
- Com habilidades pendentes, subir de nível fica bloqueado: o seletor desabilita os níveis acima do permitido e aparece **EVOLUÇÃO BLOQUEADA** com o botão "Abrir criador". Saltos são validados nível a nível. O banco (`set_character_level`) recusa requisições diretas. Descer nunca é bloqueado e não apaga poderes.
- Exceções: **Muto** não usa o sistema (sem vagas, pendências ou bloqueio — segue a Mutação Adaptativa); **Elo** cria quando quiser, sem limite e sem bloqueio.
- Prodígio segue o Caminho quando o livro é diferente da regra geral (ver decisões 50–52).
- Personagens antigos: todos os poderes existentes contam como habilidades criadas; nada é apagado. Quem tem mais poderes que vagas fica com 0 disponíveis.

### 3. Equipamento inicial das classes
- Kits estruturados em `src/rules/data/startingKits.ts`, com as restrições do livro (refinada corpo a corpo, simples, "que não seja de fogo", arma de fogo, arma de longa distância — com a exceção do Prodígio para o Demolidor —, item de perícia fora da seção Lutar, armaduras, kits, talismã, mira, roupa de furtividade, 5 granadas).
- Na etapa Classe da criação: os itens aparecem e as escolhas são obrigatórias para avançar; ficam salvas em `characters.starting_kit`. Trocar de classe apaga as escolhas (no servidor e por trigger no banco).
- Ao finalizar, os itens entram no inventário como **itens reais** (`items`, `source_kind = catalog`), cada um marcado com `kit_ref = kit:<classe>:<vaga>`. A restrição única `(character_id, kit_ref)` impede duplicar a mesma vaga, mesmo se a finalização for repetida.
- Personagens já criados: o Inventário mostra "Equipamento inicial da classe: N pendente(s) → Resgatar". Só as vagas ainda não recebidas são entregues; itens fixos que o personagem já tem pelo catálogo são marcados como recebidos sem criar outra cópia. O inventário atual não é sobrescrito.

### 4. Prodígios
- Sem barra de PC (só PV), sem custo de PC ao usar, sem mensagens de PC insuficiente e sem rolagem de PC na evolução (1d12+2 PV por nível, como antes).
- Criador sem limite de PC por habilidade e sem limite de dados extras; mostra "SEM CUSTO DE PC". Pode registrar técnica/aparato/objeto só com texto (sem efeito de dados). Banco: `compute_power_cost` com o mesmo comportamento (paridade testada); poderes antigos de Prodígios passam a custar 0.
- Efeitos contínuos do Prodígio continuam tendo estado ativo e turnos (o banco agora decide pelo tipo de efeito, não pelo custo).
- Aba renomeada pelo Caminho, com ícone e textos próprios: **TÉCNICAS DE ARSENAL** (com a lista de técnicas do livro para preencher), **APARATOS TECNOLÓGICOS**, **INVENTÁRIO MÍSTICO**. Criar, editar e excluir continuam iguais.

### 5. Rolagens rápidas e notificações
- Nova configuração no Perfil: **Instantânea**, **Rápida (padrão, ~0,3 s)**, **Normal (~0,8 s)** (`profiles.roll_speed`). Com "Reduzir animações", é sempre instantânea.
- A janela de resultado abre no clique ("Rolando…") e se preenche quando o servidor responde; o número aparece embaralhado durante a animação e o valor real (sorteado no servidor antes) aparece ao terminar. Cálculos e classificações do d100 não mudaram.
- Várias rolagens seguidas: até 3 janelas empilhadas; a mais nova completa e as anteriores em uma linha com nome e hora (não há como confundir). Fecham sozinhas depois de alguns segundos; o histórico guarda tudo.
- Armas sem situações para marcar e poderes sem opções são usados com um clique.
- Janelas sem barras de rolagem: largura `min(100vw − 1,5 rem, 22 rem)`, textos quebram dentro das bordas, números nunca são cortados, botão de fechar sempre visível. Só a lista de histórico tem rolagem vertical (é uma lista).

### 6. Desempenho geral
- As ações da ficha não recarregam mais a página inteira: inventário, modificadores, poderes, favoritos, efeitos e dinheiro são atualizados na hora (atualização otimista) e desfeitos com aviso se o banco recusar.
- Autenticação e perfil memorizados por requisição (antes cada ação consultava a autenticação 3–4 vezes); carregamento da ficha em uma única rodada de consultas paralelas; operações simples (favoritar, remover, renomear, alternar forma, dinheiro) usam um contexto leve que confia no RLS.
- Abas já abertas continuam montadas (voltar é instantâneo e não perde o que estava aberto).
- Botões ±1 de PV/PC não travam: os cliques são somados e enviados juntos.

### 7. Artificial — troca instantânea e tema corrompido
- As duas formas já vêm carregadas; alternar não consulta o banco nem recarrega a página. A gravação da forma ativa é feita em segundo plano, em fila (cliques rápidos nunca se sobrepõem); se falhar, aparece um aviso e a forma volta ao último estado salvo.
- Cada alteração usa o id da forma em que foi feita (PV/PC continuam independentes; inventário e poderes, compartilhados).
- Forma Lenda: tema **corrompido** só na ficha do Artificial — fundo preto profundo, painéis escuros, linhas vermelho-escuras e roxas, interferência discreta e pequenos glitches. Transição de ~0,42 s: escurece, faixa de interferência percorre a tela, o conteúdo troca e as cores passam gradualmente. Sem flashes. Com "Reduzir animações" a troca é direta. Ao voltar, o tema azul retorna.

## Testes executados

Ambiente: Node 22 (`node:test`) e PostgreSQL 16 local com simulação de `auth.uid()`. O registro do npm e navegadores não estão disponíveis neste ambiente.

| Resultado | Conjunto |
|---|---|
| ✅ 109/109 | Motor (`npm test`), incluindo `atualizacao35.test.ts` (26 testes novos) e sincronia motor ↔ SQL gerado |
| ✅ | `01_rls_tests.sql` — permissões (RLS) |
| ✅ | `02_phase2_tests.sql` — Fase 2 |
| ✅ | `03_fase3_tests.sql` — Fase 3 (ajustado: subir de nível agora exige as habilidades do nível) |
| ✅ 1849 casos | `04_power_parity_tests.sql` — custo de poder idêntico no motor e no banco (inclui Prodígio e registro sem efeito) |
| ✅ | `05_atualizacao35_tests.sql` — PV, ajuste de dados, vagas, bloqueio, Muto/Elo, Prodígio, kit sem duplicar, troca de classe, velocidade |
| ✅ | **Atualização de um banco da Fase 3 com dados**: migrações 3.5 aplicadas sobre personagens existentes — PV 115 → 55 registrado no log, poder de Prodígio 6 → 0 PC, personagem nível 3 com 1 poder mantido (nada apagado), reaplicar não muda nada |
| ✅ | TypeScript do projeto (com declarações simplificadas das bibliotecas externas, porque o npm está bloqueado aqui) |

### Cobertura dos testes pedidos

| Área | Verificação | Como |
|---|---|---|
| PV | (FOR + CON) ÷ 3; bônus de classe; ganhos de nível preservados; ajuste dos existentes | motor + banco + simulação de atualização |
| Habilidades | 2 no nível 1; +1 por nível par; pendentes; bloqueio (incl. salto); Muto e Elo; preservação | motor + banco |
| Equipamentos | entrega, escolhas e restrições, sem duplicar, salvo como item real, troca de classe | motor + banco |
| Prodígios | sem consumo de PC, sem limites, registro sem efeito, nomes das abas, progressão por Caminho, 1d12+2 sem PC | motor + banco |
| Regressão | login/cadastro/campanhas/homebrew (RLS), criação, atributos, perícias (limite 75/95 mantido), inventário, modificadores, poderes, evolução, Artificial | suítes 01–04 |
| Desempenho / interface | rolagens rápidas, troca instantânea, sem consultas extras, sem perda em trocas repetidas, tema corrompido, notificações sem rolagem | **revisão de código — não testado em navegador** |

## Problemas não resolvidos / a conferir

- **Não foi possível rodar `npm install`, `next build` nem abrir o site em um navegador** neste ambiente. Antes de publicar: `npm install && npm run typecheck && npm run build` e conferir as telas (tema corrompido, transição, notificações em celular, overlay de nível).
- Tempo de resposta real depende do Supabase/hospedagem; as otimizações reduzem consultas e recargas, mas não foram medidas em produção.
- A troca de cores gradual usa `@property` (Chrome/Edge, Safari 16.4+, Firefox 128+). Em navegadores antigos o tema troca de uma vez, sem prejuízo.
- Decisões que precisam de confirmação do autor estão em [`REGRAS-E-PENDENCIAS.md`](REGRAS-E-PENDENCIAS.md), itens 49–58 (em especial: quantidade de técnicas do Arsenal no nível 1, aparatos da Engrenagem, "arma leve" do Rato).
- Personagens antigos que já passaram do nível sem criar habilidades não são rebaixados; só não sobem até criar as pendentes.
