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

== Conjuntos e Definição Ingênua de Probabilidade
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

#theorem("Lei de De Morgan")[
  Dado $S$ um espaço amostral e $A,B subset.eq S$ sendo eventos em $S$, temos que
  + $(A union B)^c = A^c inter B^c$
  + $(A inter B)^c = A^c union B^c$
]
#proof[
  Para a primeira igualdade, temos que provar que $(A union B)^c subset.eq A^c inter B^c$ e depois $A^c inter B^c subset.eq (A union B)^c$. Para a primeira parte, seja
  $
    x in (A union B)^c  <=> x in.not A union B
  $
  logo, $x in.not A$ e $x in.not B$, ou seja, $x in A^c$ e $x in B^c$, então $x in A^c inter B^c => (A union B)^c subset.eq A^c inter B^c$. Para a volta, seja $x in A^c inter B^c$, então $x in A^c$ e $x in B^c$, ou seja, $x in.not A$ e $x in.not B$, então $x in.not (A union B)$, ou seja, $A^c inter B^c subset.eq (A union B)^c$.

  Para a segunda igualdade, faremos o mesmo raciocínio. Seja $x in (A inter B)^c$ então $x in.not A inter B$, ou seja, $x$ não ocorre *simultaneamente* em $A$ e $B$, logo $x in.not A$ *ou* $x in.not B$, ou seja, $x in A^c$ *ou* $x in B^c$, então $x in A^c union B^c => (A inter B)^c subset.eq A^c union B^c$. Para a volta, seja $x in A^c union B^c$, então $x in A^c$ *ou* $x in B^c$, ou seja, $x in.not A$ *ou* $x in.not B$, logo $x in.not (A inter B)$, ou seja, $A^c union B^c subset.eq (A inter B)^c$.
]

Com todas essas definições, teoremas e revisão de contagem, nós conseguimos finalmente definir de maneira *informal* o que é a probabilidade de um evento ocorrer

#definition([Naive Probability Definition])[
  Dado um espaço amostral $S$ e um evento $E subset.eq S$, a probabilidade de $E$ ocorrer é dada por
  $
    PP(E) = frac(|E|, |S|)
  $
]

== Tabela Amostral e Demonstração por Interpretação
A tabela amostral é muito útil para organizar *quais ferramentas* de contagem utilizamos sob *determinadas condições* de um *experimento*

#set table(
  stroke: (x, y) => (
    y: 1pt,
    left: if x == 0 and y == 0 { 0pt } else { 1pt },
    right: if x == 0 and y == 0 { 0pt } else { 1pt},
    top: if x == 0 and y == 0 { 0pt } else { 1pt },
    bottom: if x == 0 and y == 0 { 0pt } else { 1pt }
  ),
)

#figure(
  table(
    columns: 3,
    rows: 3,
    align: center+horizon,

    [],[Ordem Importa],[Ordem não Importa],
    [Reposição],[$n^k$],[$mat(n+k-1 ; k)$],
    [Sem Reposição],[$n!/(n-k)!$],[$mat(n;k)$],
  )
)

Antes de continuarmos e mostrarmos algumas identidades interessantes para nos ajudar a resolver alguns problemas, vamos discorrer o porquê de cada uma das fórmulas mencionadas anteriormente.

=== Ordem Importa e Reposição
Se a ordem importa, então estamos lidando com arranjos. Se há reposição, então para cada elemento escolhido, ele volta para o conjunto de elementos disponíveis, ou seja, na primeira retirada, eu tenho $n$ elementos disponíveis, na segunda, eu ainda tenho $n$ pois o anterior foi colocado de volta, e assim por diante. Logo, o número de maneiras de escolher $k$ elementos com reposição é dado por $n^k$.

=== Ordem Importa e Sem Reposição
Estamos lidando literalmente com os arranjos como já vimos antes, então será a mesma fórmula do arranjo, ou seja, $n!/(n-k)!$.

=== Ordem não Importa e Sem Reposição
É exatamente o caso da combinação padrão que discutimos anteriormente, ou seja, $mat(n;k)$.

=== Ordem não Importa e Reposição
Esse caso é um pouco mais complicado. Você saber de quantas formas possíveis você pode escolher $k$ elementos de um conjunto de $n$ elementos, mas agora você pode escolher o mesmo elemento mais de uma vez, isso é equivalente a *perguntar de quantos jeitos diferentes é possível distribuir $k$ partículas independentes em $n$ caixas diferentes*, mas por quê? Isso não parece nada intuitivo.

Interprete uma associação, cada partícula é um *sorteio* e cada caixa é um *elemento do conjunto*. Quando eu falo *partícula $i$ vai ficar na caixa $p$*, isso quer dizer em termos do sorteio que, no $i$-ésimo sorteio, o elemento escolhido foi o $p$-ésimo elemento do conjunto. Então, se eu tenho $k$ partículas e $n$ caixas, isso é equivalente a dizer que eu tenho $k$ sorteios e $n$ elementos disponíveis para escolher. Como eu posso escolher um mesmo elemento mais de uma vez, isso é equivalente a dizer que eu posso colocar mais de uma partícula na mesma caixa. Para fazer o cálculo de fato, utilizamos a abordagem de pontos e traços, tenha em mente a seguinte divisão
$
  dot dot dot \/ dot \/ dot dot dot \/ dot \/ dot
$
Essa representação é o mesmo que dizer que na primeira caixa, eu tenho $3$ partículas, na segunda eu tenho $1$ e assim em diante, a quantidade de pontos entre os traços representa a quantidade de partículas em cada caixa. Como temos $k$ partículas, temos $k$ pontos, e como temos $n$ caixas, temos $n-1$ traços. Logo, o número total de maneiras de organizar esses pontos e traços vai ser o número de maneiras de escolher $k$ pontos dentre todos os $k+n-1$ elementos, ou seja, $mat(n+k-1 ; k)$.

== Teoremas Úteis
Aqui nós vamos mostrar alguns teoremas que serão muito úteis para nós na hora de resolver problemas de probabilidade. Suas demonstrações não serão algébricas, mas sim por interpretação, ou seja, vamos interpretar o que cada lado da equação significa e mostrar que eles são equivalentes.

#theorem[
  $
    n mat(n-1 ; k-1) = k mat(n ; k)
  $
]
#proof[
  Queremos saber de quantas formas podemos escolher $k$ pessoas de um grupo de $n$ pessoas, e dentre essas $k$ pessoas, queremos escolher uma pessoa para ser o *líder*.

  No lado direito da igualdade, quando fazemos
  $
    k mat(n ; k)
  $
  primeiro fazemos a contagem de quantas formas podemos escolher $k$ pessoas de um grupo de $n$ pessoas (combinação) e, dentro dessas $k$, quantas podem ser o *líder*.

  Já no lado esquerdo, quando fazemos
  $
    n mat(n-1 ; k-1)
  $
  primeiro eu vou escolher o *líder* do grupo dentre as $n$ pessoas, e das $n-1$ que sobraram, eu vou montar um grupo de $k-1$ para completar $k$ com o líder que eu escolhi.
]

#theorem([Identidade de Vandermonde])[
  $
    mat(m + n ; k) = sum_(j=0)^k mat(m ; j) mat(n ; k-j)
  $
]
#proof[
  Eu quero escolher $k$ pessoas de um grupo de $m+n$ pessoas. Eu posso dividir esse grupo em dois subgrupos, um com $m$ pessoas e outro com $n$ pessoas. Depois disso, posso dividir em duas etapas, primeiro eu escolho $j$ pessoas do grupo de $m$ pessoas, e depois eu escolho $k-j$ pessoas do grupo de $n$ pessoas, assim completo um grupo de $k$ pessoas. Como $j$ pode variar de $0$ até $k$, eu somo todas as possibilidades, e assim obtenho a *Identidade de Vandermonde*.
]

== Problema do Aniversário
Que tal resolvermos um problema bem paradoxal para estimular nosso pensamento *probabilistico*? O problema do aniversário é o seguinte: qual a probabilidade de, em um grupo de $n$ pessoas, *pelo menos* duas delas fazerem aniversário no mesmo dia? Parece que para que isso aconteça, o grupo precisa ser grande, mas não é bem assim. Antes de resolvermos o problema, vou enunciar um teorema que será útil para provar o caso mais óbvio.

#theorem([Princípio da Casa dos Pombos])[
  Se $n$ pombos são colocados em $m$ casas, e $n > m$, então *pelo menos* uma casa terá mais de um pombo.
]

Agora podemos enunciar as etapas da resolução do problema! Primeira coisa que fazemos é *remover as restrições*. Uma delas é o dia $29$ de fevereiro, que só ocorre em anos bissextos, então vamos *desconsiderar* esse dia. Outro ponto é que *cada dia* tem a *mesma chance* de ocorrer e são eventos *independentes*. Nessa situação, o mais fácil é calcular a probabilidade do evento *contrário*, ou seja, a probabilidade de que *todos do grupo tem aniversários diferentes*.
$
  PP("todos diferentes") = 365 / 365 dot 364 / 365 dot 363 / 365 ... dot (365-k+1) / 365 = frac(365! / (365-k)!, 365^k)
$

Aqui, nós vamos no racicínio que o primeiro aniversariante tem $365$ opções, o segundo tem $364$ opções, o terceiro tem $363$ opções e assim por diante, até que o último aniversariante tenha $365-k+1$ opções. Como cada pessoa tem $365$ opções, então o número total de possibilidades é $365^k$. Logo, a probabilidade de *pelo menos* duas pessoas fazerem aniversário no mesmo dia é
$
  PP("pelo menos dois iguais") = 1 - PP("todos diferentes") = 1 - frac(365! / (365-k)!, 365^k)
$

Quando $k = 23$, a probabilidade de que *pelo menos* duas pessoas façam aniversário no mesmo dia é de aproximadamente $50%$.

== Propriedades da Probabilidade
Dado toda a introdução que fizemos, podemos agora enunciar algumas propriedades da probabilidade que serão muito úteis. Antes, precisamos saber dos seguintes axiomas:
$
  PP(emptyset) = 0 wide PP(S) = 1 wide PP(A) >= 0   \

  PP(union.big_(n=1)^infinity A_n) = sum_(n=1)^infinity PP(A_n) wide -> A_i inter A_j = emptyset quad forall i != j
$

Agora podemos enunciar as propriedades e suas demonstrações

#theorem[
  $
    PP(A^c) = 1 - PP(A)
  $
]
#proof[
  $
    1 = PP(S) <=> 1 = PP(A^c union A)    \
    
    <=> 1 = PP(A^c) + PP(A) <=> PP(A^c) = 1 - PP(A)
  $
]

#theorem[
  Se $A subset.eq B$, então $PP(A) <= PP(B)$
]
#proof[
  Montamos $B$ como $A union (B inter A^c)$, se montarmos dessa forma, $A$ e $(B inter A^c)$ são disjuntos. Antes de prosseguirmos, aqui está uma figura que ilustra a situação

  #figure(
    image("images/A1/sets.png", width: 100%),
    caption: [Ilustração da relação entre os conjuntos $A$ e $B$]
  )

  Dito isso, podemos então escrever:
  $
    PP(B) = PP(A union (B inter A^c)) = PP(A) + PP(B inter A^c) >= PP(A)
  $
]

#theorem[
  $
    PP(A union B) = PP(A) + PP(B) - PP(A inter B)
  $
]
#proof[
  Montamos $A union B$ como $A union (B inter A^c)$, se montarmos dessa forma, $A$ e $(B inter A^c)$ são disjuntos.

  Dito isso, podemos então escrever:
  $
    PP(A union B) = PP(A) + PP(B inter A^c)
  $

  Temos então que mostrar que
  $
    PP(B inter A^c) = PP(B) - PP(A inter B)
  $
  para isso, vamos mostra que, $(B inter A^c) union (A inter B) = B$. Para provar isso, vamos mostrar que $(B inter A^c) union (A inter B) = B inter (A union A^c)$. Se $x in B$, então $x in A$ *ou* $x in.not A$, logo, $x in S$, dessa forma
  $
    x in B inter (A union A^c) <=> x in B inter S <=> x in B
  $
  e temos que $B inter A^c$ e $A inter B$ são disjuntos, logo
  $
    PP(B) = PP((B inter A^c) union (A inter B)) = PP(B inter A^c) + PP(A inter B)    \
    
    <=>   \
    
    PP(B inter A^c) = PP(B) - PP(A inter B)
  $
]

#theorem[
  $
    PP(A union B union C) = &PP(A) + PP(B) + PP(C)   \
    - &PP(A inter B) - PP(A inter C) - PP(B inter C)    \
    + &PP(A inter B inter C)
  $
]

== Eventos Independentes
Dois eventos $A$ e $B$ são independentes se a ocorrência de um não afeta a probabilidade do outro.

#definition([Eventos Independentes])[
  Dois eventos $A$ e $B$ são independentes quando
  $
    PP(A inter B) = PP(A) dot PP(B)
  $
]

muitas vezes é difícil achar uma formulação rigorosa para mostrar que dois eventos são independentes sem uma tabela registrada das probabilidades, mas a *intuição* é um grande aliado nesses casos. Por exemplo, se eu jogo uma moeda e um dado, a ocorrência de *cara* na moeda não afeta a probabilidade de sair $6$ no dado (desde que ambos sejam justos), então esses dois eventos são *independentes*.

#pagebreak()

#align(center+horizon)[
  = Probabilidade Condicional
]

#pagebreak()

== Como o Conhecimento influencia na Probabilidade
Em probabilidade, conseguimos utilizar conhecimento prévio para atualizar as nossas previsões, por exemplo, se eu sei que nas últimas 10 jogadas de um dado, o número 6 saiu 8 vezes, então a *dependendo* das minhas *premissas* (por exemplo, eu não tenho garantia que o dado é justo), eu posso atualizar a minha previsão e dizer que eu tenho uma change grande de cair $6$ novamente.

#example[
  Ao jogarmos um dado justo $2$ vezes, dado que eu sei que a soma de ambos os valores que caíram é $6$, qual é a probabilidade de que o primeiro valor seja $2$? Sabemos que a soma de ambos os valores que caíram é $6$, então o espaço amostral é reduzido para
  $
    (1,5), (2,4), (3,3), (4,2), (5,1)
  $
  dentro das possibilidades, a probabilidade vai ser
  $
    PP("primeiro valor é 2" | "soma é 6") = frac(1,5)
  $
]

#definition([Probabilidade Condicional])[
  Dado um espaço amostral $S$ e dois eventos $A,B subset.eq S$, a probabilidade de $A$ ocorrer dado que $B$ ocorreu é dada por
  $
    PP(A | B) = frac(PP(A inter B), PP(B))
  $
]

#theorem[
  Se $A$ e $B$ são independentes, então
  $
    PP(A | B) = PP(A)
  $
]
#proof[
  Pela definição:
  $
    PP(A | B) = PP(A inter B) / PP(B)
  $
  Como são independentes:
  $
    PP(A | B) = (PP(A) dot PP(B)) / PP(B) = PP(A)
  $
]

#example[
  Voltando no exemplo do dado com soma $6$, vamos separar o problema em dois eventos para aplicar a definição de probabilidade condicional. Seja $A$ o evento de que o primeiro valor seja $2$, e seja $B$ o evento de que a soma dos valores seja $6$. Então, temos que
  $
    PP(B) = 5/36 quad PP(A inter B) = 1/36
  $
  então aplicando a definição:
  $
    PP(A | B) = PP(A inter B) / PP(B) = (1/36) / (5/36) = 1/5
  $
]


== O Teorema de Bayes
#theorem[
  $
    PP(A inter B) = PP(A | B) dot PP(B) = PP(B | A) dot PP(A)
  $
]<intersection-and-conditional-equality>
#proof[
  Sabemos que $PP(A inter B) = PP(B inter A)$, manipulando então a definição de probabilidade condicional, temos que
  $
    PP(A|B) = PP(A inter B) / PP(B) <=> PP(A inter B) = PP(A | B) dot PP(B)
  $
  e
  $
    PP(B|A) = PP(B inter A) / PP(A) <=> PP(B inter A) = PP(B | A) dot PP(A)
  $
]

#theorem([Teorema de Bayes])[
  Sejam $A$ e $B$ dois eventos, então temos que
  $
    PP(A | B) = frac(PP(B | A) dot PP(A), PP(B))
  $
]<bayes-theorem>
#proof[
  Aplicando o @intersection-and-conditional-equality, temos que
  $
    PP(A|B) = frac(PP(A inter B), PP(B)) = frac(PP(B | A) dot PP(A), PP(B))
  $
]

Pode não parecer, mas esse é um dos teoremas *mais importantes* da probabilidade, mas também um dos que gera *mais confusão*. Vamos considerar, por exemplo, um exame que vai me dizer se *tenho malária*. Vamos supor também que
- Apenas $1%$ da população tem malária
- O teste acerta $99%$ dos doentes
- O teste acerta $99%$ dos saudáveis

Analisando rapidamente, se o teste der positivo, isso parece falar que *a chance de eu ter malária é de $99%$*, mas isso *não é verdade*. Nós queremos calular
$
  PP("Doente"|"Positivo")
$
pelo @bayes-theorem, temos que
$
  PP("Doente"|"Positivo") = frac(PP("Positivo"|"Doente") dot PP("Doente"), PP("Positivo")) = frac(0.99 dot 0.01, PP("Positivo"))
$
para calcular $PP("Positivo")$, vamos usar a lei da probabilidade total (vamos enunciar ela mais formalmente depois), mas ela diz que podemos expressar essa probabilidade como
$
  PP("Positivo") &= PP("Positivo"|"Doente") dot PP("Doente") + PP("Positivo"|"Saudável") dot PP("Saudável")   \
  
  &= 0.99 dot 0.01 + 0.01 dot 0.99 = 0.0198
$
voltando para a fórmula anterior
$
  PP("Doente"|"Positivo") = frac(0.99 dot 0.01, 0.0198) = 0.5
$
então se eu sei que meu teste deu positivo, na verdade, a chance de eu ter malária é de apenas $50%$, e não $99%$ como parecia inicialmente. Isso é um exemplo clássico de como o Teorema de Bayes nos ajuda a atualizar nossas previsões com base em informações novas.

=== Falácia do Promotor
Um caso muito famoso onde essa confusão teve consequências graves, foi o caso de _Sally Clark_. Em $1999$, ela estava sendo julgada pelo assassinato de seus dois bebês, que morreram de _Síndrome da Morte Súbita Infantil_.

#figure(
  image("images/A1/sally.png"),
  caption: [Sally Clark]
)

O promotor do caso alegou que a probabilidade de duas crianças morrerem de _Síndrome da Morte Súbita Infantil_ na mesma família era de $1$ em $73$ milhões, e que isso provava que ela era culpada. No entanto, essa alegação foi baseada em uma falácia estatística, pois não considerou outros fatores, como histórico familiar, condições de saúde e outros fatores de risco. Resumidamente, ele confundiu
$
  PP("Evidência"|"Inocência")
$
com
$
  PP("Inocência"|"Evidência")
$
Anos depois a condenação foi anulada. Diversos estatísticos apontaram que houve uso incorreto de probabilidade no julgamento.

== Lei da Probabilidade Total
A lei da probabilidade total dita como as probabilidades condicionais de eventos conhecidos se combinam para formar a probabilidade de um evento desconhecido. Vamos enunciar o teorema e depois vamos mostrar um exemplo.

#theorem("Lei da Probabilidade Total")[
  Sejam $A_1, A_2, ..., A_n$ eventos disjuntos $2$ a $2$, ou seja, $A_i inter A_j = emptyset$ para $i != j$ e $union.big_(i=1)^n A_i = S$ onde $S$ é o espaço amostral, então para qualquer evento $B$, desde que $PP(A_i)$ e $PP(B|A_i)$ existam e sejam conhecidos, temos que
  $
    PP(B) = sum_(i=1)^n PP(B | A_i) dot PP(A_i)
  $
]
#proof[
  $
    PP(B) &= PP(B inter S)    \

    &= PP(B inter (A_1 union A_2 union ... union A_n))    \

    &= PP((B inter A_1) union (B inter A_2) union ... union (B inter A_n))    \

    &= PP(B inter A_1) + PP(B inter A_2) + ... + PP(B inter A_n)    \

    &= PP(B | A_1) dot PP(A_1)  + ... + PP(B | A_n) dot PP(A_n)    \
  $
]

Esse evento é muito útil quando temos informações sobre outros eventos, mas não temos sobre o evento objetivo que gostaríamos de conhecer. Como vimos no exemplo da malária, nós tínhamos informações sobre a probabilidade de um teste dar positivo dado que a pessoa estava doente, mas não tínhamos informações sobre a probabilidade total do teste dar positivo, e para calcular isso, usamos a lei da probabilidade total.

Conseguimos expandir esse teorema para o caso de múltiplas condições, mas antes de fazer isso, vamos enunciar um teorema que vai nos ajudar a fazer isso.

#theorem([Equivalência probabilística do condicionamento])[
  A função $tilde(PP)(A) = PP(A|E)$ com $E$ sendo um evento possível qualquer, é uma probabilidade.
]<conditional-probability-is-a-probability>
#proof[
  Para que a função seja uma probabilidade, ela precisa estar sujeita aos axiomas da probabilidade, ou seja, ela precisa satisfazer as seguintes condições:
  + $tilde(PP)(S) = 1$
  + $tilde(PP)(A) >= 0$
  + $tilde(PP)(union.big_(j=1)^n A_j) = sum_(j=1)^n tilde(PP)(A_j)$

  *Provando $tilde(PP)(S) = 1$*: Se sabemos que o evento $E$ ocorreu, então nosso espaço amostral é reduzido para *todos os eventos em que $E$ ocorreu*, ou seja, o nosso espaço amostral vira $E$.
  $
    tilde(PP)(E) = PP(E|E) = frac(PP(E inter E), PP(E)) = frac(PP(E), PP(E)) = 1
  $

  *Provando $tilde(PP)(A) >= 0$*: Pela definição de probabilidade condicional, temos que
  $
    tilde(PP)(A) = PP(A|E) = frac(PP(A inter E), PP(E))
  $
  como a função de cima e a de baixo são maiores que $0$, a divisão inteira será maior que $0$.

  *Provando $tilde(PP)(union.big_(j=1)^n A_j) = sum_(j=1)^n tilde(PP)(A_j)$*: Pela definição de probabilidade condicional, temos que
  $
    tilde(PP)(union.big_(j=1)^n A_j) &= PP(union.big_(j=1)^n A_j | E)   \
    
    &= frac(PP((union.big_(j=1)^n A_j) inter E), PP(E))   \
    
    &= frac(PP(union.big_(j=1)^n (A_j inter E)), PP(E))   \
    
    &= frac(sum_(j=1)^n PP(A_j inter E), PP(E))   \

    &= sum_(j=1)^n frac(PP(A_j inter E), PP(E))   \
    
    &= sum_(j=1)^n tilde(PP)(A_j)
  $
]

Com esse teorema, podemos expandir a lei da probabilidade total

#theorem([Lei da Probabilidade Total com Condicionamento Extra])[
  Sejam $A_1, A_2, ..., A_n$ eventos disjuntos $2$ a $2$, ou seja, $A_i inter A_j = emptyset$ para $i != j$ e $union.big_(i=1)^n A_i = S$ onde $S$ é o espaço amostral, então para qualquer evento $B$ e $E$, desde que $PP(A_i|E)$ e $PP(B|A_i inter E)$ existam e sejam conhecidos, temos que
  $
    PP(B | E) = sum_(i=1)^n PP(B | A_i inter E) dot PP(A_i | E)
  $
]
#proof[
  Pelo @conditional-probability-is-a-probability, podemos renomear $tilde(PP)(B) = PP(B|E)$, então podemos aplicar a lei da probabilidade total para essa função, ou seja, temos que
  $
    tilde(PP)(B) = sum_(i=1)^n tilde(PP)(B | A_i) dot tilde(PP)(A_i)    \

    <=>   \

    PP(B | E) = sum_(i=1)^n PP(B | A_i inter E) dot PP(A_i | E)
  $
]

Esse teorema nos permite utilizar a lei da probabilidade total em problemas mais complexos e com mais restrições.

#pagebreak()

#align(center+horizon)[
  = Variáveis Aleatórias Discretas
]

#pagebreak()

== Experimentos Aleatórios
Dentro de um experimento qualquer, estamos a todo momento medindo quantidades, como por exemplo, o número de vezes que um dado caiu em $6$, ou o número de vezes que uma moeda caiu em *cara*. Essas quantidades são chamadas de *variáveis aleatórias*.

#definition([Variável Aleatória Discreta])[
  Uma variável aleatória discreta é uma função $X: S -> RR$ que associa a cada resultado do espaço amostral $S$ um número real $RR$ e tal que o conjunto de valores assumidos por $X$,
  $
    "Im"(X)={X(s):s in S}
  $
  é *finito* ou *enumerável*.
]

#example[
  Dado um experimento de jogar uma moeda honesta $3$ vezes, poderíamos ter as seguintes variáveis aleatórias discretas:
  $
    X = "número de caras"   \

    Y = "número de transições de cara para coroa"   \
  $
]

O nome de *aleatório* não vem do número em si, mas vem da *naturaza do experimento* conter aleatoriedade

== Função de Massa
É a função que descreve a probabilidade de cada valor que a variável aleatória discreta pode assumir. Por exemplo, se eu jogo uma moeda honesta $3$ vezes, a variável aleatória $X$ que mede o número de caras pode assumir os valores $0$, $1$, $2$ e $3$. A função de massa de probabilidade vai me dizer qual a probabilidade de cada um desses valores ocorrer.

#definition([Função de Massa de Probabilidade (PMF)])[
  A função de massa de probabilidade (ou PMF) de uma variável aleatória discreta $X$ é uma função $p_X: RR -> [0,1]$ definida por
  $
    p_X (x) = PP(X=x)
  $
  para todo $x in RR$. A função de massa de probabilidade satisfaz as seguintes propriedades:
  + $p_X (x) >= 0$ para todo $x in RR$
  + $sum_(x in "Im"(X)) p_X(x) = 1$
]

Outra função de massa muito importante é a que descreve o comportamento de múltiplas variáveis aleatórias conjuntamente

#definition([Função de Massa Conjunta])[
  Sejam $X_1,...,X_n$ variáveis aleatórias discretas, a função de massa conjunta é uma função $p_(X_1,...,X_n): RR^n -> [0,1]$ definida por
  $
    p_(X_1,...,X_n)(x_1,...,x_n) = PP(X_1=x_1,...,X_n=x_n)
  $
]

#definition([Função de Massa Condicional])[
  Sejam $X_1,...,X_n$ variáveis aleatórias discretas e $Y$ uma variável aleatória discreta, a função de massa condicional é uma função $p_(X_1,...,X_n|Y): RR^n -> [0,1]$ definida por
  $
    p_(X_1,...,X_n|Y) (x_1,...,x_n|y) = PP(X_1=x_1,...,X_n=x_n|Y=y)
  $
]

Ela descreve a probabilidade de cada combinação de valores que as variáveis aleatórias podem assumir. Por exemplo, se eu jogo uma moeda honesta $3$ vezes e defino as variáveis
$
  X = "número de caras" quad Y = "número de coroas"
$
e eu gostaria de saber $PP(X=2,Y=0)$. A função de massa me retornaria $0$, afinal, eu não posso ter $3$ caras e $0$ coroas ao mesmo tempo. Já se eu quisesse saber $PP(X=2,Y=1)$, a função de massa me retornaria $3\/8$, afinal, existem $3$ maneiras de ter $2$ caras e $1$ coroa em $3$ jogadas, e o total de possibilidades é $8$.

Perceba que ao saber o valor de $Y$ no exemplo acima, isso me da algum tipo de informação sobre o valor de $X$! Isso me é um indicativo que $X$ e $Y$ *não são independentes*. Será que a função de massa pode nos ajudar a descobrir se duas variáveis aleatórias são independentes?

#definition([Independência de Variáveis Aleatórias])[
  Duas variáveis aleatórias $X$ e $Y$ são independentes se, e somente se, a função de massa conjunta for igual ao produto das funções de massa marginais:
  $
    p_(X,Y)(x,y) = p_X (x) dot p_Y (y)
  $
  para todos $x$ e $y$.
]

#corollary([Independência por Condicionalidade])[
  $
    X "e" Y "são independentes" <=> PP(X=x|Y=y) = PP(X=x)
  $
]

Por que uma definição e não um teorema? Isso vem diretamente da teoria dos conjuntos e definições de probabilidade em conjuntos que vimos anteriormente! Inclusive, muitos teoremas se extendem para cá!

#theorem([Lei da Probabilidade Total])[
  $
    PP(X=x) &= sum_(y) PP(X=x|Y=y) dot PP(Y=y)    \

    &= sum_(y) PP(X=x, Y=y)
  $
]

== Transformações sobre as variáveis
Esse tema é bem profundo, mas agora no inicio, nós vamos ver algumas transformaçẽos básicas que podem ser aplicadas em variáveis aleatórias e *como* elas influenciam nas probabilidades dos eventos. Para os casos abaixo, considere $X$ e $Y$ variáveis aleatórias.

- $a dot X$ com $a in RR$: Se a imagem de $X$ é $x_1,...,x_n$, então a imagem de $a dot X$ é $a dot x_1,...,a dot x_n$. A função de massa de probabilidade de $a dot X$ é dada por
  $
    p_(a dot X)(a dot x) = p_X (x)
  $
  ou seja, as probabilidades não mudam, apenas os valores que a variável aleatória pode assumir.

- $X + b$ com $b in RR$: Se a imagem de $X$ é $x_1,...,x_n$, então a imagem de $X + b$ é $x_1 + b,...,x_n + b$. A função de massa de probabilidade de $X + b$ é dada por
  $
    p_(X + b)(x + b) = p_X (x)
  $
  ou seja, as probabilidades não mudam, apenas os valores que a variável aleatória pode assumir.

- $X + Y$: Se a imagem de $X$ é $x_1,...,x_n$ e a imagem de $Y$ é $y_1,...,y_m$, então a imagem de $X + Y$ é $x_1 + y_1,...,x_n + y_m$. A função de massa de probabilidade de $X + Y$ pode ser calculada analíticamente, no entanto, não será o foco nesse momento. Como os problemas nessa etapa são simples, podemos calcular o novo espaço amostral de $X+Y$ manualmente e calcular as probabilidades com base nas probabilidades de $X$ e $Y$. Esse raciocínio se aplica a qualquer função $g(X,Y)$

== Função Acumulada
A função de distribuição acumulada (CDF) calcula a probabilidade do valor mostrado pela variável ser menor que um $x$.

#definition([Função de Distribuição Acumulada (CDF)])[
  A função de distribuição acumulada (CDF) de uma variável aleatória discreta $X$ é uma função $F_X: RR -> [0,1]$ definida por
  $
    F_X (x) = PP(X <= x)
  $
  para todo $x in RR$. A função de distribuição acumulada satisfaz as seguintes propriedades:
  + $F_X (x)$ é não decrescente
  + $lim_(x->-infinity) F_X (x) = 0$
  + $lim_(x->infinity) F_X (x) = 1$
]

Essa função pode não parecer super útil no momento, mas ela é muito útil para calcular probabilidades de intervalos, por exemplo, se eu quero saber a probabilidade de $X$ estar entre $a$ e $b$!

#theorem[
  $
    PP(a < X <= b) = F_X (b) - F_X (a)
  $
]


#pagebreak()

#align(center+horizon)[
  = Esperança e Medidas de Dispersão
]

#pagebreak()

== O Valor Médio
Em problemas cotidianos, muitas vezes gostamos de fazer a pergunta _"Quanto eu ganho em média?"_, _"Quanto eu perco em média?"_, _"Quantos pontos eu consigo em média?"_, ... A esperança matemática é justamente a resposta para essa pergunta, ela nos dá o valor médio esperado de uma variável aleatória, que intuitivamente seria o valor que, se eu fosse chutar que cairía, seria o valor que eu chutaria. Por exemplo, se eu tenho uma contagem de caras e coroas em $n$ jogadas, eu com certeza chutaria que cairiam $n\/2$ caras e $n\/2$ coroas, afinal, a moeda é honesta.

#definition([Esperança de uma Variável Aleatória Discreta])[
  A esperança de uma variável aleatória discreta $X$ é definida por
  $
    EE[X] = sum_(x) x dot PP(X = x)
  $
]

A esperança existe desde que a soma esteja bem definida (existem casos que ela pode divergir e não existe um valor de esperança).

=== Law of the Unconscious Statistician
Esse teorema é nomeado de forma a tirar sarro de estatísticos. Acontece que, se você tem uma variável aleatória $X$ e uma função $g$, ao fazer $g(X)$, você pode pensar de forma inocente, que
$
  EE[g(X)] = sum_(x) g(x) dot PP(X = x)
$
mas isso na verdade está *corretíssimo*, acontece que a demonstração desse teorema é mais complexa, mas o seu resultado intuitivo está *correto*

#theorem([Law of the Unconscious Statistician (LOTUS)])[
  Sejam $X$ uma variável aleatória discreta e $g$ uma função, então
  $
    EE[g(X)] = sum_(x) g(x) dot PP(X = x)
  $
]
#proof[
  Pensando numa demonstração *não rigorosa*, mas intuitiva, podemos pensar que, para encontrar a probabilidade de um $z=g(x)$ ocorrer, precisamos encontrar todos os valores de $x$ que vão gerar aquele $z$. O somatório faz isso em cima dos locais corretos e soma $z p(z)$
  $
    EE[Z] &= sum_z z PP(Z=z) = sum_z z (sum_(g(x)=z) PP(X=x))   \
    
    &= sum_z sum_(g(x)=z) z PP(X=x)   \

    &= sum_z sum_(g(x)=z) g(x) PP(X=x)   \

    &= sum_(x) g(x) PP(X=x)
  $
]

#corollary([Linearidade da Esperança])[
  A esperança é linear, ou seja, para quaisquer constantes $a$ e $b$ e variáveis aleatórias $X$ e $Y$, temos
  $
    EE[a X + b Y] = a EE[X] + b EE[Y]
  $
]
#proof[
  $
    EE[a X + b Y] = sum_(x,y) (a x + b y) dot PP(X=x,Y=y)    \

    = sum_(x,y) a x dot PP(X=x,Y=y) + sum_(x,y) b y dot PP(X=x,Y=y)    \

    = a sum_(x) x sum_(y) dot PP(X=x,Y=y) + b sum_(y) y sum_(x) dot PP(X=x,Y=y)    \
  $

  Pela lei da probabilidade total, temos que
  $
    sum_(y) PP(X=x,Y=y) = PP(X=x)   \
    
    sum_(x) PP(X=x,Y=y) = PP(Y=y)
  $

  Logo:
  $
    EE[a X + b Y] &= a sum_(x) x dot PP(X=x) + b sum_(y) y dot PP(Y=y)    \

    &= a EE[X] + b EE[Y]
  $
]

#theorem([LOTUS com duas variáveis])[
  Sejam $X$ e $Y$ variáveis aleatórias discretas e $g$ uma função, então
  $
    EE[g(X,Y)] = sum_(x,y) g(x,y) dot PP(X=x,Y=y)
  $
]
#proof[
  Fazendo uma demonstração não rigorosa, mas intuitiva, podemos pensar que, para encontrar a probabilidade de um $z=g(x,y)$ ocorrer, precisamos encontrar todos os valores de $x$ e $y$ que vão gerar aquele $z$. O somatório faz isso em cima dos locais corretos e soma $z p(z)$
  $
    EE[Z] &= sum_z z PP(Z=z) = sum_z z (sum_(g(x,y)=z) PP(X=x,Y=y))   \
    
    &= sum_z sum_(g(x,y)=z) z PP(X=x,Y=y)   \

    &= sum_z sum_(g(x,y)=z) g(x,y) PP(X=x,Y=y)   \

    &= sum_(x,y) g(x,y) PP(X=x,Y=y)
  $
]

=== Esperança e Independência
A esperança também pode ser afetada pela independência de variáveis aleatórias.

#theorem([Esperança de Variáveis Aleatórias Independentes])[
  Sejam $X$ e $Y$ variáveis aleatórias discretas independentes, então
  $
    EE[X Y] = EE[X] dot EE[Y]
  $
  a volta não vale
]
#proof[
  Pela definição de independência, temos que
  $
    PP(X=x,Y=y) = PP(X=x) dot PP(Y=y)
  $
  então
  $
    EE[X Y] &= sum_(x,y) x y dot PP(X=x,Y=y)    \
    
    &= sum_(x,y) x y dot PP(X=x) dot PP(Y=y)    \

    &= sum_(x) x dot PP(X=x) sum_(y) y dot PP(Y=y)    \

    &= EE[X] dot EE[Y]
  $

  Um contra exemplo para o caso contrário são as variáveis $X$ e $Y$ tais que
  $
    PP(X=1,Y=1) = 1/2 quad PP(X=-1,Y=-1) = 1/2
  $
  aqui conseguimos ver que
  $
    EE[X] = EE[Y] = 0
  $
  no entanto
  $
    EE[X Y] = 1
  $
  pois $X dot Y$ é sempre $1$
]

=== Monotonicidade da Esperança

#theorem([Monotonicidade da Esperança])[
  Sejam $X$ e $Y$ variáveis aleatórias discretas, se $X >= Y$, então
  $
    EE[X] >= EE[Y]
  $
]
#proof[
  Como $X>=Y$, temos que $X - Y >= 0$, então
  $
    EE[X - Y] >= 0 <=> EE[X] - EE[Y] >= 0 <=> EE[X] >= EE[Y]
  $
]

=== Função de Sobrevivência
Conseguimos expressar a esperança em termos da função de sobrevivência, que é a função que nos dá a probabilidade de uma variável aleatória ser maior que um certo valor.

#definition([Função de Sobrevivência])[
  A função de sobrevivência de uma variável aleatória discreta $X$ é uma função $G_X: RR -> [0,1]$ definida por
  $
    G_X (x) = PP(X > x)
  $
  para todo $x in RR$. A função de sobrevivência satisfaz as seguintes propriedades:
  + $G_X (x)$ é não crescente
  + $lim_(x->-infinity) G_X (x) = 1$
  + $lim_(x->infinity) G_X (x) = 0$
]

#theorem([Esperança em termos da Função de Sobrevivência])[
  Sejam $X$ uma variável aleatória discreta não negativa, então
  $
    EE[X] = sum_(x=0)^infinity G_X (x)
  $
]
#proof[
  Seja $I_j$ a variável aleatória definida como:
  $
    I_j = cases( 
      1 quad  X >= j,
      0 quad  X < j
    )
  $
  conseguimos decompor a variável aleatória $X$ como
  $
    X = sum_(j=1)^infinity I_j
  $
  por exemplo, se $X = 3$, então $I_1 = I_2 = I_3 = 1$ e $I_j = 0$ para $j > 3$. Então a esperança de $X$ será
  $
    EE[X] = EE[sum_(j=1)^infinity I_j] = sum_(j=1)^infinity EE[I_j]
  $
  Agora só precisamos mostrar que $EE[I_j] = PP(X >= j)$. Pela definição de $I_j$, sua esperança será
  $
    EE[I_j] = 1 dot PP(I_j = 1) + 0 dot PP(I_j = 0) = PP(I_j = 1) = PP(X >= j)
  $
  logo
  $
    EE[X] = sum_(j=1)^infinity PP(X >= j) = sum_(x=0)^infinity G_X (x)
  $
]

== Medidas de Dispersão

