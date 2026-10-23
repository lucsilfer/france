# F.R.A.N.C.E — Versão 6.1 (Fase 6: finalização + correção do combate)

> **6.1 (correção urgente):** no confronto de rolagens opostas **vence o MENOR d100** (a 6.0 dizia maior). Corrigido no motor, no banco, na ficha, no Escudo, nas granadas e nos testes. Desempates, classificação (menor é melhor) e multiplicadores não mudaram.

Incremental sobre a Fase 5: mesmo projeto Supabase, nenhum dado apagado. Migrações novas (nesta ordem):

1. `supabase/migrations/20261027000000_rules_sync_v6.sql` — gerada pelo motor (`npm run rules:sql`): limiares do d100, multiplicadores, perícias de ataque, configuração do confronto e granadas.
2. `supabase/migrations/20261027000100_v6_finalizacao.sql` — confrontos rolados no banco, granadas em combate, dano contínuo, kit do Demolidor por tipo, fotos no grupo da campanha.
3. `supabase/migrations/20261028000000_rules_sync_v6_1.sql` — **6.1**: regras do motor com "menor d100 vence".
4. `supabase/migrations/20261028000100_v6_1_menor_vence.sql` — **6.1**: função do confronto com o novo padrão e uma conferência automática (falha com mensagem clara se a 3 não foi aplicada).

Quem ainda não aplicou nada da 6.0 roda as quatro, em ordem. Quem já aplicou a 1 e a 2 roda só a 3 e a 4. Confrontos já registrados no histórico não são alterados.

Guias: [publicar na Vercel](DEPLOY-VERCEL.md) · [GitHub](GITHUB.md) · [README](../README.md).

## 1. Combate por rolagens opostas

- Atacante e defensor rolam **1d100**; **vence o menor** (`RULES_CONFIG.opposed.winner = "lower"`). O 1 vence qualquer outro resultado (contra outro 1, vale o desempate); o 100 perde para qualquer outro. Vale para jogador × jogador, jogador × NPC/monstro, NPC/monstro × jogador e NPC/monstro × NPC/monstro.
- **Resultado do confronto** e **qualidade da rolagem** são separados: a qualidade é a classificação normal do d100 do atacante (menor é melhor) contra a perícia de ataque — Luta (corpo a corpo), Pontaria (distância), Arma de Fogo (armas de fogo). A reação do defensor é Luta (bloquear) ou Reflexo (esquivar); padrão: Luta contra corpo a corpo, Reflexo contra ataques à distância.
- Dano só quando o ataque vence: normal e bom = dano padrão; extremo ×1,5; resultado 1 ×2; não acumulam. Vencer com qualidade “falha” (ex.: 70 contra perícia 50, mas o defensor tirou 90) causa dano padrão.
- **Desempate**: jogador × NPC/monstro → o jogador vence (atacando ou defendendo). PvP e NPC × NPC → maior valor na perícia correspondente (perícia de ataque × perícia de reação, com bônus permanentes e temporários); empate também na perícia → nova rolagem oposta automática.
- **Onde os dados são rolados**: no banco (`public.combat_confront`). O valor da perícia do personagem é calculado no banco a partir da ficha (`form_skill_value`), igual ao motor (2.086 casos de paridade). Ninguém escolhe o número nem grava um confronto direto.
- **Telas**:
  - **Ficha**: em combate, o diálogo de ataque pede o alvo e a reação; o resultado aparece na bandeja de rolagens (animação rápida) com atacante, defensor, os dois d100, perícias, vencedor, qualidade e dano. O dano de ataque de jogador fica **aguardando o Mestre**.
  - **Escudo do Mestre**: ataques de monstros/NPCs viram confrontos contra o alvo escolhido (aplicar dano automaticamente opcional); “Conduzir confronto” para agentes (armas da ficha) e ataques livres de qualquer participante; lista de confrontos com **Aplicar** para os pendentes.
  - **Central da campanha**: os jogadores veem os últimos confrontos públicos ao vivo.
- Tudo vai para o histórico do combate e para a tabela `combat_confrontations` (confrontos com alvo oculto não aparecem para os jogadores).

## 2. Granadas

| Granada | Dano | Efeito no sistema |
|---|---|---|
| Fragmentação | 3d8 | área pequena |
| Incendiária | 2d6 | condição **Em chamas**: +1d6 no fim de cada turno do alvo, por 2 turnos (rolado no banco) |
| Concussão | 2d6 | **Atordoado** 1 turno — o Mestre decide e aplica (o livro diz “pode deixar”) |
| Explosiva pesada | 5d8 | área média; **rara** (não entra no kit inicial) |
| Fumaça | — | **Cobertura de fumaça** por 3 turnos em quem lançou |

- Itens independentes no catálogo oficial: adicionar, remover, quantidade, efeitos, Inventário Rápido.
- **Demolidor**: cinco granadas à escolha, combinando tipos (contador na criação e no resgate do kit). Uma linha por tipo com a quantidade; reabrir/atualizar a ficha não duplica (Demolidores que já receberam o kit antigo também não recebem de novo).
- **Em combate**: *Lançar* → escolher os alvos da área → para cada alvo, confronto **Pontaria × Reflexo** rolado no banco; desconta 1 unidade uma única vez por lançamento; condições ficam no confronto e entram quando o dano é aplicado. Fora de combate: *Usar* rola o dano e desconta.

## 3. Ficha e interface

- Abas do painel direito quebram em linhas (sem barra horizontal); em telas pequenas viram um **menu compacto**. Nomes: Inventário Rápido, Inventário, Habilidades de Classe, Poderes Próprios (Técnicas de Arsenal / Aparatos Tecnológicos / Inventário Místico para Prodígios) e Descrição.
- Conteúdo com espaçamento menor, textos que quebram linha em vez de vazar, colunas que não forçam largura; área útil maior em telas largas.
- Janelas de resultado sem rolagem interna (o histórico continua rolável por ser uma lista).
- Fotos no grupo da campanha (forma ativa; moldura corrompida na Lenda).

## 4. Revisão de regras (sem mudanças nas já corrigidas)

Conferidas por testes: 8 atributos e rolagem de criação; normal/bom/extremo; bônus de classe; perícias com limite total 75 (Detalhista 95, temporários fora do limite como decidido na Fase 3); PV = (FOR + CON) ÷ 3; PC = VIG ÷ 3 (Prodígio sem PC); progressão 1–20 com rolagens salvas; habilidades pendentes (2 + 1 por nível par; Muto e Elo como exceções); Técnicas de Arsenal; Artificial com fichas, recursos e fotos independentes e inventário/poderes compartilhados.

## 5. Desempenho

- Ficha abre sem esperar o combate: o contexto de combate carrega em segundo plano.
- Abas mantidas montadas (troca instantânea); atualizações otimistas com recuperação; troca de forma serializada.
- Imagens: recorte no aparelho (WebP até 2 MB), `loading="lazy"`, links assinados agrupados num único pedido e reaproveitados.
- Confrontos, granadas e dano resolvidos numa única chamada ao banco.

## 6. Segurança (auditoria)

- RLS revisado nas tabelas novas: `combat_confrontations` (Mestre vê tudo; jogadores só os públicos da própria campanha; ninguém grava direto) e `item_uses`.
- Jogador só ataca/lança com o próprio personagem, em combate ativo, contra alvo visível; modificadores enviados são limitados; o dano dele nunca é aplicado sem o Mestre; confirmar duas vezes não aplica duas vezes.
- Callback de autenticação aceita só caminhos internos (bloqueia redirecionamento para outro domínio).
- `.gitignore` cobre `.env*` (exceto o exemplo), `.vercel`, logs e ZIPs. Nenhuma credencial no código.

## Testes executados (resultados reais neste ambiente)

| Suíte | Resultado |
|---|---|
| `npm test` — motor de regras + sincronia regras↔banco | **146 testes, 0 falhas** (inclui `v6.test.ts`: confronto, desempates, críticos, granadas, kit, PV/PC) |
| `01`–`07` — RLS, Fases 2/3, 3.5, 4, 5 (regressão) | passaram |
| `04` — paridade de custos de poder motor × banco | 1.849 casos OK |
| `08` — paridade de confrontos e perícias motor × banco | **2.086 casos OK** |
| `09_v6_tests.sql` — confrontos no combate, segurança, granadas, dano contínuo, kit, fotos no grupo | **passou** (6 execuções seguidas, com dados aleatórios) |
| TypeScript do projeto todo | sem erros (verificado com declarações mínimas das bibliotecas) |

### Não executado (e por quê)

- **`npm install`, `npm run typecheck` com as bibliotecas reais e `npm run build`**: este ambiente não alcança o registro do npm (o endereço não resolve). Rode na sua máquina ou deixe a Vercel rodar o build no primeiro deploy.
- **Testes de interface em navegador** (layout responsivo, animações, tema corrompido, fotos): sem navegador aqui. Use o roteiro da seção 5 de [`DEPLOY-VERCEL.md`](DEPLOY-VERCEL.md).
- **Cadastro/login e e-mails reais**: dependem do seu projeto Supabase.

## Pendências

- ~~Regra do maior d100~~ — **resolvida na 6.1**: menor vence.
- Granadas: um confronto (e uma rolagem de dano) **por alvo**; se a mesa preferir um único dano para a área, é uma decisão a registrar.
- O histórico de rolagens livres da ficha ainda é gravado pela ação do servidor com a sessão do usuário; confrontos, granadas e rolagens da campanha são rolados no banco e não podem ser forjados.
- Habilidades de criaturas continuam como teste simples (não são ataques); ataques com essas habilidades podem ser feitos como “ataque livre” em confronto.
