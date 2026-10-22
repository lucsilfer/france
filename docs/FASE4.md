# F.R.A.N.C.E — Fase 4: campanhas, Escudo do Mestre e técnicas do Arsenal

Atualização incremental sobre a 3.5: mesmo projeto Supabase, nenhuma tabela apagada, mesmos IDs. Instalação/atualização: [`README.md`](../README.md#atualizar-uma-instalação-existente-mesmo-supabase).

Migrações novas (nesta ordem):

1. `supabase/migrations/20261025000000_rules_sync_fase4.sql` — gerada pelo motor (`npm run rules:sql`): catálogo de técnicas, `form_pc_max`, vagas contando poderes + técnicas.
2. `supabase/migrations/20261025000100_fase4_campanhas.sql` — técnicas, convites, vínculos com aprovação, condições, combates, investigação, relatórios, rolagens no banco, RLS, Realtime.

## Funcionalidades

### 1. Técnicas do Arsenal (Prodígio · Caminho do Arsenal)
- Catálogo do livro (11): Arte do Desarme, Arte do Contra-Ataque, Provocação, Múltiplos Alvos, Múltiplos Golpes, Adrenalina, Metavisão, Recobrar-se (uma vez só), Passos Leves, Furtividade Rápida, Ataque Furtivo — `src/rules/data/equipment.ts`.
- Aba **Técnicas de Arsenal**: técnicas aprendidas + botão **Aprender técnica** → catálogo em cartões expansíveis (descrição, requisitos, efeito, limite), busca e filtro "disponíveis no meu nível", **Selecionar**.
- Uma técnica a cada nível par (0 no nível 1); sem repetir; requisitos conferidos (ex.: Furtividade Rápida pede DEX 70+ e Passos Leves); contador de vagas. Técnicas e técnicas personalizadas (poderes) dividem as mesmas vagas — nunca consomem duas vezes.
- Baixar o nível **suspende** as técnicas aprendidas acima dele (não apaga). Esquecer é bloqueado se outra técnica depende dela.
- Uso em jogo: limites por cena, sessão, a cada N turnos; contador **Próximo turno / Nova cena / Nova sessão** na aba; passivas não viram botão; Adrenalina recarrega as técnicas por cena; Recobrar-se recupera metade do dano (ou volta com 1 PV); Metavisão mostra o aviso de vantagem nas esquivas. Sem custo e sem limite de PC.
- Ataques: Arte do Desarme (+1 dado de arma) e Ataque Furtivo (+1d8) aparecem como opções no diálogo de ataque; o uso é registrado no banco antes da rolagem (`use_technique`, idempotente).
- Técnicas também aparecem no **Inventário rápido**.

### 2. Campanhas
- **Criar campanha** abre uma janela (nome, descrição, capa opcional, privacidade); o criador vira Mestre.
- Convite único por campanha: pré-visualização com nome/descrição, entrada como jogador, sem entrada duplicada. O Mestre **ativa/desativa** e **renova** o link. Convite nunca dá poder de Mestre.
- Jogadores vinculam os próprios personagens (sem cópia). O vínculo fica **aguardando o Mestre**, que aceita ou recusa; o Mestre só vê a ficha depois de aceitar. O jogador decide se o Mestre pode alterar PV/PC/condições e pode remover o personagem.
- Central da campanha (`/campanhas/[id]`): Visão geral · Combate · Investigações · Relatórios · Dados · Anotações, tudo ao vivo (Realtime) com selo "Ao vivo / Reconectando" e nova leitura após reconectar.

### 3. Escudo do Mestre (`/campanhas/[id]/escudo`, só o Mestre)
- **Agentes**: cartão por personagem (nome, classe, origem, nível, jogador, PV, PC — sem PC para Prodígio —, condições, "Abrir ficha"). Ajustes rápidos ±1, dano/cura e gasto/recuperação, condições com duração, "Dar item" (catálogo ou Homebrew, cópia independente). As duas formas do Artificial aparecem lado a lado com a ativa marcada. Mudanças chegam na ficha do jogador ao vivo.
- **NPCs e monstros** da campanha: criar/editar (PV, PC, atributos, ataques com valor d100 e dano, habilidades, notas), instanciar do Homebrew, ajustar, condições, atacar (d100 + dano rolados no servidor, rolagem secreta ou pública), excluir.
- **Combates**: criar; adicionar agentes, NPCs (cada inclusão é uma cópia numerada) e participantes avulsos; iniciativa manual ou regra da mesa (perícia Reflexo / 1d20); reordenar; **PRÓXIMO TURNO · VOLTAR TURNO · NOVA RODADA · ENCERRAR COMBATE**; turno atual e rodada em destaque; dano/cura/PC com id por clique (sem desconto duplicado); condições com duração; ocultar participante ou só os números; registro de ataques/poderes/efeitos; histórico. A manutenção dos poderes contínuos é cobrada no início do turno do personagem. Versão do combate impede que dois cliques avancem dois turnos.
- **Investigação**: casos com descrição, local, envolvidos, status e informação secreta; pistas com imagem/arquivos (links https), local, envolvidos e visibilidade **Secreta/Revelada** — revelar envia a pista na hora aos jogadores; quadro de conexões com itens arrastáveis, ligações e posições salvas.
- **Relatórios**: título, data, descrição, personagens, eventos, conclusões, anexos; linha do tempo, busca, filtro por data, privado ou visível aos jogadores.
- **Dados**: d4…d100, expressões (2d6+3, 2d12+1d6), testes de ficha; pública / privada (você e o Mestre) / secreta; histórico com autor, resultado, hora, tipo e classificação; mesma velocidade de rolagem da 3.5. Rolagens livres são sorteadas dentro do banco (`roll_dice`).
- **Anotações**: categorias, busca, salvamento automático, compartilhar com os jogadores.

## Segurança
- Tudo validado no banco (RLS + funções `security definer`): só o Mestre lê NPCs, combatentes ocultos, histórico privado, segredos, quadro, relatórios e notas privadas. Jogadores leem combate pela visão `combatants_public` e pistas por `revealed_clues`.
- PV/PC são limitados pelo máximo calculado pelo banco (`form_pv_max`/`form_pc_max`), nunca pelo valor enviado. Pedidos repetidos (`request_id`) não aplicam duas vezes; combates usam versão otimista.
- Realtime respeita o RLS: cada um só recebe o que pode ler.

## Testes executados

| Suíte | Resultado |
|---|---|
| `npm test` (motor + sincronia regras↔banco) | 123 testes, 0 falhas — inclui `src/rules/__tests__/fase4.test.ts` |
| `01_rls_tests.sql` (regressão, atualizado para vínculo com aprovação) | passou |
| `02`/`03` Fase 2 e 3 | passaram |
| Paridade motor × banco | 1849 casos OK (inclui Prodígio/Arsenal) |
| `05` Atualização 3.5 (regressão) | passou |
| `06_fase4_tests.sql` (20 fluxos) | passou |
| TypeScript (projeto todo, com declarações mínimas das bibliotecas) | sem erros |

Os 20 fluxos de `06_fase4_tests.sql`:

1. Arsenal nível 1 não aprende; nível par aprende; técnica repetida recusada; sem vaga dupla com poderes.
2. Requisitos (DEX 70+), limite por cena, pedido repetido, passiva não é "usada".
3. Técnica persiste; acima do nível fica suspensa; outro usuário não altera; tabela só via função.
4. Criador é Mestre.
5. Convite desativado não funciona; entrada única; convite não dá poder de Mestre.
6. Vínculo pendente; jogador não se aceita; ninguém vincula personagem alheio.
7. Mestre vê só fichas aceitas; grupo da campanha.
8. Mestre aplica dano/cura limitada ao máximo do banco; condição na ficha visível ao jogador; jogador não edita ficha alheia.
9. NPC/monstro criado pelo Mestre.
10. Participantes (agente usa a forma ativa).
11. Combate iniciado; versão antiga recusada.
12. Dano/cura no monstro sem desconto duplicado; dano no personagem vai para a ficha.
13. Condições perdem duração no fim do turno e expiram; voltar turno, nova rodada, histórico, encerrar; jogador não vê oculto nem controla o combate.
14. Investigação com segredo.
15. Pista secreta não aparece ao jogador.
16. Segredos e quadro protegidos; função não vaza pista secreta.
17. Pista revelada aparece; caso sigiloso não vaza o título; outra campanha não vê.
18. Relatório privado protegido.
19. Nota privada protegida; jogador não edita notas.
20. Rolagens: privada do Mestre protegida, pública visível, expressão rolada no banco, inválida recusada, privada do jogador visível só ao Mestre, não membro não rola.

## Não testado / pendências
- **Navegador e `npm run build`**: o ambiente de desenvolvimento não tem acesso ao registro do npm nem a navegador; a interface foi conferida por TypeScript, não clicada. Rode `npm install && npm run build` e teste os fluxos com duas contas (Mestre e jogador) antes de publicar.
- **Realtime** depende das tabelas na publicação `supabase_realtime` (a migração adiciona quando a publicação existe — padrão do Supabase).
- **Anexos e imagens** são links https (não há upload para o Storage nesta fase).
- **Iniciativa**: o livro não define; os modos automáticos são regras da mesa.
- **Arma Favorita** e efeitos narrativos das técnicas (Provocação, Múltiplos Alvos, Contra-Ataque) são registrados e mostrados, mas o resultado é decidido pelo Mestre.
- Ataques e poderes dos agentes continuam sendo rolados pelo jogador na ficha; o Escudo registra e ajusta recursos.
