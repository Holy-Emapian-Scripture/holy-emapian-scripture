#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages, stroke: 1pt + luma(100))

#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx, cellx

#set page(width: 21cm, height: 30cm, margin: 1.5cm)

#set par(
  justify: true
)

#set figure(supplement: "Figura")

#set heading(numbering: "1.1.1")

#let theorem = thmbox("theorem", "Teorema")
#let corollary = thmplain(
  "corollary",
  "Corolário",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definição", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Exemplo").with(numbering: none)
#let proof = thmproof("proof", "Demonstração")

#set math.equation(
  numbering: "(1)",
  supplement: none,
)
#show ref: it => {
  // provide custom reference for equations
  if it.element != none and it.element.func() == math.equation {
    // optional: wrap inside link, so whole label is linked
    link(it.target)[(#it)]
  } else {
    it
  }
}

#set text(
  font: "Atkinson Hyperlegible",
  size: 12pt,
)

#show heading: it => {
  if it.level == 1 {
    [
      #block(
        width: 100%,
        height: 1cm,
        text(
          size: 1.5em,
          weight: "bold",
          it.body
        )
      )
    ]
  } else {
    it
  }
}


// ============================ PRIMEIRA PÁGINA =============================
#align(center + top)[
  FGV EMAp

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Modelagem Informacional
  ]
  
  #text(14pt)[
    Revisão para A2
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2025
]

#pagebreak()

// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

#align(center + horizon)[
  = Big Data
]

#pagebreak()

== Introdução
Na primeira parte do curso, nós vimos uma expansão dos conceitos de Banco de Dados, como eles eram expandidos dependendo da sua finalidade. Vimos a extensão de bancos operacionais para bancos analíticos (Data Warehouses) e sua estruturação e aqui não será diferente! Porém, antes de entender como estruturar novos dados, temos que entender os tipos de dados que vamos armazenar nessa parte do curso

Quando vamos trabalhar com conjuntos de dados, podemos categorizar eles em 3 tipos
- Bancos operacionais
- Data Warehouses
- Big Data

E é exatamente essa terceira que iremos abordar.  Big Data são os conjuntos de dados em corporações que tem grande volume e diversificação, além de rápido crescimento. Não são modelados formalmente para consulta e recuperação e não são acompanhados de metadados detalhados

Ou seja, são aqueles tipos de dados que não são bem estruturados. Podemos fazer uma sub-divisão também nessa classificação:
- *Não-estruturados*: Não tem metadados detalhados, exemplo: Documentos de Texto
- *Semi-estruturados*: Possuem alguns metadados, mas não o suficiente para descrever completamente o dado num todo, exemplo: Mensagens de texto (Você tem estruturas de destinatário, remetente, horário, etc., mas o texto da mensagem em si não tem uma estruturação)

A gente pode tentar descrever Big Data com o que chamamos de V's. Porém, essa descrição não é algo $100%$, já que esse conteúdo e o que é ou não um dado de Big Data vai bastante do contexto e da interpretação

- *Volume*
- *Variedade* (Fontes)
- *Velocidade* (Entrada dos dados)
- *Veracidade* (Qualidade)
- *Variabilidade* (Interpretação)
- *Value*
- *Visualization* (Elaborada e complexa)

#definition("Big Data")[
  Grandes volumes de conjuntos de dados diversificados e de crescimento rápido que, quando comparados com bancos operacionais ou data warehouses:
  - Consideravelmente menos estruturados (Poucos ou nenhum metadado)
  - No geral: $+$Volume, $+$Velocidade, $+$Variabilidade
  - Mais problemas na qualidade dos dados (Veracidade)
  - Maiores as gamas de interpretações (Variabilidade)
  - Abordagem mais exploratória e experimental para gerar Valor
  - Se beneficia mais com visualizações elaboradas e inovadoras
]

== MapReduce e Hadoop
Certo, mas se Big Data são dados não-estruturados, o que podemos fazer para lidar com eles? É uma selva sem lei? Na verdade não, existem algumas alternativas! É aí que entram abordagens como *MapReduce*, que se divide em duas etapas:

+ *Map* $->$ Mapeia cada registro em um par chave-valor
+ *Reduce* $->$ Reúne todos os registros com a mesma chave e gera uma única para cada chave

E o Hadoop é uma implementação OpenSource do MapReduce. O melhor meio de entender o MapReduce é com um exemplo:

#example("Contagem de Palavras")[
  Vamos imaginar que temos um repositório com milhares de documentos e queremos contar a quantidade de palavras de cada um, será que há um meio de agilizar esse processo? Ou eu vou ter que passar os documentos 1 por 1? Com o MapReduce, esse problema fica computacionalmente viável e eficiente!

  #figure(
    image("images/mapreduce.png"),
    caption: [MapReduce no contexto de contagem de palavras]
  )

  Nós passamos um ou mais documentos para nosso MapReduce, então ele divide (Seja por linha, parágrafo, etc., na nossa imagem de exemplificação, está separando por linha), e cada divisão é enviada para um node (Fase Split), onde cada node está fazendo o mapeamento das palavras em pares de chave e valor independentemente (Como se cada node fosse um computador separado), então pegamos aqueles valores que possuem chaves iguais (No nosso caso, todas as contagens de cada palavra), e então fazemos o processo de combinar todas em um único par chave-valor de acordo com o contexto. No nosso caso, vamos somar todos os valores para obter todas as quantidades de repetição daquela palavra, obtendo no final, a contagem total de todas as palavras
]

== Data Lake
Certo, então como que deve ser o processo de tratamento de um problema envolvendo Big Data? Algo muito errado, mas comum, que acontece, é tratar o problema de Big Data como algo separado e distinto, mas ele ta incluso em todo um contexto de problema de dados, na verdade, o mesmo vale para os bancos operacionais e data warehouses! A empresa sempre deve analisar quais tipos de dados são adequados para cada conjunto de dados e fazer sua estruturação e planejamento tendo isso em mente

Certo, dito isso, uma dúvida vem na mente. Os dados operacionais tem seus bancos de dados próprios, os analíticos são extraídos dos data warehouses, e o big data, onde fica?

#definition("Data Lake")[
  Grande pool de dados não-estruturados (Até o momento da consulta). Dados brutos em seu formato nativo até necessário
  - Esquema sob-demanda
  - Usuários devem transformar os dados antes da análise
]

#figure(
  image("images/dw-structure.png"),
  caption: [Estrutura e fluxo dos dados em um ecossistema Data Warehouse]
)

#figure(
  image("images/data-lake-structure.png"),
  caption: [Estrutura e fluxo dos dados em um ecossistema Data Lake]
)

Como falamos, Big Data não é estruturado, então não há transformação dos dados ao serem colocados no Data Lake

#figure(
  image("images/large-analytical-data-repositories.png"),
  caption: [Descrição da melhor solução de repositório de dados para seu problema baseado em características do mesmo]
)
