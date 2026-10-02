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
    Probabilidade
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
  = Combinatória
]

#pagebreak()

Antes de passarmos para os conteúdos mais complexos de probabilidade (que na minha opinião são mais fáceis que combinatória), vamos revisar alguns conceitos de probabilidade do ensino médio (eu não tive isso no ensino médio, mas me disseram que se vê lá né)

== Contagem
No tópico de contagem, duas coisas vão ser muito importantes para nós, o princípio fundamental da contagem e a estratégia de abordagem de problemas.

#theorem("Princípio Fundamental da Contagem")[
  Dada uma decisão $D_1$ com $x$ escolhas, e uma decisão *consecutiva* $D_2$ com $y$ escolhas, de forma que cada decisão $x$ tomada tem $y$ opções disponíveis, o número total de maneiras de realizar ambas as decisões é $x dot y$.
]
#proof[
  Vamos demonstrar por _indução_. Para uma única etapa (caso base), existem exatamente $a_1$ opções. Suponha que para $n$ etapas, o número de maneiras de realizar todas as decisões seja $a_1 dot ... dot a_n$. Agora vamos adicionar uma nova decisão $D_(n+1)$ com $a_(n+1)$ escolhas. Se visualizarmos as primeiras $n$ decisões como uma única decisão com $a_1 dot ... dot a_n$ possibilidades, então o número total de maneiras de realizar todas as decisões é $(a_1 dot ... dot a_n) dot a_(n+1) = a_1 dot ... dot a_n dot a_(n+1)$, como queríamos demonstrar.
]

Isso nos tráz uma estratégia de abordagem de problemas bem definida
- *Postura*: Sempre colocar no papel o que se sabe e o que se quer, e tentar organizar as informações de forma a facilitar a visualização do problema.
- *Divisãu*: Sempre que possível, dividir o problema em subproblemas menores, e resolver cada um deles separadamente.
- *Não adiar dificuldades*: Se uma das decisões a serem tomadas for mais restrita que as demais, esta deve ser tomada primeiro, para que as demais decisões possam ser tomadas com mais liberdade.

== Permutação
Usamos a permutação para saber de quantas maneiras podemos organizar um conjunto de elementos de forma ordenada.

#definition([Permutação de elementos *distintos*])[
  Se temos $n$ elementos distintos, o número de maneiras de organizá-los em uma sequência ordenada é dado por
  $
    P_n = n! = n dot (n-1) dot ... dot 2 dot 1
  $
]

#example[
  Quantos anagramas existem na palavra _"VIDRO"_? A palavra _"VIDRO"_ possui 5 letras distintas, então o número de anagramas é $5! = 5 dot 4 dot 3 dot 2 dot 1 = 120$.
]

Mas essa situação é um pouco mais complicada quando temos elementos repetidos, como na palavra _"MAMÃO"_. Nesse caso, temos 5 letras, mas a letra _"A"_ se repete 2 vezes.

#definition([Permutação de elementos *distintos*])[
  Se temos $n$ elementos, dos quais $n_1$ são idênticos, $n_2$ são idênticos, ..., $n_k$ são idênticos, o número de maneiras de organizá-los em uma sequência ordenada é dado por
  $
    P_(n)^(n_1, n_2, ..., n_k) = frac(n!, n_1! dot n_2! dot ... dot n_k!)
  $
]

Vamos tentar pensar no porquê dessa fórmula! Imagina que eu tenho uma palavra qualquer, e nela eu tenho DUAS letras repetidas. Se eu fixo uma das letras em um lugar, a outra letra pode ir para qualquer posição da palavra. No entanto, se eu fixo a segunda letra, a primeira *também* pode ir para qualquer posição, e eu acabo contando as *mesmas* palavras duas vezes. Por exemplo:
$
  bold(A) B C A -> A B C bold(A)
$
mesma palavra, mas com as posições do $A$ trocadas, logo, foi contabilizada duas vezes. Se eu tivesse $3$ letras repetidas, eu teria contado a mesma palavra $3!$ vezes, e assim por diante. Por isso, para corrigir isso, eu divido pelo fatorial do número de letras repetidas.

#example[
  Quantos anagramas existem na palavra _"MAMÃO"_? A palavra _"MAMÃO"_ possui 5 letras, das temos $2$ letras _"A"_ e $2$ letras _"M"_ repetidas, então o número de anagramas é
  $
    P_5^(2, 2) = 5! / (2! dot 2!) = 120 / (2 dot 2) = 30
  $
]

== Arranjos
Dado um grupo de $n$ elementos, eu quero selecionar $k$ elementos distintos e organizá-los em uma sequência ordenada, de forma que, ao trocar a ordem dos elementos, eu obtenha uma *sequência diferente*. Por exemplo, se eu quiser saber, dentro dos meus *competidores*, quantas combinações possívels de *primeiro*, *segundo* e *terceiro* lugar existem, se eu troco o *primeiro* pelo *segundo*, então vira uma sequência diferente, e portanto, é um arranjo diferente.

#definition([Arranjo de tamanho $k$ para $n$ elementos])[
  O arranjjo de tamanho $k$ para $n$ elementos distintos é dado por
  $
    A_(n)^k = n (n-1) ... (n-k+1) = frac(n!, (n-k)!)
  $
]

Por que seria essa fórmula? Bom, se eu tenho $n$ elementos, para o primeiro elemento da sequência eu tenho $n$ opções. Para o segundo elemento, eu já usei um elemento, então eu tenho $n-1$ opções. Para o terceiro elemento, eu já usei dois elementos, então eu tenho $n-2$ opções. E assim por diante, até que eu tenha escolhido $k$ elementos. Então, o número total de maneiras de escolher e organizar esses $k$ elementos é dado pelo produto $n (n-1) ... (n-k+1)$.

== Combinações
Dado um grupo de $n$ elementos, eu quero selecionar $k$ elementos distintos, mas agora a ordem não importa. Por exemplo, se eu quero saber a combinação de ingredientes para o meu sanduíche, se eu coloco o *hamburguer* antes do *queijo*, ou o *queijo* antes do *alface*, isso não faz diferença nenhuma.

#definition([Combinação de $n$ elementos escolhendo $k$])[
  O número de combinações de $n$ elementos distintos escolhendo $k$ elementos é dado por
  $
    C_(n)^k = frac(n!, k! dot (n-k)!) = frac(A_(n)^k, k!) = mat(n ; k)
  $
]

A lógica aqui é montarmos justamente o arranjo anterior, primeiro calculamos de quantas formas podemos organizar $k$ elementos onde a *ordem* influencia na contagem. Depois disso, queremos compensar as contagens extras que realizamos, ou seja, se eu tenho $k$ elementos, eu posso organizá-los de $k!$ formas diferentes, e todas essas formas são a mesma combinação. Então, para compensar isso, dividimos pelo fatorial de $k$.

== Permutação Circular
De quantas formas podemos organizar $n$ elementos distintos em um círculo? Para isso usamos a permutação circular.

#definition([Permutação circular de $n$ elementos])[
  A permutação circular de $n$ elementos distintos é dada por
  $
    P_n^"circ" = (n-1)!
  $
]

Para entender melhor a lógica vamos para um exemplo. Suponha que eu tenho $5$ pessoas, $A$, $B$, $C$, $D$ e $E$. Vamos agora organizar elas em um circulo.
$
  A -> B -> C -> D -> E -> A
$
perfeito! Mas e se eu organizar elas assim?
$
  B -> C -> D -> E -> A -> B
$
percebe que é a mesma organização, só que com outro ponto de referência? Então, para cada permutação linear de $n$ elementos, existem $n$ permutações circulares equivalentes. Por isso, para calcular a permutação circular, dividimos a permutação linear por $n$, ou seja, $P_n^"circ" = frac(P_n, n) = frac(n!, n) = (n-1)!$.


#pagebreak()

#align(center+horizon)[
  = Primeiros passos em Probabilidade
]

#pagebreak()

== Conjuntos
Toda a teoria de probabilidade é construída em cima da teoria de conjuntos, então muitos teoremas de probabilidade são apenas teoremas de conjuntos aplicados a eventos.

#definition([Espaço Amostral])[
  O espaço amostral $S$ é o conjunto de todos os resultados possíveis de um experimento aleatório.
]

#definition([Evento])[
  Um evento $E$ é um subconjunto do espaço amostral $S$, ou seja, $E subset.eq S$.
]

#corollary()[
  Dado $S$ um espaço amostral e $A,B subset.eq S$ sendo eventos em $S$, temos que
  + $A union B$ é o evento onde *ou* $A$ *ou* $B$ ocorrem.
  + $A inter B$ é o evento onde *ambos* $A$ *e* $B$ ocorrem.
  + $A^c$ é o evento onde $A$ *não* ocorre.
]

#example[
  Dada uma moeda, jogamos ela $10$ vezes (cada jogada é *independente*), então, se for *cara*, é $1$ e se for coroa é $0$. Escrevemos então a jogada como uma sequência de $10$ bits, onde cada bit é $0$ ou $1$.
  $
    (1,0,0,1,1,0,1,0,0,1)
  $
  vejamos algums eventos:
  - Jogada $i$ ser cara e o resto ser coroa
  $
    A_i = {(...,1,...) "tal que" 1 "está na posição" i "e" i in {1,2,...,10}}
  $
  - Ao menos uma jogada ser cara
  $
    B = union_(i=1)^(10) A_i
  $
  - Todas as jogadas são cara
  $
    C = inter_(i=1)^(10) A_i
  $
]
