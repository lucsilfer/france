# F.R.A.N.C.E — Regras extraídas e pontos que precisam de confirmação

Fontes lidas na íntegra: **Tríade das Lendas — Livro do Jogador** (25 páginas, capa "versão 1.0", rodapé "v0.2") e **ficha lendas (6)** (4 páginas).

Toda decisão abaixo está concentrada em `src/rules/config.ts` (uma chave por decisão) ou nos arquivos de dados em `src/rules/data/`. Nada foi inventado silenciosamente: onde o livro não define, a decisão está marcada como **[decisão do site]** e pode ser trocada numa linha.

Legenda: 🔴 bloqueia implementação fiel · 🟡 tem decisão provisória · 🟢 só registro.

---

## 1. Fórmulas da ficha

| # | Ponto | O que está escrito | Decisão atual | Onde mudar |
|---|---|---|---|---|
| 1 | 🟢 PV inicial (corrigido na 3.5) | Ficha: "FOR + CON / 3" | **(FOR + CON) ÷ 3**, para baixo (autor). A fórmula antiga `FOR + ⌊CON ÷ 3⌋` estava errada | `pvFormula`, `form_pv_max` |
| 2 | 🟡 Conhecimento Bélico | Ficha: "(1/INT)" | metade de INT (pedido) | `conhecimentoBelicoDivisor` |
| 3 | 🟢 PC inicial | "VIG/3" | `⌊VIG ÷ 3⌋` | `resourceRounding` |
| 4 | 🟡 PV/PC usam atributo com bônus de classe? | Não dito | Sim — o Brawler (+4 FOR) ganha +4 PV | `character.ts › baseResources` |
| 5 | 🟢 Faixa de atributos | 3d6×5 → 15 a 90 (até 94 com +4 de classe) | — | — |
| 6 | 🟢 Limite de perícia (corrigido na Fase 3) | "máx. 75" | **75 é o valor TOTAL da perícia** (base do atributo + pontos + bônus de classe + outros bônus permanentes), não a quantidade de pontos. Detalhista: total 95. Bônus **temporários** não contam para o limite | `skillDistribution.maxSkillTotal`, `character.ts › validateSkillDistribution` e trigger `validate_form_skill` |

## 2. Classes

| # | Ponto | Decisão atual |
|---|---|---|
| 7 | 🟡 Atirador ("recebe a perícia de armas de fogo e mais 25 pontos") e Rato ("furtividade de graça e mais 25") | +25 como **bônus de classe** separado; **não** conta entre as 4 perícias escolhidas (`classFreeSkillCountsAsChoice`) |
| 8 | 🟡 Detalhista: 200 pontos / total máx. 95 por perícia | Continua escolhendo **4** perícias (livro não muda a quantidade) |
| 9 | 🟢 Tank: "+20 de vida no level 1" | Somado ao PV inicial |
| 10 | 🟢 Bônus situacionais (Brawler +1d4 em armas físicas, Esotérico +1d6 contra lendas, Healer +1d6 em cura, Líder −15 por cena, vantagens) | Exibidos na ficha; aplicados por escolha do jogador na rolagem (Fase 3), porque dependem do alvo/contexto |
| 11 | 🟡 Brawler "não acumula com a habilidade do Prodígio" | Quando ambos se aplicam, vale o maior bônus de dano |

## 3. Teste d100 e vantagem

| # | Ponto | Decisão atual |
|---|---|---|
| 12 | 🟢 Faixas | Conferido com a tabela do livro (50/25/10 → 100 crítica, 99–51 falha, 50–26 normal, 25–11 bom, 10–2 extremo, 1 crítico). Testes automatizados reproduzem a tabela |
| 13 | 🔴 "Vantagem" genérica | O livro usa vantagem de três formas: número ("−15 como vantagem", "−10 de desvantagem"), contagem ("ganha 2 vantagens") e sem valor ("vantagem em teste de carisma"). **Provisório:** cada vantagem = rolar mais um d100 e ficar com o menor (`advantageMode`). Alternativa pronta: cada vantagem = −15 no dado |
| 14 | 🟡 "+5 / +10 / −10 no ataque" | Tratado como modificador no resultado do dado: bônus **reduz** o número rolado (menor é melhor). Críticos 1 e 100 usam sempre o dado natural |
| 15 | 🟡 Falha crítica: "recebe 1,5× de dano no próximo turno" | Registrada como condição temporária no personagem (Fase 3/4, combate) |

## 4. Ataques e armas

| # | Ponto | Decisão atual |
|---|---|---|
| 16 | ✅ Armas de fogo usam qual perícia? | **Resolvido (21/10/2026):** corpo a corpo → Luta; armas de fogo → **Arma de Fogo**; demais armas de longa distância → Pontaria (`attackSkill`) |
| 17 | 🔴 Chicote "1d18" | Não existe d18 comum. Mantido como está (o interpretador aceita) até confirmação — provável 1d8 |
| 18 | 🔴 Categorias das armas | Os modificadores exigem classes (Lâminas, Pesadas, Contundentes, Foices/Correntes, Perfurantes/Projéteis, Distância, Corpo a corpo, Arma de fogo), mas **a tabela de armas não diz a categoria de cada arma**. Inferi pelas colunas de dano e alcance (ex.: Espada grande = Lâmina + Pesada; Balestra = Perfurante/Projétil + Distância). Revisar em `src/rules/data/equipment.ts` |
| 19 | 🟡 Arredondamento do dano ×1,5 | Mantém decimais (10,5), como no exemplo pedido (`damageRounding: "none"`) |
| 20 | 🟢 Limite de modificações | 2 por arma; exceção do Prodígio/Arsenal ("Modificada": 2 iniciais + 1 temporário por descanso longo) |
| 21 | 🟡 Recuo Pesado, Rajada, Dispersão etc. | Condicionais — aplicados por opção na rolagem; só Equilibrada (+5) e Pesada (−10/+1d6) são automáticos |
| 22 | 🟢 Técnica "Recobrar-se" | Aparece **duas vezes** no livro (p. 25); cadastrada uma vez |

## 5. Criação de habilidades (poderes)

| # | Ponto | Decisão atual |
|---|---|---|
| 23 | ✅ Limite de PC por nível | **Resolvido (21/10/2026):** `15 + 3 × (nível − 1)` (`powerLimitMode: "linear"`), que coincide com todos os pontos da tabela. O limite de **dados extras** segue os patamares do livro |
| 24 | 🟡 "+3 PC = +1 dado" | Para dano, o dado extra é do mesmo tipo da faixa (2d8 → 3d8). Cura usa +1d6 e escudo +1d8, como nas tabelas |
| 25 | 🟡 "Dados extras máximos" | Interpretado como o total de "+1 dado" comprados numa habilidade |
| 26 | 🔴 Custo por turno conta no limite? | Livro não diz. Hoje **não** conta (`perTurnCostCountsTowardLimit`) |
| 27 | 🟡 Cura contínua | Livro só dá custo por turno, sem custo inicial — implementado assim |
| 28 | 🟡 Cura em área | Tabela própria (+6/+9/+12/+15), diferente do dano em área (+0/+3/+6/+9) — implementado como está |
| 29 | 🟡 Dano contínuo | Não existe tabela; dano é só instantâneo. Duração contínua existe para Condições, Melhorias e Cura contínua |
| 30 | 🔴 Amaldiçoado "custo de PC reduzido pela metade e, a cada 2 dados, +1d6" | Arredondamento da metade: **para cima**. Limite por nível checado contra o custo **cheio**. +1d6 a cada 2 dados de dano |
| 31 | 🟢 Uso de poder | Sem teste de acerto (pedido); débito de PC atômico e idempotente no banco (`spend_pc`) |

## 6. Progressão de nível

| # | Ponto | Decisão atual |
|---|---|---|
| 32 | 🔴 **Prodígio: 1d12+2 PV e sem PC** | Esta regra **não está no livro** — veio da especificação do site. Implementada com prioridade sobre a classe (`prodigioProgression`) |
| 33 | 🟢 Dados por classe | Conferidos: Brawler 1d10/1d6 · Demolidor 1d10/1d6 · Detalhista 1d8/1d8 · Esotérico 1d6/1d12 · Atirador 1d8/1d8 · Rato 1d8/1d8 · Healer 1d6/1d10 · Tank 1d12/1d6 · Líder 1d8/1d8 |
| 34 | 🟢 Combatente de Guerra | +1 dado no nível 1, +1 a cada 5 níveis (nível 15 = +4; nível 20 = +5) |
| 35 | 🟡 Forma Lenda do Artificial | Recebe atributos/perícias próprios; **não** recebe bônus de classe. Progressão de PV/PC própria por forma |

## 7. Origens (mecânicas narrativas)

Muto (partes consumidas), Elo (objeto místico), Amaldiçoado (buff/debuff do Mestre), Remanescente (Legado: "+1 dado/turno a cada dois níveis ímpares"; "2 budd" lido como **2 buffs**), Receptáculo (habilidade a cada nível par) e Lenda (duas histórias) dependem do Mestre. O site registra esses traços, mostra quais estão liberados pelo nível e cria campos para o jogador anotar o que foi definido — não calcula efeitos que o livro deixa em aberto.

## 8. Inconsistências editoriais

- Sumário: V Criação de habilidade · VI Armas e técnicas · VII Pactos. No corpo, Armas está como "Capítulo VII" e Pactos como "Capítulo VI".
- Caminho do Arsenal manda usar "técnica da lista do capítulo V", mas as técnicas estão no capítulo de Armas.
- Capa diz versão 1.0, rodapé diz v0.2.
- A ficha p. 3 e p. 4 contém textos de teste nos campos (ex.: "itens exemplo"); ignorados.


## 9. Decisões da Fase 3

| # | Ponto | Decisão atual | Onde mudar |
|---|---|---|---|
| 36 | 🟢 Fichas antigas acima do limite de perícia | Não são apagadas nem corrigidas sozinhas: a ficha mostra "acima do limite"; o jogador pode **reduzir**, mas nenhuma edição pode **aumentar** uma perícia que passe do limite (motor `checkSkillEdit` + trigger no banco) | `checkSkillEdit`, `validate_form_skill` |
| 37 | 🟡 Orçamento total de pontos (150/200) | O banco valida o limite **por perícia**; o total de pontos e as 4 escolhas são validados pelo motor no servidor ao finalizar a criação (o banco não bloqueia redistribuições feitas pelo Mestre na ficha) | `finalizeCharacter`, `validate_character_rules` |
| 38 | 🟡 Forma Lenda sem classe | A Lenda distribui 4 perícias / 150 pontos / total 75, sem bônus nem dados de classe (usa a base do Artificial) | `sheet.ts › checkLendaCreation`, `applyClass` |
| 39 | 🟡 Brawler "armas físicas" | Interpretado como toda arma que **não** é arma de fogo (+1d4); não acumula com o Combatente de Guerra do Prodígio | `combat.ts › planAttack` |
| 40 | 🟡 Multiplicadores de dano | Extremo ×1,5 e 1 natural ×2 (não acumulam: vale o maior). Sem arredondamento (`damageRounding: "none"` exibe o valor exato) | `RULES_CONFIG.damageRounding` |
| 41 | 🟡 Falha crítica no ataque | Sem dano; a consequência é narrativa (o Mestre decide) e aparece como aviso no resultado | `combat.ts › performAttack` |
| 42 | 🟡 Vantagem | "Rolar de novo e ficar com o menor" (`advantageMode`); a Mira do Atirador dá 2 vantagens | `RULES_CONFIG.advantageMode` |
| 43 | 🟡 Modificadores de arma | Máximo 2 permanentes por arma; 1 temporário só para o Prodígio Arsenal. Compatibilidade pela categoria exigida no livro | `maxWeaponModifiers`, trigger `validate_item_modifier` |
| 44 | 🟡 Poder contínuo | O custo inicial é cobrado ao usar; cada turno de manutenção cobra o custo por turno quando o jogador clica "Próximo turno". O jogador escolhe quantos turnos (1–100) e pode encerrar antes. Cura contínua rola a cada turno pago | `use_power`, `advance_effect` |
| 45 | 🟡 Poder acima do limite depois de baixar o nível | O poder continua salvo e utilizável; a ficha mostra um alerta. Para editar os efeitos ele precisa caber no limite do nível atual | `validate_power` |
| 46 | 🟡 Prodígio Xamã / Remanescente Legado | Contagens de usos por nível ímpar interpretadas como "+1 a cada dois níveis ímpares após o 1º" e exibidas na aba de habilidades | `unlocks.ts` |
| 47 | 🟢 Não automatizado | Talismã de energia (uso sem custo 1×/luta), vantagem do Demolidor com arremessáveis, Engrenagem além do −15, efeitos narrativos de origem: exibidos como texto para o Mestre aplicar | — |
| 48 | 🟢 Descer de nível | Os ganhos dos níveis acima ficam guardados (`level_progressions`), não entram no máximo e voltam iguais ao subir de novo — nunca são rolados de novo | `set_character_level` |


## 10. Decisões da Atualização 3.5

| # | Ponto | Decisão atual | Onde mudar |
|---|---|---|---|
| 49 | 🟢 PV de personagens existentes | O máximo é recalculado dos atributos (nada guardado muda). Só o PV atual acima do novo máximo é reduzido, com registro em `pv_formula_fix_log` | `fix_pv_after_formula_change` |
| 50 | 🔴 Arsenal: técnicas | Livro: "a cada nível par, aprende uma técnica" → **0 no nível 1**, +1 por nível par (nível 2 = 1). O Arsenal não cria nada no nível 1 | `abilities.pathOverrides["prodigio:arsenal"]` |
| 51 | 🔴 Engrenagem: aparatos | Instrumento inicial + "a cada nível par, cria uma habilidade ligada a ele" → **1 no nível 1**, +1 por nível par. Dispositivos do Tecnólogo (interlúdio) podem ser registrados como itens no inventário | `abilities.pathOverrides["prodigio:engrenagem"]` |
| 52 | 🟡 Pacto | O livro não dá quantidade → regra geral (2 + 1 por nível par) | `abilities` |
| 53 | 🟡 Muto | Não usa vagas nem bloqueio; ainda pode registrar poderes (ex.: partes roubadas) sem ocupar vagas | `abilities.originModes.muto = "none"` |
| 54 | 🟡 Criação sem vaga | Sem vagas disponíveis, criar é bloqueado (navegador, servidor e banco). Elo e Muto são livres | trigger `validate_power` |
| 55 | 🟡 Receptáculo | Segue a regra geral da 3.5 (prioridade sobre o "1 poder inicial + 1 por nível par" do livro) | `abilities` |
| 56 | 🟡 Rato: "arma leve" | O livro não define; interpretado como **arma simples** | `startingKits.ts` |
| 57 | 🟡 Granadas do Demolidor | Entregues como "Granada ×5"; tipo e dano continuam a cargo do Mestre (o livro não fixa) | `startingKits.ts`, catálogo |
| 58 | 🟡 Prodígio sem PC | Custo cheio é calculado só como referência; nada é cobrado. Sem limites de PC e dados extras. Pode registrar sem efeito de dados | `prodigioPowers` |

---

## Para confirmar com o autor (prioridade)

1. Técnicas do Arsenal e aparatos da Engrenagem por nível (#50, #51).
2. Categoria de cada arma para os modificadores (#18).
2. Mecânica de "vantagem" sem número (#13).
3. Custo por turno entra no limite? (#26)
4. Chicote: 1d18? (#17)
5. Prodígio 1d12+2: confirmar e incluir no livro (#32).

## Onde as regras vivem

Todas as decisões ficam em `src/rules/config.ts` e `src/rules/data/*`. O banco **não** tem regras escritas à mão: `npm run rules:sql` gera `supabase/migrations/20261024000000_rules_sync_3_5.sql` (as versões anteriores, `20261022000000_rules_sync.sql` e `20261023000000_rules_sync_fase3.sql`, ficam congeladas porque já foram aplicadas) (rolagem de atributos, classes, origens, caminhos, perícias, limites, modificadores de arma, tabelas de poder e dados de evolução) a partir do motor, e um teste falha se o arquivo estiver desatualizado. Ao mudar uma regra: edite o motor → `npm run rules:sql` → aplique a migração.
