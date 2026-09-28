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
    Processamento de Linguagem Natural
  ]
  
  #text(14pt)[
    Revisão para A1
  ]
]

#align(bottom + center)[
  Rio de Janeiro

  2026
]

#pagebreak()

// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

#align(center + horizon)[
  = Estudo formal da linguagem natural
]

#pagebreak()

A linguagem natural é a forma de comunicação utilizada pelos seres humanos, que evoluiu ao longo do tempo e é caracterizada por sua complexidade, ambiguidade e capacidade de expressar ideias abstratas. O estudo formal da linguagem natural envolve a aplicação de métodos matemáticos e computacionais para analisar, modelar e compreender a estrutura e o significado das línguas humanas.

Em geral, existem alguns níveis de representação da linguagem natural que são estudados formalmente:
1. *Fonologia*: Estuda os sons da fala e como eles se organizam em sistemas fonológicos. A fonologia analisa os fonemas, que são as unidades mínimas de som que podem diferenciar significados em uma língua.
2. *Morfologia*: Analisa a estrutura das palavras e como elas são formadas a partir de morfemas, que são as menores unidades de significado. A morfologia estuda processos como a derivação, a flexão e a composição de palavras.
3. *Sintaxe*: Examina a organização das palavras em frases e sentenças, estabelecendo regras que determinam a ordem e a hierarquia das palavras. A sintaxe busca compreender como as estruturas gramaticais são formadas e como elas contribuem para o significado das sentenças.
4. *Semântica*: Foca na interpretação do significado das palavras, frases e textos. A semântica estuda como os significados são construídos a partir das combinações de palavras e como o contexto influencia a compreensão do significado

Nessa matéria, não focamos em nada da fonologia e ignoramos a maior parte da morfologia, mas estudamos a sintaxe e a semântica de forma formal, utilizando ferramentas matemáticas e computacionais para analisar e modelar a linguagem natural. Vamos nos concentrar na forma linguística no nível dos sintagmas e das sentenças. Isso significa que começaremos pelas palavras como blocos de construção básicos. A tarefa principal será então desenvolver uma gramática que nos forneça noções de boa-formação sintática e de estrutura sintática, e que nos permita desenvolver a noção de significado para as estruturas bem formadas. Assim, nossas gramáticas

- devem ser capazes de construir exatamente aquelas expressões que são bem formadas na língua de nossa escolha;
- devem determinar os constituintes das expressões linguísticas complexas, bem como sua estrutura interna;
- e devem nos permitir atribuir significados apropriados às expressões sintaticamente bem formadas, com base em sua estrutura;

Em outras palavras, a noção de boa-formação sintática nos permite determinar se uma expressão particular é de fato uma expressão bem formada de uma dada categoria, e determinar sua estrutura interna. A estrutura, por sua vez, ajudará a relacionar as formas linguísticas com o mundo extralinguístico

O livro online criado pelo professor da matéria, Alexandre Rademaker, descreve muito mais contexto no primeiro capítulo, no entanto não vamos abordar tudo aqui, para ler o livro, basta acessar o link: #link("https://emap-nlp.github.io/book/IntroL/#IntroL", "https://emap-nlp.github.io/book/IntroL/#IntroL")

