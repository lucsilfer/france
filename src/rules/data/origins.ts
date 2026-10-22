/** Capítulo III — Origens (Livro do Jogador, pp. 9–14). */

export type TraitKind = "habilidade" | "passiva" | "progressao" | "limitacao" | "regra";

export interface OriginTrait {
  name: string;
  kind: TraitKind;
  text: string;
  /** Nível a partir do qual o traço está ativo (quando o livro indica). */
  minLevel?: number;
}

export interface OriginPath {
  id: string;
  name: string;
  traits: OriginTrait[];
}

export interface OriginDef {
  id: string;
  name: string;
  summary: string;
  description: string[];
  traits: OriginTrait[];
  paths?: OriginPath[];
  /** Artificial: ficha secundária da Lenda. */
  secondarySheet?: boolean;
  /** Origem que substitui a progressão de PV/PC da classe (regra do site para Prodígio). */
  overridesProgression?: boolean;
}

export const ORIGINS: OriginDef[] = [
  {
    id: "filho_de_lenda",
    name: "Filho de Lenda",
    summary: "Híbrido nascido da união entre uma lenda materializada e um ser humano.",
    description: [
      "Os Filhos de Lenda nascem da união rara e perigosa entre uma lenda materializada e um ser humano. Metade gente, metade entidade mítica, carregam no sangue a essência de forças sobrenaturais.",
      "Cada um manifesta habilidades herdadas da sua origem: uns dominam o fogo de um ser folclórico ardente, outros herdam a voz hipnótica de uma entidade aquática ou a força brutal de uma criatura das trevas. Pela natureza híbrida, resistem melhor à influência espiritual — e são caçados tanto por humanos quanto por lendas rivais.",
    ],
    traits: [
      { name: "Herança Maldita", kind: "habilidade", text: "Todo Filho de Lenda nasce com um poder ligado ao seu parente lendário, criado pelo jogador junto com o Mestre." },
      { name: "Instinto Ancestral", kind: "habilidade", text: "Nasceu para lutar contra lendas. Quando ele ou um aliado falha em um dado de esquiva, pode gastar 3 PC para rolar esse dado de novo." },
      { name: "Língua Ancestral", kind: "passiva", text: "É o único capaz de falar com lendas quando elas não usam a língua humana. Tem vantagem em qualquer teste de carisma." },
    ],
  },
  {
    id: "receptaculo",
    name: "Receptáculo",
    summary: "Humano que resistiu à possessão de uma lenda e firmou um pacto instável com ela.",
    description: [
      "Receptáculos são humanos marcados pelo destino: escolhidos, possuídos ou invadidos por uma lenda que quer tocar o mundo real. A maioria é dominada por completo e usada como casca. Alguns poucos resistem, e do embate nasce um pacto instável com a entidade que mora dentro deles.",
      "A convivência gera uma simbiose: o Receptáculo mantém o controle do próprio corpo e canaliza parte do poder da lenda. Em troca, a entidade se alimenta da percepção, das emoções e da fé que desperta através do hospedeiro.",
    ],
    traits: [
      { name: "Pacto de Força", kind: "progressao", text: "O Mestre define um conceito e um poder inicial na ficha. A cada nível par, o jogador cria uma nova habilidade a partir desse conceito." },
      { name: "Contato Mítico", kind: "habilidade", text: "Uma vez por combate, gaste 3 PC e role um dado de combate contra o alvo: vencendo, revela uma fraqueza da lenda inimiga e todos os ataques contra ela ganham +1 dado de dano." },
      { name: "Véu da Sombra", kind: "passiva", text: "A lenda esconde a própria presença e faz o hospedeiro passar por cego aos olhos das outras. Vantagem em furtividade contra qualquer lenda." },
    ],
  },
  {
    id: "artificial",
    name: "Artificial",
    summary: "Vínculo forçado entre humano e lenda; na transformação, a lenda assume o corpo.",
    description: [
      "O Artificial é fruto de um vínculo forçado entre humano e lenda, feito por rituais proibidos ou por experimentos de organizações que querem domar o que não compreendem.",
      "Diferente do Receptáculo, que divide a consciência com a entidade, o Artificial perde o corpo ao se transformar: a lenda assume o comando e usa o hospedeiro como marionete. O poder bruto supera o de um Receptáculo, mas o preço é a própria liberdade — durante a transformação, ele é uma arma viva capaz de devastar tudo em volta.",
    ],
    traits: [
      { name: "Âmago Atroz", kind: "habilidade", text: "Vítima do próprio poder, tem mais de uma personalidade. O jogador escolhe a lenda da junção forçada e cria habilidades a partir dela." },
      { name: "Dualidade Física", kind: "regra", text: "Quando a lenda toma o controle, corpo e mente mudam para uma forma feita para o combate. O Artificial tem duas seções de atributos e rola duas vezes: uma para a pessoa, outra para a lenda." },
      { name: "Gatilho", kind: "limitacao", text: "A troca de controle só acontece diante de um gatilho, definido pelo jogador: sentir-se em perigo, água quente, barulho alto, entre outros." },
    ],
    secondarySheet: true,
  },
  {
    id: "muto",
    name: "Muto",
    summary: "Humano reescrito pela união entre biologia e magia.",
    description: [
      "Mutos são humanos transformados pela união entre biologia e magia. Através de experimentos e alterações sobrenaturais, seus corpos foram reescritos, desenvolvendo capacidades impossíveis para uma pessoa comum.",
      "Essas alterações afetam carne, ossos e até seus sentidos, tornando cada Muto único. Eles não são lendas, mas também já não podem ser considerados totalmente humanos: são seres presos entre o natural e o sobrenatural.",
    ],
    traits: [
      { name: "Mutação Adaptativa", kind: "progressao", text: "Durante a campanha você pode pegar partes dos corpos de outras criaturas e pessoas para roubar seu poder. Pode roubar 2 partes por nível par e pode remover 1 parte caso precise." },
      { name: "Evolução de Partes", kind: "progressao", text: "A cada 5 níveis você pode melhorar ou modificar o efeito de até 4 partes consumidas, podendo mudar o efeito de acordo com o poder da pessoa consumida.", minLevel: 5 },
      { name: "Metamorfose", kind: "habilidade", text: "Você pode mudar a forma de seu corpo para se adaptar a cada situação; a liberdade para modificar seu corpo aumenta de acordo com a quantidade de partes consumidas." },
    ],
  },
  {
    id: "elo",
    name: "Elo",
    summary: "Humano com conexão genuína com uma lenda, acessada por um objeto de vínculo.",
    description: [
      "Elos são humanos que criaram uma conexão genuína com uma lenda através de confiança e companheirismo. Diferente dos Receptáculos, a lenda não habita seu corpo e nenhum pacto prende os dois.",
      "Para acessar seus poderes, o Elo utiliza um objeto de vínculo, algo conectado à história ou à própria lenda. Através dele, humano e lenda compartilham sua Existência, permitindo que o Elo manifeste parte das habilidades de seu companheiro.",
    ],
    traits: [
      { name: "Objeto Místico", kind: "progressao", text: "Diferente dos outros, você ganha habilidades novas de acordo com o quanto vai conhecendo a lenda dentro do objeto. Todos podem usá-lo, mas só você pode dominá-lo." },
      { name: "O Agir da Lenda", kind: "regra", text: "A lenda pode ser qualquer objeto, desde uma espada até um clipe de cabelo, podendo modificar o corpo de quem o segura de maneira equivalente à liberdade que a pessoa dá." },
      { name: "Marca na Alma", kind: "limitacao", text: "Quanto mais você usa esse poder, mais a sua alma fica marcada, fazendo com que outras lendas evitem fazer pactos contigo." },
    ],
  },
  {
    id: "amaldicoado",
    name: "Amaldiçoado",
    summary: "Marcado por uma maldição ligada à Existência: poder em troca de um preço.",
    description: [
      "Amaldiçoados são humanos marcados por uma maldição ligada à Existência. Seja por terem enfrentado uma lenda, tocado algo que não deveriam ou herdado o fardo de outra pessoa, carregam consigo uma força sobrenatural que não pode ser simplesmente abandonada.",
      "A maldição concede habilidades únicas, mas sempre exige algo em troca. Quanto mais o Amaldiçoado explora seu poder, mais precisa aprender a conviver com as consequências daquilo que o marcou.",
    ],
    traits: [
      { name: "Preço Maldito", kind: "habilidade", text: "O jogador escolhe a origem de sua maldição e a primeira habilidade; junto com isso, cria um buff extra no primeiro nível e o Mestre cria o debuff equivalente para o personagem." },
      { name: "A Dívida a Pagar", kind: "regra", text: "O custo de PC das habilidades é reduzido pela metade e, a cada 2 dados, recebe +1d6 de dano. Porém, quanto mais demorar para pagar o preço, maior será o debuff." },
      { name: "Redenção", kind: "regra", text: "Caso o personagem consiga cumprir os requisitos, terá a sua redenção. A partir desse momento, todos os debuffs serão removidos." },
    ],
  },
  {
    id: "remanescente",
    name: "Remanescente",
    summary: "Escolhido por uma lenda em seus últimos momentos para receber toda a sua Existência.",
    description: [
      "Remanescentes são aqueles escolhidos por uma Lenda em seus últimos momentos para receber toda a sua Existência. Ao aceitar esse legado, seus poderes, marcas e parte de sua história passam a viver através do novo portador.",
      "Enquanto o remanescente estiver vivo, a Lenda não pode retornar, pois sua Existência permanece presa a ele. Com o tempo, essa herança se desenvolve e transforma o portador, aproximando-o cada vez mais daquilo que um dia herdou.",
    ],
    traits: [
      { name: "Legado", kind: "progressao", text: "Como os outros, o Remanescente cria uma habilidade por nível par, mas a cada dois níveis ímpares todas as habilidades criadas recebem um buff de 1 dado/turno." },
      { name: "Meu ou Dele", kind: "progressao", text: "Quanto mais o Remanescente sobe de nível, mais as habilidades deixam de ser da lenda e viram dele também. No nível 7 você pode escolher 3 habilidades para considerar suas; essas habilidades recebem 2 buffs da passiva \"Legado\".", minLevel: 7 },
      { name: "Minha Energia é Dele", kind: "passiva", text: "Outras pessoas e lendas capazes de ver energia veem a sua aura como a da lenda que te deu a Existência. Os mitos e contos não podem mais afetar os seus poderes." },
    ],
  },
  {
    id: "lenda",
    name: "Lenda",
    summary: "Deixou de portar um mito e passou a ser o mito.",
    description: [
      "Lenda é a origem de quem deixou de portar um mito e passou a ser o mito. Não há separação entre indivíduo e entidade: nome, história e poder se fundem, moldados pela forma como o mundo os comenta. Quanto mais sua existência é reconhecida, mais estável fica sua força.",
      "Esse poder depende da memória coletiva. Uma Lenda enfraquece quando é esquecida, desacreditada ou reduzida a boato sem impacto. Ela não vive só no corpo, mas na narrativa: existir é ser contado.",
    ],
    traits: [
      { name: "Contos e Mitos", kind: "habilidade", text: "O jogador escreve duas histórias: a do personagem e a que se conta de boca em boca sobre ele. Dessas histórias nascem o conceito e as habilidades." },
      { name: "Pactos e Maldições", kind: "habilidade", text: "Pode firmar pactos, conceder bênçãos e amaldiçoar pessoas — mas nunca fazer contrato com outra lenda. Ver o capítulo de Pactos, Bênçãos e Maldições." },
      { name: "Aparição", kind: "passiva", text: "Para que ninguém descubra a existência das lendas, elas se escondem entre as pessoas. Um personagem Lenda pode escolher não aparecer para os cegos." },
    ],
  },
  {
    id: "prodigio",
    name: "Prodígio",
    summary: "Humano que nasceu capaz de perceber e enfrentar o sobrenatural sem pactos.",
    description: [
      "Prodígios são humanos que nasceram capazes de perceber e enfrentar o sobrenatural sem pactos, heranças ou fusões. O poder é inato, moldado pela própria vontade. Ele não empresta o corpo nem divide a mente: impõe sua presença ao mundo espiritual.",
      "Com o tempo, cada Prodígio escolhe um Caminho, que define como esse poder se manifesta: a Engrenagem, unindo tecnologia ao espiritual; o Arsenal, onde as armas se tornam extensões do corpo; ou o Pacto, focado em contratos e itens mágicos sem submissão. Seja qual for a escolha, todo Prodígio caminha perto de um limite perigoso: quanto mais poder conquista, mais longe fica de uma vida comum.",
    ],
    traits: [
      { name: "Combatente de Guerra", kind: "passiva", text: "Toda arma que o Prodígio usa causa +1 dado de dano. O bônus cresce a cada 5 níveis: +1 dado no nível 1, +2 no nível 5, +3 no nível 10, e assim em diante." },
      { name: "Progressão do Prodígio (regra do site)", kind: "regra", text: "Ao subir de nível, recebe 1d12+2 de PV e não rola PC. Tem prioridade sobre a progressão da classe." },
    ],
    overridesProgression: true,
    paths: [
      {
        id: "arsenal",
        name: "Caminho do Arsenal",
        traits: [
          { name: "Arma Favorita", kind: "habilidade", text: "Escolhe um tipo de arma para se especializar e recebe a perícia dela de graça — uma pistola concede arma de fogo, por exemplo." },
          { name: "Técnicas Avançadas", kind: "progressao", text: "A cada nível par, aprende uma técnica da lista de técnicas e a mantém em seu arsenal.", minLevel: 2 },
          { name: "Modificada", kind: "regra", text: "A arma inicial do arsenal tem 2 modificadores à escolha do jogador, e ele pode, uma vez por descanso longo, adicionar um modificador temporário na arma (dura uma luta e deve ser colocado em cena de interlúdio)." },
        ],
      },
      {
        id: "engrenagem",
        name: "Caminho da Engrenagem",
        traits: [
          { name: "Tecnologia Perfeita", kind: "progressao", text: "Cria um instrumento tecnológico de luta — armadura, arma, prótese. A cada nível par, cria uma habilidade ligada a ele." },
          { name: "Ferramenta Autoral", kind: "passiva", text: "A ferramenta foi moldada para servir só a ele: toda rolagem de ataque recebe −15 como vantagem." },
          { name: "Tecnólogo", kind: "habilidade", text: "Gastando uma cena de interlúdio ou um descanso longo, constrói um dispositivo de função específica: um disco que cura, uma algema que não quebra, escutas intracranianas." },
        ],
      },
      {
        id: "pacto",
        name: "Caminho do Pacto",
        traits: [
          { name: "Vínculo Primordial", kind: "habilidade", text: "Começa com um pacto de lenda: selada em uma arma ou objeto, ou ligada fisicamente a ele, podendo ser invocada para lutar ao seu lado." },
          { name: "Xamã", kind: "progressao", text: "Uma vez por turno — mais uma a cada dois níveis ímpares — usa dois objetos de pacto ao mesmo tempo: duas espadas, duas máscaras, uma de cada." },
          { name: "Mestre de Selos", kind: "habilidade", text: "Começa com 5 selos capazes de copiar a habilidade de qualquer criatura — exceto Prodígios e a forma base do Artificial. Refaz selos em ações de interlúdio, até o limite de 5." },
        ],
      },
    ],
  },
];

export const ORIGIN_BY_ID: Record<string, OriginDef> = Object.fromEntries(ORIGINS.map((o) => [o.id, o]));

/** Combatente de Guerra: +1 dado no nível 1, +1 a cada 5 níveis. */
export function prodigioExtraWeaponDice(level: number): number {
  return 1 + Math.floor(level / 5);
}
