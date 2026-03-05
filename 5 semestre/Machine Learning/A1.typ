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

  João Pedro Jerônimo e Eduardo Adame
]

#align(horizon + center)[
  #text(17pt)[
    Aprendizado de Máquina
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

#block(
  width: 100%,
  fill: rgb(255, 148, 162),
  inset: 1em,
  stroke: 1.5pt + rgb(117, 6, 21),
  radius: 5pt
)[
  *Nota*: Esse resumo é uma adaptação das notas da disciplina disponibilizadas pelo veterano Eduardo Adame, para acessar as notas originais, acesse #link("https://drive.google.com/drive/folders/1Rg2rzPukCe4-IDpu6agLrJ-e1S7EwWQA?usp=share_link", "aqui")
]

// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

#align(center + horizon)[
  = Método dos Vizinhos mais próximos (k-NN)  
]

#pagebreak()

== Introdução Intuitiva
O método dos vizinhos mais próximos (k-NN) é um algoritmo de aprendizado de máquina simples e eficaz usado para classificação e regressão. Ele funciona com base na ideia de que objetos semelhantes estão próximos uns dos outros no espaço de características. Para classificar um novo ponto, o k-NN identifica os k pontos mais próximos no conjunto de treinamento e atribui a classe mais comum entre esses vizinhos ao novo ponto.

O valor de k é um hiperparâmetro que pode ser ajustado para melhorar o desempenho do modelo. O k-NN é fácil de entender e implementar, mas pode ser computacionalmente caro para grandes conjuntos de dados, pois requer o cálculo das distâncias entre o novo ponto e todos os pontos do conjunto de treinamento.

Um das hipóteses fundamentais em ML é que existe algum nível de suavidade no mapeamento entre o espaço de entrada $cal(X)$ e o de saída $cal(Y)$. Em outras palavras, se dois elementos $x, x' in cal(X)$ são semelhantes, então eles devem ter saídas $y, y' in cal(Y)$ similares. O método dos k vizinhos mais próximos (k nearest neighbors, k-NN), proposto por Cover e Hart (1967), aplica diretamente esse conceito.

Nesse capítulo, vamos estudar como k-NN pode ser usados para problemas de classificação e regressão. Discutiremos o impacto do k e também da escolha de distância (ou métrica) para o espaço $cal(X)$, que é primordial para a aplicação do método. Finalmente, estudaremos o comportamento do método k-NN quando a dimensionalidade do espaço $cal(X)$ é alta

== Treinamento
Seja $cal(T) = {x_1,...,x_N} subset cal(X)$ o conjunto de treinamento, e $cal(R) = {r_1,...,r_M} subset cal(Y)$ o conjunto de rótulos, o treinamento do método k-NN consiste em atribuir um ponto aleatório do espaço $cal(X)$ a cada um dos rótulos em $cal(R)$, esse ponto é considerado o centro do rótulo, e a ideia intuitiva é que vamos gerar vários grupinhos em que, se um novo ponto tiver no meio daquele grupinho, ele vai ser classificado com o rótulo daquele grupinho. A cada iteração, vamos escolher os $k$ pontos mais próximos de cada centro de rótulo, e classificar aqueles $k$ pontos com o rótulo daquele centro. O processo é repetido até que todos os pontos do conjunto de treinamento sejam classificados, ou seja, cada ponto do conjunto de treinamento tem um rótulo atribuído a ele.

Esse processo é simples de se feito, mas nem sempre converge, então nesse processo, pode acontecer de nenhum centro de rótulo convergir em grupinhos e o resultado não vai conseguir classificar os pontos corretamente. Vamos formalizar isso melhor então. Primeiro, vamos definir $V_k (x)$

#definition("Vizinhança de k vizinhos mais próximos")[
  Seja $cal(D) := {(x_1, y_1), ..., (x_N, y_N)} subset cal(X) times cal(Y)$ o conjunto de treinamento e $d: cal(D) times cal(D) -> RR^+ union {0}$ uma função de distância. A vizinhança de k vizinhos mais próximos de um ponto $x in cal(X)$ é definida como:
  $
    cal(V)_k (x) := { (x_i, y_i) in cal(D) : d(x, x_i) <= d(x, x_j), forall j != i } "e" |cal(V)_k (x)| = k
  $

  Perceba que a condição diz que qualquer ponto fora de $cal(V)_k (x)$ pode estar tão distante quanto o ponto mais distante dentro de $cal(V)_k (x)$.
]

#pseudocode-list(
  title: "Algoritmo de treinamento do método k-NN",
  booktabs: true
)[
  + *function* kNNTrain($cal(T)$, $cal(R)$, $k$) {
    + $cal(G) := {(g_j, r_j) in cal(X) | g_j "é aleatório e " j in {1,...,M}}$
    + *while* $cal(G)$ *não convergiu* {
      + *for* $(g_j, r_j)$ *in* $cal(G)$ {
        + calculamos $cal(V)_k (g_j)$
        + $g_j = "centro de" cal(V)_k (g_j)$
        + *for* $(x_i, y_i)$ *in* $cal(V)_k (g_j)$ {
          + $y_i = r_j$
        + }
      + }
    + }
  + }
]

No final desse algoritmo, obtemos um novo conjunto $cal(D)$ com as classificações, em teoria corretas (Pois o algoritmo pode não convergir para certos conjuntos), que poderá ser usado para classificar novos pontos

== Classificação
Seja $cal(D) := {(x_1, y_1), ..., (x_N, y_N)} subset cal(X) times cal(Y)$ o conjunto de treinamento (Já treinado e cada ponto $x_i in cal(X)$ classificado com um rótulo $y_i in cal(Y)$) e $d: cal(D) times cal(D) -> RR^+ union {0}$ uma função de *distância*. Vamos supor que queremos classificar um vetor $x in cal(X)$ arbitrário. 

O método k-NN classifica o vetor $x$ atribuindo a ele a classe mais comum entre os rótulos dos pontos em $cal(V)_k (x)$, ou seja:
$
  h(x) := "argmax"_{y in cal(Y)} sum_{(x_i, y_i) in cal(V)_k (x)} II_{y_i = y}
$
(De forma simplificada, o rótulo mais comum dentro do conjunto de vizinhos é o rótulo atribuído ao ponto $x$)

#figure(
  image("images/knn-classification.png"),
  caption: [Exemplo de classificação usando o método k-NN. O ponto $x$ é o ponto a ser classificado, os pontos azuis e vermelhos são os pontos do conjunto de treinamento, e as linhas tracejadas indicam as fronteiras de decisão do modelo. Aqui, se $k=5$, ele vai classificar como *Classe 1* (vermelho)]
)

== Regressão
O k-NN pode também ser empregado em problemas de regressão. Para isso, precisamos de
uma forma de combinar as saídas em $cal(V)_k(·)$. Uma das estratégias mais comuns consiste em
computar a média ponderada pelo inverso da distância:
$
  h(x) := 1/Z sum_((x', y') in cal(V)_k (x)) y' / d(x, x')

  wide

  Z := sum_((x', y') in cal(V)_k (x)) 1 / d(x, x')
$

permitindo que pontos mais próximos a $x$ exerçam maior influência no cômputo da predição $h(x)$. Ideia semelhante pode também ser aplicada a classificação.

Observe que o algoritmo k-NN não necessita de treinamento (quando os dados não vem classificados), ou equivalentemente, o treinamento consiste em simplesmente armazenar o conjunto de dados $cal(D)$. Por conta disso, k-NN é dito ser uma abordagem de lazy learning (Atkeson et al., 1997)
