# F.R.A.N.C.E — Fase 5: Homebrew completo, monstros em combate e fotos

Atualização incremental sobre a Fase 4: mesmo projeto Supabase, nenhuma tabela apagada, mesmos IDs. Instalação/atualização: [`README.md`](../README.md#atualizar-uma-instalação-existente-mesmo-supabase). Storage: [`supabase/STORAGE.md`](../supabase/STORAGE.md).

Migração nova: `supabase/migrations/20261026000100_fase5_homebrew.sql` — categorias e imagem do Homebrew, compartilhamento com campanhas, fotos por forma, imagem/usos/modificadores personalizados nos itens, instâncias de criaturas nos combates, visão pública de NPCs, bucket privado + políticas do Storage.

## Funcionalidades

### 1. Fotos dos personagens (prioridade)
- Área **FOTO DO PERSONAGEM** na criação (etapa Identidade) e na ficha (botão *Foto* no cabeçalho).
- Enviar do computador/celular (PNG, JPG, WebP; até 15 MB na origem), prévia, **recorte** com arrastar para enquadrar e zoom, substituir e remover. O recorte é feito no aparelho e o arquivo final (WebP, 600×750, até 2 MB) vai para o Supabase Storage; o banco guarda só o caminho.
- Cabeçalho novo da ficha: foto, nome, classe, origem (e Caminho) e nível, com **moldura holográfica azul**; sem foto, ícone padrão. A imagem nunca estica (`object-fit: cover` no recorte salvo).
- **Aba Personagens**: a foto é o elemento principal de cada cartão (nome, origem, classe, nível). Trocar a foto na ficha atualiza o cartão (o painel é revalidado).
- **Artificial**: uma foto para a forma humana e outra para a forma Lenda (cada forma tem seu `portrait_path`). Ao alternar, a foto da ficha troca junto; a Lenda usa **moldura corrompida** (identidade da 3.5). Nunca se misturam.
- O Mestre vê as fotos dos agentes no Escudo e na lista de combatentes.

### 2. Biblioteca Homebrew
- Categorias: **Monstros, NPCs, Armas, Equipamentos, Modificadores, Itens especiais, Outros conteúdos**, cada uma com seu botão *Criar*.
- Cartões com imagem, nome, categoria, resumo, data da última atualização e botões **Abrir / Editar / Duplicar / Excluir**. Pesquisa, filtro por categoria (com contagem) e ordenação por data ou nome.
- Página do conteúdo com todos os dados, uso prático (adicionar à campanha / à ficha) e compartilhamento.
- Editores em **seções expansíveis**, imagem com recorte, barra de salvar fixa; funcionam no celular.

### 3. Editor de monstros
- Básico: nome, descrição, história/origem, imagem, categoria, nível/classificação, observações privadas do Mestre.
- **Atributos** (FOR, DEX, INT, CON, MIT, PER, CAR, VIG) definidos diretamente, com acerto **normal / bom / extremo** ao lado de cada um (d100).
- **Recursos**: PV e PC máximos e atuais livres (sem a fórmula dos jogadores), defesa, resistências, vulnerabilidades, imunidades e deslocamento.
- **Perícias** da ficha ou próprias, sem o limite de 75, com normal/bom/extremo.
- **Ataques**: nome, descrição, perícia/atributo/valor fixo, expressão de dano, tipo de dano, alcance, efeitos e condições aplicadas. Dá para importar uma arma do Homebrew como ataque.
- **Habilidades**: nome, tipo, descrição, dano, cura, condição (com turnos), área, duração, custo de PC, teste opcional, regras especiais e **efeito manual**.
- Editar, duplicar, excluir, **adicionar a campanhas** (cópia) e **adicionar a combates**.

### 4. Monstros do Homebrew nos combates (prioridade)
- Aba **Combates** → **+ ADICIONAR COMBATENTE** → abas *Monstros do Homebrew*, *NPCs da campanha*, *Personagens*, *Avulso*; pesquisa por nome; cada criatura com imagem e resumo; **quantidade** (1–20) e iniciativa.
- Cada inclusão vira uma **instância independente** (`combatants` com cópia da ficha em `data`): PV, PC, condições, iniciativa e estado próprios. Três Leshys = *Leshy 1, 2 e 3*, todos 150/150; dano em um não muda os outros. A numeração continua se você adicionar mais depois.
- Nos cartões do combate: **ataques** (d100 + dano rolados no servidor, extremo ×1,5 e crítico ×2) com botões **Aplicar dano no alvo** e **Aplicar condição**; **habilidades** que **consomem PC** da instância (recusa se faltar; o mesmo clique não cobra duas vezes), rolam dano/cura e aplicam no alvo ou em si; *Ver ficha* mostra atributos, perícias, defesas e descrições. Rolagens podem ser secretas (padrão) ou públicas.
- Encerrar e reabrir mantém tudo. Editar o modelo depois **não** altera combates existentes; o mesmo modelo pode ser usado em vários combates.

### 5. NPCs
- Editor com idade, imagem, descrição física, personalidade, história, relação com a campanha e **anotações secretas**.
- **Ficha simplificada** (PV, PC, ataques, habilidades) ou **completa** (atributos, perícias, inventário, equipamentos, poderes, condições).
- No Escudo, NPCs da campanha usam o mesmo editor de criatura, com imagem própria (`npcs/<campanha>/…`) e a opção *visível para os jogadores*.
- Segredos protegidos: jogadores não leem mais a tabela `npcs`; veem só `npcs_public` (nome, imagem, descrição, aparência, condições) dos NPCs visíveis.

### 6. Armas e equipamentos
- **Armas**: nome, descrição, imagem, categoria, tipo de ataque, perícia, dado e tipo de dano, alcance, categorias de arma, efeitos especiais e **modificadores** (oficiais compatíveis + personalizados), com **prévia recalculada** (dano, crítico, bônus de ataque, condições).
- **Equipamentos e itens especiais**: equipamento, consumível, item de cura, item especial, objeto místico, utilidade, outro; quantidade, efeito, expressão de dados, condições especiais, **usos disponíveis** e habilidade concedida.
- Na ficha: **Usar** (no inventário e no Inventário Rápido) desconta a quantidade (consumível) ou 1 uso no banco, de forma atômica; itens de **cura** rolam e curam a forma ativa; a rolagem aparece na bandeja.
- Armas e itens vão para fichas como **cópias independentes** (também pelo Mestre em *Agentes → Dar item*), viram ataques de monstros/NPCs e entradas do inventário de NPCs.

### 7. Modificadores personalizados
- Categoria compatível (ou qualquer arma), ajuste no ataque, dano adicional, dados da arma (±), efeitos em crítico, condição, penalidades, requisitos e **regra especial** (não ocupa vaga).
- Ao aplicar (no criador de armas ou numa arma da ficha) o sistema verifica a compatibilidade e o limite de **2 modificações** (oficiais + personalizados), no navegador, no servidor e no banco. Os efeitos numéricos entram automaticamente no cálculo do ataque.

### 8. Compartilhamento
- Conteúdos são privados. Na página do conteúdo, o autor marca as campanhas que **mestra** onde ele fica disponível (armas, equipamentos, itens especiais, modificadores, outros).
- Os jogadores dessas campanhas veem o conteúdo (no Homebrew e na biblioteca do inventário) e adicionam cópias às próprias fichas. Ninguém além do autor altera o modelo. Monstros e NPCs não são compartilhados com jogadores (têm segredos) — o Mestre os usa pelo Escudo.

## Testes executados

| Suíte | Resultado |
|---|---|
| `npm test` (motor + sincronia regras↔banco) | **134 testes, 0 falhas** — inclui `src/rules/__tests__/fase5.test.ts` (criaturas, ataques, habilidades, cópias, modificadores) |
| `01` RLS, `02`/`03` Fases 2 e 3, `05` Atualização 3.5, `06` Fase 4 (regressão) | passaram |
| Paridade motor × banco | 1849 casos OK |
| `07_fase5_tests.sql` (20 fluxos, com Storage simulado) | **passou** |
| TypeScript do projeto todo (com declarações mínimas das bibliotecas) | sem erros |

Os 20 fluxos de `07_fase5_tests.sql`:

1. Criar monstro no Homebrew (com imagem na pasta do autor; caminhos inválidos e `../` recusados).
2. Salvo no banco; privado (outro usuário não vê).
3. Adicionar à campanha (cópia; NPC não aponta para imagem de outro usuário).
4. Adicionar ao combate (modelo de outro usuário recusado; jogador não adiciona).
5. Três cópias do mesmo monstro.
6. Dano numa cópia sem afetar as outras (pedido repetido não desconta de novo); condição só na cópia escolhida; modelo intacto.
7. Ataque registrado no histórico e dano aplicado no alvo.
8. Habilidade consome PC da instância uma vez; PC insuficiente recusado; jogador não usa.
9. Encerrar e reabrir sem perder PV/PC/condições; editar o modelo não altera instâncias.
10. Criar/editar NPC; jogador não edita; NPC secreto e notas protegidos (visão pública).
11. Arma personalizada.
12. Arma no inventário (cópia, com modificador personalizado); imagem de modelo não legível recusada.
13. Modificadores: incompatível recusado, limite 2 (oficial + personalizado), regra especial ultrapassa; usos limitados (`consume_item`).
14. Enviar foto para a pasta do próprio personagem; outro usuário não envia.
15. Foto gravada na ficha.
16. Mesma referência para o cartão.
17. Trocar a foto (novo arquivo, referência nova, antigo apagado); outro usuário não lê nem apaga.
18. Artificial com fotos diferentes nas duas formas; foto fora da pasta recusada.
19. Compartilhar arma com campanha: jogador vê e copia, não altera; monstro não é compartilhado; quem não é da campanha não vê.
20. Storage: Mestre só vê foto de personagem com vínculo aceito; NPC visível × secreto; imagem de monstro no combate; imagem privada protegida; subpastas e pastas alheias recusadas; quem não participa não lê nada.

## Não testado / pendências
- **Navegador e `npm run build`**: o ambiente de desenvolvimento não tem acesso ao registro do npm nem a navegador; as telas foram conferidas por TypeScript, não clicadas. Antes de publicar: `npm install && npm run build` e teste com duas contas (Mestre e jogador), principalmente o recorte de imagem no celular.
- **Storage real**: as políticas foram testadas num `storage.objects` simulado. No Supabase, confira o bucket e as políticas como descrito em `supabase/STORAGE.md`.
- **Arquivos órfãos**: se você envia uma imagem num editor e fecha sem salvar, o arquivo fica no bucket (não aparece em lugar nenhum). Trocas e exclusões salvas apagam o arquivo antigo quando ninguém mais o usa.
- **Efeitos não automatizados**: condições descritas (ex.: “Sangramento 1d4 por 2 turnos”), áreas e habilidades concedidas por objetos místicos são mostradas e registradas; o Mestre aplica. Habilidade marcada como *efeito manual* só registra o uso e cobra o PC.
- Ataques de criaturas usam o valor do teste diretamente (sem vantagem/desvantagem automática); ajuste à mão se a cena pedir.
- Itens de **dano** usados pela ficha rolam e registram o dano; aplicar no alvo continua com o Mestre (no combate).
