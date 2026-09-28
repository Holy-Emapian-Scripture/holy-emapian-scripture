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
    Modelagem Estatística
  ]
  
  #text(14pt)[
    Revisão para A1
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
  = Inferência Aproximada - O valor de uma premissa
]

#pagebreak()

Quando estávamos estudando Inferência Estatística, vimos que, em geral, nosso ponto de partida era um modelo e um conjunto de dados, e nosso trabalho era fazer boas inferências sobre o conjunto de dados e os parâmetros do modelo. No entanto, o quão bom os resultados são depende do quão bem o modelo se encaixa aos dados, dessa forma, erros podem ocorrer se o modelo não se adequar aos dados. Já na Modelagem Estatística, o ponto de partida é um conjunto de dados, e nosso trabalho é encontrar um modelo que se encaixe bem aos dados, para isso testamos diversos modelos. Nesse primeiro tópico, vamos ver na prática alguns processos que podem ser feito sobre poucas premissas acerca do processo gerador de dados (DGP - Data Generating Process, é o processo que gera os dados, e é o que queremos modelar).

Para isso vamos analisar medições da concentração (em partes por milhão - ppm) de um composto químico em $n=10$ amostras de bateladas de um determinado produto. Para acessar o dataset, basta acessar o repositório do professor clicando [aqui](https://github.com/maxbiostat/stats_modelling/tree/master/data). O arquivo é um CSV, e as medições estão na coluna "ppm".

#codly()
```python
import pandas as pd
data = pd.read_csv("data/ppm.csv")
```
