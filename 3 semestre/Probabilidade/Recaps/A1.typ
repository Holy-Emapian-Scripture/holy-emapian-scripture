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

== Contagem
A probabilidade é muito derivada do conceito de contar todas as saídas possíveis de um experimento/teste, por conta disso, é *fundamental* que fiquemos *craques* em contagem. A contagem é uma ferramenta que nos permite organizar e estruturar as possibilidades de um experimento, e assim, calcular a probabilidade de um evento ocorrer (depois vemos como fazer isso). O importante agora é entendermos os principais princípios dessa área da matemática.

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

Existe uma propriedade muito interessante que podemos usar para calcular combinações, ela mostra que, se eu quero escolher um grupo de $k$ elementos de um conjunto de $n$ elementos, o número de maneiras de fazer isso é o mesmo que escolher $n-k$ elementos do mesmo conjunto. Ou seja, $C_n^k = C_n^(n-k)$.

#theorem[
  $
    C_n^k = C_n^(n-k)
  $
]<combination-simetry>
#proof[
  Queremos mostrar que
  $
    mat(n ; k) = mat(n ; n-k)
  $
  vamos desenvolver ambos os lados
  $
    mat(n ; k) = (n!) / (k! (n-k)!)
  $
  $
    mat(n ; n-k) = (n!) / ((n-k)! (n-(n-k))!) = (n!) / (k! (n-k)!)
  $
]

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

== Ferramentas de Contagem
Daqui a pouco, vamos definir melhor uma definição ingênua sobre probabilidade, mas de antemão, ela envolve *a contagem de todas as possibilidades que um experimento pode ter*. no mundo real, é impossível contar todas as saídas possíveis de um experimento na mão, mas isso não é um problema! Mesmo quando as saídas de um *experimento* são *numerosas* e *complexas de se contar na mão*, ainda podemos utilizar algumas ferramentas na área da contagem para nos ajudar a calcular as possibilidades!

=== Tabela Amostral
A tabela amostral é muito útil para organizar *quais ferramentas* de contagem utilizamos sob *determinadas condições* de um *experimento*. 

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

Antes de explicar a origem de cada fórmula, vou enunciar as *restrições* associadas à cada fórmula
- *Ordem Importa*: A ordem dos elementos escolhidos influencia na contagem, ou seja, se eu escolher os elementos $a$ e $b$, a sequência $(a,b)$ é diferente da sequência $(b,a)$.
- *Ordem não Importa*: A ordem dos elementos escolhidos não influencia na contagem, ou seja, se eu escolher os elementos $a$ e $b$, a sequência $(a,b)$ é igual à sequência $(b,a)$.

- *Reposição*: Cada elemento escolhido volta para o conjunto de elementos disponíveis, ou seja, posso escolher o mesmo elemento mais de uma vez.
- *Sem Reposição*: Cada elemento escolhido não volta para o conjunto de elementos disponíveis, ou seja, não posso escolher o mesmo elemento mais de uma vez.

==== Ordem Importa e Reposição
Se a ordem importa, então estamos lidando com arranjos. Se há reposição, então para cada elemento escolhido, ele volta para o conjunto de elementos disponíveis, ou seja, na primeira retirada, eu tenho $n$ elementos disponíveis, na segunda, eu ainda tenho $n$ pois o anterior foi colocado de volta, e assim por diante. Logo, o número de maneiras de escolher $k$ elementos com reposição é dado por $n^k$.

==== Ordem Importa e Sem Reposição
Estamos lidando literalmente com os arranjos como já vimos antes, então será a mesma fórmula do arranjo, ou seja, $n!/(n-k)!$.

==== Ordem não Importa e Sem Reposição
É exatamente o caso da combinação padrão que discutimos anteriormente, ou seja, $mat(n;k)$.

==== Ordem não Importa e Reposição
Esse caso é um pouco mais complicado. Você saber de quantas formas possíveis você pode escolher $k$ elementos de um conjunto de $n$ elementos, mas agora você pode escolher o mesmo elemento mais de uma vez, isso é equivalente a *perguntar de quantos jeitos diferentes é possível distribuir $k$ partículas independentes em $n$ caixas diferentes*, mas por quê? Isso não parece nada intuitivo.

Interprete uma associação, cada partícula é um *sorteio* e cada caixa é um *elemento do conjunto*. Quando eu falo *partícula $i$ vai ficar na caixa $p$*, isso quer dizer em termos do sorteio que, no $i$-ésimo sorteio, o elemento escolhido foi o $p$-ésimo elemento do conjunto. Então, se eu tenho $k$ partículas e $n$ caixas, isso é equivalente a dizer que eu tenho $k$ sorteios e $n$ elementos disponíveis para escolher. Como eu posso escolher um mesmo elemento mais de uma vez, isso é equivalente a dizer que eu posso colocar mais de uma partícula na mesma caixa. Para fazer o cálculo de fato, utilizamos a abordagem de pontos e traços, tenha em mente a seguinte divisão
$
  dot dot dot \/ dot \/ dot dot dot \/ dot \/ dot
$
Essa representação é o mesmo que dizer que na primeira caixa, eu tenho $3$ partículas, na segunda eu tenho $1$ e assim em diante, a quantidade de pontos entre os traços representa a quantidade de partículas em cada caixa. Como temos $k$ partículas, temos $k$ pontos, e como temos $n$ caixas, temos $n-1$ traços. Logo, o número total de maneiras de organizar esses pontos e traços vai ser o número de maneiras de escolher $k$ pontos dentre todos os $k+n-1$ elementos, ou seja, $mat(n+k-1 ; k)$.

=== Identidades Úteis
Mesmo com as ferramentas de contagem que vimos antes, existem diversas situações complexas na área que ainda exigem certas *sacadas*. As identidades que vamos mostrar são *justamente essas sacadas*.

#theorem[
  $
    n mat(n-1 ; k-1) = k mat(n ; k)
  $
]<choice-of-leader>
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

== Contagem do Complementar
Essa técnica parece até boba, mas muitas vezes deixamos passar situações que são mais fáceis de serem resolvidas quando pensamos no *complementar* do que queremos. Essa estratégia consiste em, se eu não sei como calcular o total de possibilidades de uma situação específica, eu posso tentar calcular o da situação *oposta*. Por exemplo, eu quero saber de quantas formas possíveis, dentro de uma sala com $n$ pessoas, existem pelo menos $2$ pessoas com o mesmo aniversário. Calcular isso diretamente é bem difícil, no entanto, o complementar é muito fácil, que é *de quantas formas eu garanto que todos tem um dia diferente de aniversário*, que se resume a aplicar uma combinação de $n$ nos $365$ dias do ano. Dessa forma, calcular de quantas formas eu posso garantir que pelo menos $2$ pessoas tem o mesmo aniversário é muito mais fácil, pois é só fazer $365^n - mat(365 ; n)$


#pagebreak()

#align(center+horizon)[
  = Primeiros passos em Probabilidade
]

#pagebreak()

== Fundamentos
=== Naive Definition
Antes de vermos propriedades teoremas e definições difíceis, vamos começar com uma definição *super simples* do que é uma probabilidade. Intuitivamente, a probabilidade é a chance de um evento ocorrer. Se eu repetir um experimento $x$ vezes, quantas dessas $x$ vezes o evento ocorreu? Com essa noção mais prática de probabilidade, podemos fazer a seguinte definição

#definition([Naive Probability Definition])[
  Seja $S$ o conjunto de *todas* as possíveis saídas de um experimento, e $E$ é um possível *acontecimento* dentro do experimento, então a probabilidade de $E$ ocorrer é
  $
    PP(E) = frac(|E|, |S|)
  $
]

Essa definição mostra a probabilidade do evento ocorrer como uma fração, onde o numerador são *todas as formas que o evento pode ocorrer* sobre *todos os eventos possíveis de ocorrer*. Por exemplo, se eu jogar um dado justo, todos os valores possíveis são $S={1,2,3,4,5,6}$, a chance de sair evento _"caiu $2$"_ seria $E={2}$, então a probabilidade de cair $2$ seria
$
  PP(E) = frac(|E|, |S|) = frac(1,6)
$

=== Conjuntos
Dada essa definição ingênua de probabilidade, podemos começar a pensar em como formalizar isso utilizando a ideia de *conjuntos*! Na verdade essa é a formalização mais básica de probabilidade. Vamos enunciar algumas definições então.

#definition([Espaço Amostral])[
  O espaço amostral $S$ é o conjunto de *todos os resultados possíveis* de um experimento aleatório.
]

#definition([Evento])[
  Um evento $E$ é um subconjunto do espaço amostral $S$, ou seja, $E subset.eq S$.
]

Essa definição de $E$ parece bem simples, mas se pararmos para pensar, um evento nada mais é que um conjunto de resultados possíveis de um experimento aleatório. Voltando ao exemplo do dado, se o meu espaço amostral é $S = {1, 2, 3, 4, 5, 6}$, faz sentido afirmar que _"cair $3$"_ é um evento. Porém, falar _"cair o número $7$"_ não faz sentido, pois $7$ não está no espaço amostral, logo, não é um *evento*.

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

== Propriedades da Probabilidade
Dado toda a introdução que fizemos, podemos agora enunciar algumas propriedades da probabilidade que serão muito úteis. Antes, precisamos saber dos seguintes axiomas:
$
  PP(emptyset) = 0 wide PP(S) = 1 wide PP(A) >= 0   \

  PP(union.big_(n=1)^infinity A_n) = sum_(n=1)^infinity PP(A_n) wide -> A_i inter A_j = emptyset quad forall i != j
$

Agora podemos enunciar as propriedades e suas  demonstrações

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

#theorem([Princípio da Inclusão-Exclusão])[
  $
    PP(A union B) = PP(A) + PP(B) - PP(A inter B)
  $
]<inclusion-exclusion>
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
#proof[
  Derivado direto da outra propriedade. Defina
  $
    D = A union B
  $
  então pelo @inclusion-exclusion, temos que
  $
    PP(A union B union C) = PP(D union C) = PP(D) + PP(C) - PP(D inter C)
  $
  substituindo $PP(D)$ e $PP(D inter C)$, temos que
  $
    PP(A union B union C) = &PP(A) + PP(B) - PP(A inter B)   \ + &PP(C) - PP(A inter C) - PP(B inter C)   \
    + &PP(A inter B inter C)
  $
]

A ideia desses teoremas é que, quando contamos os eventos, podemos acabar contando *duas vezes* os eventos que estão em comum, então precisamos subtrair esses eventos que estão em comum. Só que conforme adicionamos mais e mais eventos, podemos acabar subtraindo *demais* os eventos que estão em comum, então precisamos adicionar de volta esses eventos. E assim por diante, até que tenhamos contado todos os eventos corretamente.

== Eventos Independentes
Dois eventos $A$ e $B$ são independentes se a ocorrência de um não afeta a probabilidade do outro. De imediato, não vamos ver a definição formal de independência, que é fácil, mas vamos nos manter na *intuição*. A independência de dois eventos é perceptível quando *a ocorrência de um evento não influencia na saída de outro*. Por exemplo, se eu jogar um dado e uma moeda, a saída do dado não influencia na saída da moeda, logo, os eventos são independentes. Agora vamos supor que eu estou lançando *dois dados*, no entanto, a saída do segundo é somada à saída do primeiro. Nesse caso, a saída do segundo dado *depende* da saída do primeiro, logo, os eventos *não são* independentes.

== Problema do Aniversário
Que tal resolvermos um problema bem paradoxal para estimular nosso pensamento *probabilistico*? O problema do aniversário é o seguinte: qual a probabilidade de, em um grupo de $k$ pessoas, *pelo menos* duas delas fazerem aniversário no mesmo dia? Parece que para que isso aconteça, o grupo precisa ser grande, mas não é bem assim. Antes de resolvermos o problema, vou enunciar um teorema que será útil para provar o caso mais óbvio.

#theorem([Princípio da Casa dos Pombos])[
  Se $n$ pombos são colocados em $m$ casas, e $n > m$, então *pelo menos* uma casa terá mais de um pombo.
]<pidgeon-hole-principle>

Agora podemos enunciar as etapas da resolução do problema! Primeira coisa que fazemos é *remover as restrições*. Uma delas é o dia $29$ de fevereiro, que só ocorre em anos bissextos, então vamos *desconsiderar* esse dia. Outro ponto é que *cada dia* tem a *mesma chance* de ocorrer e são eventos *independentes*.

Para o caso de termos mais pessoas que dis do ano, pelo @pidgeon-hole-principle, sabemos que *pelo menos* duas pessoas vão fazer aniversário no mesmo dia, logo a probabilidade será $1$.

Agora vamos analisar o caso geral para $k <= 365$. Nessa situação, o mais fácil é calcular a probabilidade do evento *contrário*, ou seja, a probabilidade de que *todos do grupo tem aniversários diferentes*.
$
  PP("todos diferentes") = 365 / 365 dot 364 / 365 dot 363 / 365 ... dot (365-k+1) / 365 = frac(365! / (365-k)!, 365^k)
$

Aqui, nós vamos no racicínio que o primeiro aniversariante tem $365$ opções, o segundo tem $364$ opções, o terceiro tem $363$ opções e assim por diante, até que o último aniversariante tenha $365-k+1$ opções. Como cada pessoa tem $365$ opções, então o número total de possibilidades é $365^k$. Logo, a probabilidade de *pelo menos* duas pessoas fazerem aniversário no mesmo dia é
$
  PP("pelo menos dois iguais") = 1 - PP("todos diferentes") = 1 - frac(365! / (365-k)!, 365^k)
$

Quando $k = 23$, a probabilidade de que *pelo menos* duas pessoas façam aniversário no mesmo dia é de aproximadamente $50%$.

#pagebreak()

#align(center+horizon)[
  = Probabilidade Condicional
]

#pagebreak()

== Como o Conhecimento influencia na Probabilidade
Em probabilidade, conseguimos utilizar conhecimento do que aconteceu agora no nosso experimento para entender as chances dos eventos que estão para acontecer.

#example[
  Ao jogarmos um dado justo $2$ vezes, dado que eu sei que a soma de ambos os valores que caíram é $6$, mas não sei qual o valor de cada lançamento, qual é a probabilidade de que o primeiro valor seja $2$? Sabemos que a soma de ambos os valores que caíram é $6$, então o espaço amostral é reduzido para
  $
    (1,5), (2,4), (3,3), (4,2), (5,1)
  $
  dentro das possibilidades, a probabilidade vai ser
  $
    PP("primeiro valor é 2" | "soma é 6") = frac(1,5)
  $
]

#example[
  Jogamos uma moeda $100$ vezes, mas não sabemos se ela é viciada ou não. Sabemos que, se a moeda for justa, nós deveríamos observar uma proporção de $1\/2$ para o número de caras e coroas. No entanto, suponha que nós observamos $70$ caras e $30$ coroas. Isso faz parecer que essa moeda *está viciada* de alguma forma. Essa informação passada me faz crer que a chance do meu lançamento agora, não é mais $1\/2$.
]

#definition([Probabilidade Condicional])[
  Dado um espaço amostral $S$ e dois eventos $A,B subset.eq S$, a probabilidade de $A$ ocorrer dado que $B$ ocorreu é dada por
  $
    PP(A | B) = frac(PP(A inter B), PP(B))
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

== Independência
Agora que enunciamos o conceito de condicionamento e como *saber* de um evento influencia na probabilidade de outro, podemos formalizar melhor a definição de independência. Quando dizemos que um evento não influencia na probabilidade de outro, isso nos indica que, *se eu sei do resultado do evento $A$*, isso não me dá *nenhuma informação* sobre o resultado do evento $B$. Ou seja, a probabilidade de $B$ ocorrer *não muda* se eu sei que $A$ ocorreu. Formalizando isso, temos a seguinte definição.

#definition([Eventos Independentes])[
  Dois eventos $A$ e $B$ são independentes quando
  $
    PP(A inter B) = PP(A) dot PP(B)
  $
]

Ué, a definição que eu falei não parece ter muito a ver com o que eu acabei de escrever, mas na verdade, ela tem sim!

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

Assim, conseguimos formalizar a ideia de *não fornecimento de informação* de um evento sobre outro.

Outro conceito importante que podemos formalizar é que a probabilidade de *dois eventos ocorrerem* simultaneamente é a mesma que a probabilidade de *um evento ocorrer dado que o outro ocorreu* multiplicado pela probabilidade do *outro evento ocorrer*.

#theorem()[
  $
    PP(A inter B) = PP(A | B) dot PP(B) = PP(B | A) dot PP(A)
  $
]<intersection-and-conditional-equality>
#proof[
  Sabemos que $PP(A inter B) = PP(B inter A)$, manipulando então a definição de probabilidade condicional, temos que
  $
    PP(A|B) = PP(A inter B) / PP(B) <=> PP(A inter B) = PP(A | B) dot PP(B)
  $
  da mesma forma:
  $
    PP(B|A) = PP(B inter A) / PP(A) <=> PP(B inter A) = PP(B | A) dot PP(A)
  $
]

É o que mermão? Qual que é a lógica disso? Imagine que nós *sabemos* que um evento $A$ ocorreu, se sabemos que $A$ ocorreu, qual seria a probabilidade que, dentro do universo de $A$, o evento $B$ ocorra também? No entanto, para que isso aconteça, precisamos que $A$ ocorra também, logo, pelo princípio da multiplicação, precisamos múltiplicar ambas as probabilidades (queremos que as representar a chance dos *dois* eventos ocorrerem), ambas que são dadas justamente por
$
  PP(B | A) dot PP(A)
$

== Lei da Probabilidade Total
A lei da probabilidade total mostra como podemos representar a probabilidade de um evento $B$ ocorrer em função da sua chance de acontecer sob a perspectiva da ocorrência de outros eventos disjuntos no *mesmo espaço amostral*.

#theorem("Lei da Probabilidade Total")[
  Sejam $A_1, A_2, ..., A_n$ eventos disjuntos $2$ a $2$, ou seja, $A_i inter A_j = emptyset$ para $i != j$ e $union.big_(i=1)^n A_i = S$ onde $S$ é o espaço amostral, então para qualquer evento $B$, desde que $PP(A_i)$ e $PP(B|A_i)$ existam e sejam conhecidos, temos que
  $
    PP(B) = sum_(i=1)^n PP(B | A_i) dot PP(A_i)
  $
]<law-of-total-probability>
#proof[
  $
    PP(B) &= PP(B inter S)    \

    &= PP(B inter (A_1 union A_2 union ... union A_n))    \

    &= PP((B inter A_1) union (B inter A_2) union ... union (B inter A_n))    \

    &= PP(B inter A_1) + PP(B inter A_2) + ... + PP(B inter A_n)    \

    &= PP(B | A_1) dot PP(A_1)  + ... + PP(B | A_n) dot PP(A_n)    \
  $
]

Como podemos ver isso de forma intuitiva? Para uma explicação intuitiva, acesse esse vídeo: #link("_", "[PREENCHER]")

Esse teorema é muito útil quando temos informações sobre outros eventos, mas não temos sobre o evento objetivo que gostaríamos de conhecer.

#example[
  Suponha que eu queira saber a probabilidade de uma pessoa ter câncer, mas eu não tenho essa informação. No entanto, eu sei que a pessoa é fumante, e que a probabilidade de uma pessoa ter câncer *dado* que ela é fumante é $0.1$, e que a probabilidade de uma pessoa ter câncer dado que ela não é fumante é $0.01$. Além disso, eu sei que a probabilidade de uma pessoa ser fumante é $0.2$. Então, podemos calcular a probabilidade de uma pessoa ter câncer utilizando a lei da probabilidade total:
  $
    PP("câncer") = PP("câncer" | "fumante") dot PP("fumante") + PP("câncer" | "não fumante") dot PP("não fumante")    \

    = 0.1 dot 0.2 + 0.01 dot 0.8 = 0.02 + 0.008 = 0.028
  $
]

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

#example([A Moeda Viciada])[
  Considere duas urnas diferentes
  $
    A_1 = "3 bolas vermelhas e 1 azul"    \

    A_2 = "1 bola vermelha e 3 azuis"
  $
  Uma das urnas é escolhida ao acaso, e uma bola é retirada da urna escolhida com
  $
    PP(A_1) = PP(A_2) = 0.5
  $
  em seguida, retiramos duas bolas da urna escolhida *sem reposição*. Queremos saber então qual é a *probabilidade* de que do valor da segunda bola dado o da primeira. Por exemplo
  $
    V_1 = "primeira bola é vermelha"    \
    V_2 = "segunda bola é vermelha"
  $
  quero saber então
  $
    PP(V_2 | V_1) = PP(V_2 | V_1, A_1) dot PP(A_1 | V_1) + PP(V_2 | V_1, A_2) dot PP(A_2 | V_1)
  $
  calcular apenas $PP(V_2 | V_1)$ é difícil, mas se condicionarmos em *qual urna nós tiramos a bola*, conseguimos calcular facilmente.
]

== O Teorema de Bayes
Suponha que esteja acontecendo a suspeita de um possível *futuro* surto de malária no Rio de Janeiro, e que o governo está preocupado com a situação. Para isso, eles vão realizar um teste de malária em toda a população da cidade, mas o teste não é perfeito! Acontece que meu resultado deu positivo, isso quer dizer que tenho malária? Será que agora eu vou morrer? A verdade é bem mais tranquilizante, e o *teorema de bayes* no mostra essa relação.

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

Vamos considerar, no contexto do nosso problema, que
- Apenas $1%$ da população tem malária
- O teste acerta $99%$ dos doentes
- O teste acerta $99%$ dos saudáveis

Analisando rapidamente, se o teste der positivo, isso parece falar que *a chance de eu ter malária é de $99%$*, mas isso *não é verdade*. A minha primeira fala se refere à seguinte probabilidade:
$
  PP("Positivo"|"Doente") = 0.99
$
No entanto, meu exame deu positivo e eu não sei se estou mesmo doente ou não, logo, a probabilidade que eu quero saber é
$
  PP("Doente"|"Positivo")
$
pelo @bayes-theorem, temos que
$
  PP("Doente"|"Positivo") = frac(PP("Positivo"|"Doente") dot PP("Doente"), PP("Positivo")) = frac(0.99 dot 0.01, PP("Positivo"))
$
para calcular $PP("Positivo")$, usamos o @law-of-total-probability, mas ela diz que podemos expressar essa probabilidade como
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
Precisamos definir uma forma de associar cada valor que a variável aleatória pode assumir com a probabilidade que aquele valor ocorra no meu experimento, é aí que entra a *função de massa*.

=== Probabilidade Marginal
É a função que descreve a probabilidade de cada valor que a variável aleatória discreta pode assumir. Por exemplo, se eu jogo uma moeda honesta $3$ vezes, a variável aleatória $X$ que mede o número de caras pode assumir os valores $0$, $1$, $2$ e $3$. A função de massa de probabilidade vai me dizer qual a probabilidade de cada um desses valores ocorrer.

#definition([Função de Massa de Probabilidade (PMF)])[
  A função de massa de probabilidade (ou PMF) de uma variável aleatória discreta $X$ é uma função $p_X: RR -> [0,1]$ definida por
  $
    p_X (x) = PP(X=x)
  $
  para todo $x in RR$. A função de massa de probabilidade satisfaz as seguintes propriedades:
  + $p_X (x) >= 0$ para todo $x in RR$
  + $sum_(x in "Im"(X)) p_X(x) = 1$

  Essa função também é chamada de *Probabilidade Marginal de $X$*.
]

=== Probabilidade Conjunta
Outra função de massa muito importante é a que descreve o comportamento de múltiplas variáveis aleatórias conjuntamente, associando como um conjunto de valores que as variáveis aleatórias podem assumir, e qual a probabilidade de cada conjunto ocorrer.

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
e eu gostaria de saber $PP(X=2,Y=0)$. A função de massa me retornaria $0$, afinal, eu não posso ter $2$ caras e $0$ coroas ao mesmo tempo. Já se eu quisesse saber $PP(X=2,Y=1)$, a função de massa me retornaria $3\/8$, afinal, existem $3$ maneiras de ter $2$ caras e $1$ coroa em $3$ jogadas, e o total de possibilidades é $8$.

=== Relação entre as funções de massa
Perceba que ao saber o valor de $Y$ no exemplo acima, isso me da algum tipo de informação sobre o valor de $X$! Na verdade, conseguimos obter múltiplas relações entre as funções de massa, como *independência* e *obter a marginal de $X$ a partir da conjunta*, vamos ver como isso funciona.

==== Independência
No exemplo anterior, vimos que, se eu sei o valor de $X$, eu consigo informações sobre os possíveis valores de $Y$. Isso me é um indicativo que $X$ e $Y$ *não são independentes*. Será que a função de massa pode nos ajudar a descobrir se duas variáveis aleatórias são independentes? Na verdade sim! Lembra que definimos que dois eventos $A$ e $B$ são independentes quando $PP(A,B)=PP(A) dot PP(B)$? Na verdade, perceba que $X=x$ e $Y=y$ *também são eventos*, então podemos aplicar a definição de independência para variáveis aleatórias.

#definition([Independência de Variáveis Aleatórias])[
  Duas variáveis aleatórias $X$ e $Y$ são independentes quando a função de massa conjunta for igual ao produto das funções de massa marginais:
  $
    p_(X,Y)(x,y) = p_X (x) dot p_Y (y)    \

    PP(X=x,Y=y) = PP(X=x) dot PP(Y=y)    \
  $
  para todos $x$ e $y$.
]

E assim como na parte de conjuntos, conseguimos extender isso para a formalização que o conhecimento de variáveis independentes não afeta a probabilidade entre elas

#corollary([Independência por Condicionalidade])[
  $
    X "e" Y "são independentes" <=> PP(X=x|Y=y) = PP(X=x)
  $
]

#example[
  Voltando no exemplo do dado com soma $6$, vamos separar o problema em dois eventos para aplicar a definição de independência. Seja $X$ o evento de que o primeiro valor seja $2$, e seja $Y$ o evento de que a soma dos valores seja $6$. Então, temos que
  $
    PP(Y) = 5/36 quad PP(X inter Y) = 1/36
  $
  então aplicando a definição:
  $
    PP(X | Y) = PP(X inter Y) / PP(Y) = (1/36) / (5/36) = 1/5
  $
  e como $PP(X) = 1/6$, temos que
  $
    PP(X | Y) != PP(X)
  $
  logo, os eventos não são independentes.
]

==== Marginalização
Lembra que o @law-of-total-probability indica como obter a probabilidade de um evento $B$ em função de outros eventos disjuntos? Na verdade, conseguimos aplicar o mesmo raciocínio para variáveis aleatórias, e isso é chamado de *marginalização*. A marginalização nos permite obter a função de massa marginal de uma variável aleatória a partir da função de massa conjunta, para obter o @lotp-for-discrete-random-variables, basta definir o evento $B$ como $X=x$ e os eventos $A_j$ como $Y=y_j$

#theorem([Lei da Probabilidade Total])[
  $
    PP(X=x) &= sum_(y) PP(X=x|Y=y) dot PP(Y=y)    \

    &= sum_(y) PP(X=x, Y=y)
  $
]<lotp-for-discrete-random-variables>

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

== Função Acumulada e de Sobrevivência
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
]<cdf-discrete-random-variable>

#definition([Função de Sobrevivência])[
  A função de sobrevivência de uma variável aleatória discreta $X$ é uma função $G_X: RR -> [0,1]$ definida por
  $
    G_X (x) = PP(X > x)
  $
  para todo $x in RR$. A função de sobrevivência satisfaz as seguintes propriedades:
  + $G_X (x)$ é não crescente
  + $lim_(x->-infinity) G_X (x) = 1$
  + $lim_(x->infinity) G_X (x) = 0$
]<survival-function-discrete-random-variable>


Essa função pode não parecer super útil no momento, mas ela é muito útil para calcular probabilidades de intervalos, por exemplo, se eu quero saber a probabilidade de $X$ estar entre $a$ e $b$!

#theorem[
  $
    PP(a < X <= b) = F_X (b) - F_X (a)
  $
]

Ela também vai nos ajudar muito no futuro quando começarmos a falar sobre variáveis *contínuas*.

#pagebreak()

#align(center+horizon)[
  = Esperança
]

#pagebreak()
Esse capítulo terá bastante conceitos importantes, no entanto, também existirão muitos teoremas e demonstrações, principalmente de *propriedades* dos conceitos. Se você preferir, pode pular as demonstrações e ir direto para os conceitos, mas se possível, tente se aprofundar nas demonstrações posteriormente, pois elas vão te ajudar a entender melhor os conceitos.

== O Valor Médio
Em problemas cotidianos, muitas vezes gostamos de fazer a pergunta _"Quanto eu ganho em média?"_, _"Quanto eu perco em média?"_, _"Quantos pontos eu consigo em média?"_, ... A esperança matemática é justamente a resposta para essa pergunta, ela nos dá o valor médio esperado de uma variável aleatória, que intuitivamente seria o valor que, se eu fosse chutar que cairía, seria o valor que eu chutaria. Por exemplo, se eu tenho uma contagem de caras e coroas em $n$ jogadas, eu com certeza chutaria que cairiam $n\/2$ caras e $n\/2$ coroas, afinal, a moeda é honesta.

#definition([Esperança de uma Variável Aleatória Discreta])[
  A esperança de uma variável aleatória discreta $X$ é definida por
  $
    EE[X] = sum_(x) x dot PP(X = x)
  $
]

A esperança existe desde que a soma esteja bem definida (existem casos que ela pode divergir e não existe um valor de esperança).

== Law of the Unconscious Statistician
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
]<lotus>
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
]<lotus-two-variables>
#proof[
  Fazendo uma demonstração não rigorosa, mas intuitiva, podemos pensar que, para encontrar a probabilidade de um $z=g(x,y)$ ocorrer, precisamos encontrar todos os valores de $x$ e $y$ que vão gerar aquele $z$. O somatório faz isso em cima dos locais corretos e soma $z p(z)$
  $
    EE[Z] &= sum_z z PP(Z=z) = sum_z z (sum_(g(x,y)=z) PP(X=x,Y=y))   \
    
    &= sum_z sum_(g(x,y)=z) z PP(X=x,Y=y)   \

    &= sum_z sum_(g(x,y)=z) g(x,y) PP(X=x,Y=y)   \

    &= sum_(x,y) g(x,y) PP(X=x,Y=y)
  $
]

== Esperança e Independência
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

Acontece que, se duas variáveis são independentes, ao fazer $X Y$, os valores de $X$ não influenciam nos valores de $Y$, logo, todos os valores de $X Y$ são _"igualmente"_ prováveis, não no sentido que cada um tem $1\/(|S|)$ de probabilidade, mas num sentido que, se eu pegar um valor de $X$ e um valor de $Y$, a probabilidade de que eles se encontrem é a mesma, e isso é justamente o que a definição de independência nos diz. Já se eles não forem independentes, como o valor de $X$ incluencia no de $Y$, pode acontecer de existirem valores de $X Y$ mais prováveis de aparecer do que outros.

#example([Caso de Independência])[
  Suponha que eu jogo dois dados justos, e defino as variáveis aleatórias
  $
    X = "valor do dado 1" quad Y = "valor do dado 2"
  $
  Então, $X$ e $Y$ são independentes, e temos que
  $
    EE[X] = EE[Y] = 3.5
  $
  então
  $
    EE[X Y] = EE[X] dot EE[Y] = 3.5 dot 3.5 = 12.25
  $
]

#example([Caso de Dependência])[
  Suponha que eu jogo *um* dado justo, e defino as variáveis aleatórias
  $
    X = "valor do dado" quad Y = "valor do dado"
  $
  aqui é *dependência total*, então
  $
    X = Y
  $
  logo, se eu fizesse
  $
    X Y
  $
  saber o valor de $X$ *automaticamente me da o valor de $Y$*, então
  $
    EE[X] EE[Y] != EE[X Y]
  $
]

== Monotonicidade da Esperança
A esperança também é uma função *monótona*, ou seja, se uma variável aleatória é maior que outra, a esperança dela também será maior.

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

== Função de Sobrevivência
Conseguimos expressar a esperança em termos da função de sobrevivência (@survival-function-discrete-random-variable).

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


#pagebreak()

#align(center+horizon)[
  = Medidas de Dispersão
]

#pagebreak()

== Introdução
Essas medidas nos ajudam a entender o *quanto* os valores da variável aleatória estão espalhados em torno da média. Se a esperança nos dá o valor que esperamos que a variável aleatória assuma, as medidas de dispersão nos dizem o quão _"bem comportadas"_ essas variáveis são, elas se concentram perto da média? Ou elas se espalham em vários lugares? Para uma visualização visual do que essas medidas representam, acesse esse vídeo: #link("_", "[PREENCHER]")

#definition([Desvio Médio])[
  O desvio médio de uma variável aleatória discreta $X$ é definido por
  $
    "DM"[X] = EE[ |X - EE[X]| ]
  $
]

#definition([Variância])[
  A variância de uma variável aleatória discreta $X$ é definida por
  $
    VV[X] = EE[ (X - EE[X])^2 ]
  $
]

#definition([Desvio Padrão])[
  O desvio padrão de uma variável aleatória discreta $X$ é definido por
  $
    sigma[X] = sqrt(VV[X])
  $
]

== Propriedades
A variância e o desvio padrão são as medidas de dispersão mais utilizadas. Vamos enunciar e demonstrar algumas propriedades dessas medidas de dispersão.

#theorem[
  $
    VV[a X + b] = a^2 VV[X]
  $
]
#proof[
  $
    VV[a X + b] &= EE[ (a X + b - EE[a X + b])^2 ]    \

    &= EE[ (a X + b - (a EE[X] + b))^2 ]    \

    &= EE[ (a X - a EE[X])^2 ]    \

    &= EE[ a^2 (X - EE[X])^2 ]    \

    &= a^2 EE[ (X - EE[X])^2 ]    \

    &= a^2 VV[X]
  $
]

#theorem[
  $
    sigma[a X + b] = |a| sigma[X]
  $
]
#proof[
  Pela propriedade anterior, temos que
  $
    sigma[a X + b] = sqrt(VV[a X + b]) = sqrt(a^2 VV[X]) = |a| sqrt(VV[X]) = |a| sigma[X]
  $
]

#theorem[
  $
    "DM"[a X + b] = |a| "DM"[X]
  $
]
#proof[
  Pela definição de desvio médio, temos que
  $
    "DM"[a X + b] &= EE[ |a X + b - EE[a X + b]| ]    \

    &= EE[ |a X + b - (a EE[X] + b)| ]    \

    &= EE[ |a X - a EE[X]| ]    \

    &= EE[ |a| |X - EE[X]| ]    \

    &= |a| EE[ |X - EE[X]| ]    \

    &= |a| "DM"[X]
  $
]

Intuitivamente, quando nós adicionamos uma constante $b$ em uma variável, a média vai se descolar esse exato mesmo valor, no entanto, como todos os pontos vão se mover exatamente $b$ unidades, a dispersão vai se manter a mesma. No entanto, se multiplicarmos a variável por uma constante $a$, os erros que já existiam vão se ampliar em $a$ vezes, então a dispersão vai se multiplicar por $a$ também.

#theorem([Variância em função de Esperanças])[
  $
    VV[X] = EE[X^2] - (EE[X])^2
  $
]
#proof[
  $
    VV[X] &= EE[ (X - EE[X])^2 ]    \

    &= EE[ X^2 - 2 X EE[X] + (EE[X])^2 ]    \

    &= EE[X^2] - 2 EE[X] EE[X] + (EE[X])^2    \

    &= EE[X^2] - (EE[X])^2
  $
]

Existe também a variância da soma de variáveis aleatórias! No entanto, vale ressaltar que o teorema abaixo é um *caso específico* do @variance-of-generic-variables

#theorem[
  Se $X$ e $Y$ são variáveis aleatórias independentes, então
  $
    VV[X + Y] = VV[X] + VV[Y]
  $
]
#proof[
  $
    VV[X + Y] &= EE[(X+Y)^2] - (EE[X+Y])^2    \

    &= EE[X^2 + 2 X Y + Y^2] - (EE[X] + EE[Y])^2    \

    &= EE[X^2] + 2 EE[X Y] + EE[Y^2] - (EE[X])^2 - 2 EE[X] EE[Y] - (EE[Y])^2    \

    &= EE[X^2] + 2 EE[X] EE[Y] + EE[Y^2] - (EE[X])^2 - 2 EE[X] EE[Y] - (EE[Y])^2    \

    &= EE[X^2] - (EE[X])^2 + EE[Y^2] - (EE[Y])^2    \

    &= VV[X] + VV[Y]
  $
]

== Desigualdade de Chebyshev
Essa desigualdade nos dá uma generalização da probabilidade estar distante de sua média. Vamos ver o teorema e sua demonstração, depois nós elaboramos mais

#theorem([Desigualdade de Chebyshev])[
  Sejam $X$ uma variável aleatória discreta com média $EE[X] = mu$ e desvio padrão $sigma = sigma[X]$. Denote $P = {x in RR | |x-mu| < k sigma}$, ou seja, $P$ é o intervalo aberto $(x - k sigma, x + k sigma)$. Então, para qualquer $k > 0$, temos que
  $
    PP(X in.not P) <= 1/k^2 equiv PP(|X - mu| >= k sigma) <= 1/k^2
  $
]
#proof[
  $
    VV[X] &= EE[(X - mu)^2]   \
    
    &= sum_(x) (x - mu)^2 dot PP(X=x)    \

    &= sum_(x in P) (x - mu)^2 dot PP(X=x) + sum_(x in.not P) (x - mu)^2 dot PP(X=x)    \
  $
  por conta da definição dos $x$ no intervalo $P$, temos que, para valores de $x$ que *não estão* no intervalo:
  $
    |x-mu| >= k sigma   \

    (x-mu)^2 >= k^2 sigma^2   \
  $

  logo, como a primeira parte da soma é maior que $0$, podemos fazer:
  $
    VV[X] &>= sum_(x in.not P) sigma^2 k^2 dot PP(X=x)   \

    sigma^2 &>= sigma^2 k^2 sum_(x in.not P) PP(X=x)   \

    1 &>= k^2 PP(X in.not P)   \
    
    1/k^2 &>= PP(X in.not P)   \
  $
]

Como interpretamos esse teorema então?
- Existe no máximo $1/4$ de chance de uma variável aleatória estar a mais de $2$ desvios padrões da média
- Existe no máximo $1/9$ de chance de uma variável aleatória estar a mais de $3$ desvios padrões da média
- Existe no máximo $1/16$ de chance de uma variável aleatória estar a mais de $4$ desvios padrões da média

E assim em diante para um $k$ qualquer. Ou seja, ele atribui uma probabilidade máxima de o quão bem comportada a variável aleatória é, ou seja, o quão concentrada ela está em torno da média. Quanto maior o $k$, mais difícil é que os valores da variável aleatória estejam distantes. Isso também mostra uma quantificação de *valores extremos*. Por exemplo, é *muito improvável* que, ao jogar uma moeda honesta $100$ vezes, eu consiga $90$ caras. A desigualdade de chebyshev nos dá justamente uma formalização da intuição de que, quanto mais distante da média, mais improvável é que o evento ocorra.


#pagebreak()

#align(center+horizon)[
  = Quantificadores de Independência
]

#pagebreak()

== Quantificadores de Independência
A independência de variáveis aleatórias é um conceito muito importante, mas como podemos quantificar o quão independentes duas variáveis aleatórias são? Dizer se elas são independentes com uma tabelinha de probabilidades bonitinha é muito fácil, mas e se não temos essa informação? E se nossas probabilidades são *estimadas*? E se temos uma quantidade enorme de variáveis aleatórias e queremos saber quais são independentes entre si?

#definition([Covariância])[
  A covariância de duas variáveis aleatórias discretas $X$ e $Y$ é definida por
  $
    "Cov"(X,Y) = EE[(X - EE[X])(Y - EE[Y])]
  $
]

Como essa medida indica independência? Sabemos que $X - EE[X]$ é a distância dos valores de $X$ até sua média. Quando isso é maior ou igual a $0$, então a maioria dos valores está acima da média. Quando multiplicamos isso por $Y - EE[Y]$, se o valor for positivo e grande, é um indicativo que, conforme $X$ está acima da média, $Y$ *também está* acima da média. Se o valor for negativo e grande, é um indicativo que, conforme $X$ está acima da média, $Y$ *está abaixo* da média. Se o valor for próximo de $0$, então não há uma relação clara entre as duas variáveis aleatórias. Mas vale ressaltar que a covariância mede a independência *linear* de variáveis. O fato de ela ser $0$ *não significa* que as variáveis são $100%$ independentes. Antes de mostrar isso, vamos mostrar uma forma mais prática de calcular a covariância.

#theorem([Covariância em função de Esperanças])[
  $
    "Cov"(X,Y) = EE[X Y] - EE[X] dot EE[Y]
  $
]<covariance-equals-expectation-of-product-minus-product-of-expectations>
#proof[
  $
    "Cov"(X,Y) &= EE[(X - EE[X])(Y - EE[Y])]    \

    &= EE[X Y - X EE[Y] - Y EE[X] + EE[X] EE[Y]]    \

    &= EE[X Y] - EE[X] EE[Y] - EE[Y] EE[X] + EE[X] EE[Y]    \

    &= EE[X Y] - EE[X] dot EE[Y]
  $
]

Agora sim podemos mostrar que correlação $0$ *não implica independência*, mas o contrário vale.

#theorem[
  $
    X "e" Y "são independentes" => "Cov"(X,Y) = 0
  $
  a volta não vale
]
#proof[
  Pelo @covariance-equals-expectation-of-product-minus-product-of-expectations, temos que
  $
    "Cov"(X,Y) = EE[X Y] - EE[X] dot EE[Y]
  $
  como sabemos que $X$ e $Y$ são independentes, então $EE[X Y] = EE[X] dot EE[Y]$, e portanto:
  $
    "Cov"(X,Y) = EE[X] dot EE[Y] - EE[X] dot EE[Y] = 0
  $.

  Agora se analisarmos a volta, vamos supor que $X = {1,0,-1}$ e $Y = X^2$ de forma que $PP(X=i) = 1/3$ para $i = 1,0,-1$. Conseguimos ver que $EE[X] = 0$ e $EE[X Y] = EE[X^3] = 0$, logo, temos que
  $
    "Cov"(X,Y) = EE[X Y] - EE[X] dot EE[Y] = 0 - 0 dot EE[Y] = 0
  $
  No entanto, vamos checar a condição de independência:
  $
    PP(X=0,Y=0) = PP(X=0) = 1/3   \

    PP(X=0) dot PP(Y=0) = 1/3 dot 1/3 = 1/9
  $
  logo, $X$ e $Y$ *não são independentes*
]

== O Problema de Escala da Covariância
A covariância é muito útil, mas ela tem um problema, a *escala*. Vamos ver isso na prática com alguns exemplos

#example[
  Sejam $X$ a altura de uma população e $Y$ o peso dessa população. Se $X$ é medido em _m_ e $Y$ em _kg_, poderíamos obter uma covariância de
  $
    "Cov"(X,Y) = 0.7 "m" dot "kg"
  $
  No entanto, se mudarmos a unidade de medida de $X$ para _cm_ e $Y$ para _g_, teríamos
  $
    "Cov"(100 dot X, 1000 dot Y) = 100 dot 1000 "Cov"(X, Y) = 70000 "cm" dot "g"
  $
  Essas covariâncias representam a *mesma relação*, mas os números são completamente diferentes. Enquanto o primeiro aparenta ser uma correlação baixa, o segundo aparenta ser uma correlação altíssima.
]

Para resolver esses problemas de escala e dificuldade de interpretabilidade, nós utilizamos uma outra medida, a *correlação*.

#definition([Correlação])[
  A correlação de duas variáveis aleatórias discretas $X$ e $Y$ é definida por
  $
    rho(X,Y) = frac("Cov"(X,Y), sigma[X] dot sigma[Y])
  $
]

A principal vantagem da correlação é que ela é *adimensional*, ou seja, ela não depende da unidade de medida das variáveis aleatórias. Além de se situar no intervalo $[-1, 1]$.

== Aprofundamento: Covariância como Produto Interno
Esse tópico é um aprofundamento e preparação para futuras demonstrações dentro desse capítulo, se necessário, pode pular esse tópico na primeira leitura. Antes de provarmos algumas das propriedades da correlação (juntamente com a covariância), vamos definir ambas com um pouco de *álgebra linear*. Vamos definir a covariância como um *produto interno*.

#theorem([Covariância como Produto Interno])[
  Sejam $X$ e $Y$ variáveis aleatórias discretas, então a covariância entre $X$ e $Y$ pode ser interpretada como o produto interno entre dois vetores.
]<covariance-as-inner-product>
#proof[
  Sejam $X = {x_i}|_(i=1)^m$ e $Y = {y_i}|_(i=1)^n$, defina a matriz de probabilidade:
  $
    mat(
      p_(1 1), p_(1 2), ..., p_(1 n);
      p_(2 1), p_(2 2), ..., p_(2 n);
      dots.v, dots.v, dots.down, dots.v;
      p_(m 1), p_(m 2), ..., p_(m n)
    )
  $
  de forma que $PP(X = x_i, Y = y_j) = p_(i j)$. Defina também os vetores
  $
    v_X &= mat(x_1, x_1, ..., x_1, x_2, x_2, ..., x_2, ..., x_m, x_m, ..., x_m)^T   \
    v_Y &= mat(y_1, y_2, ..., y_n, y_1, y_2, ..., y_n, ..., y_1, y_2, ..., y_n)^T
  $
  e os vetores *resíduos*
  $
    r_X &= v_X - EE[X] dot bb(1)   \
    r_Y &= v_Y - EE[Y] dot bb(1)
  $
  onde $bb(1)$ é o vetor coluna de números $1$ do tamanho do vetor $v_X$ e $v_Y$. Vamo definir $omega(x, y)$ como o seguinte produto interno:
  $
    omega(x, y) = sum_(i,j) x_i y_j p_(i j)
  $
  segue a demonstração que essa função é um produto interno: Para ela ser um produto interno, é necessário satisfazer:
  $
    omega(x, y) = omega(y, x)   \

    omega(alpha x + beta y, z) = alpha omega(x , z) + beta omega(y, z)   \

    omega(x, x) >= 0 quad omega(x, x) = 0 <=> x = 0
  $
  Para a primeira condição:
  $
    sum_(i,j) x_i y_j p_(i j) = sum_(j,i) y_j x_i p_(j i)
  $
  Para a segunda condição:
  $
    omega(alpha x + beta y, z) &= sum_(i,j) (alpha x_i + beta y_i) z_j p_(i j)    \

    &= sum_(i,j) alpha x_i z_j p_(i j) + sum_(i,j) beta y_i z_j p_(i j)    \

    &= alpha sum_(i,j) x_i z_j p_(i j) + beta sum_(i,j) y_i z_j p_(i j)    \

    &= alpha omega(x , z) + beta omega(y, z)
  $
  Para a terceira condição: Perceba que $omega(x,y) = EE[X Y]$, logo, $omega(x, x) = EE[X^2] >= 0$ e é igual a $0$ se, e somente se, $X = 0$.

  Mostrado que essa função é um produto interno, podemos ver que a covariância é justamente o produto interno entre os vetores de resíduos:
  $
    omega(r_X, r_Y) &= sum_(i,j) (x_i - EE[X]) (y_j - EE[Y]) p_(i j)    \
    &= EE[(X - EE[X])(Y - EE[Y])]    \
    &= "Cov"(X,Y)
  $
]

== Propriedades
Agora que sabemos que a covariância é um produto interno, podemos utilizar essa relação para demonstrar outras propriedades da covariância. Nem todas as propriedades aqui enunciadas utilizam dessa definição, mas já preparamos o terreno para não dividir em vários tópicos de propriedade.

#theorem[
  $
    "Cov"(X,Y) = "Cov"(Y,X)   \
    "Cov"(X,X) = VV[X]   \
    "Cov"(alpha X + beta Y, Z) = alpha "Cov"(X,Z) + beta "Cov"(Y,Z)   \
  $
]
#proof[
  Segue da definição de produto  interno
]

#theorem[
  $
    -1 <= rho(X,Y) <= 1
  $
]
#proof[
  Utilizando os vetores resíduos que definimos na demonstração do @covariance-as-inner-product, temos que
  $
    cos theta = omega(r_X, r_Y) / (||r_X|| ||r_Y||) = "Cov"(X,Y) / (sigma[X] dot sigma[Y]) = rho(X,Y)
  $
]

#theorem[
  $
    VV(X + Y) = VV[X] + VV[Y] + 2 "Cov"(X,Y)
  $
]<variance-of-generic-variables>
#proof[
  $
    VV[X+Y] &= EE[(X+Y)^2] - (EE[X+Y])^2    \
    &= EE[X^2 + 2 X Y + Y^2] - (EE[X])^2 - 2 EE[X] EE[Y] - (EE[Y])^2    \
    &= EE[X^2] + 2 EE[X Y] + EE[Y^2] - (EE[X])^2 - 2 EE[X] EE[Y] - (EE[Y])^2    \
    &= EE[X^2] - (EE[X])^2 + EE[Y^2] - (EE[Y])^2 + 2 (EE[X Y] - EE[X] dot EE[Y])    \
    &= VV[X] + VV[Y] + 2 "Cov"(X,Y)
  $
]

#theorem[
  $
    "Cov"(a X + b, Y) = a "Cov"(X,Y)   \
  $
]
#proof[
  $
    "Cov"(a X + b, Y) &= EE[(a X + b - EE[a X + b])(Y - EE[Y])]    \

    &= EE[(a X + b - (a EE[X] + b))(Y - EE[Y])]    \

    &= EE[(a X - a EE[X])(Y - EE[Y])]    \

    &= a EE[(X - EE[X])(Y - EE[Y])]    \

    &= a "Cov"(X,Y)
  $
]

#theorem[
  $
    rho(a X + b, Y) = cases(
      rho(X,Y) quad a > 0,
      -rho(X,Y) quad a < 0
    )
  $
]
#proof[
  $
    rho(a X + b, Y) &= "Cov"(a X + b, Y) / (sigma[a X + b] dot sigma[Y])    \

    &= (a "Cov"(X,Y)) / (|a| sigma[X] dot sigma[Y])
  $
  e temos que
  $
    a/(|a|) = "sign"(a)
  $
]

#pagebreak()

#align(center+horizon)[
  = Distribuições de Variáveis Aleatórias Discretas
]

#pagebreak()

== O que é uma distribuição?
Até o momento, o curso apresentou problemas que requerem um certo pensamento crítico e racicínio lógico. As distribuições vem para nos dar uma forma de *automatizar* o raciocínio que fizemos até agora. Elas são funções matemáticas que descrevem o comportamento de variáveis aleatórias, ou seja, elas nos dão a probabilidade de cada valor que a variável aleatória pode assumir.

== Bernoulli
Começamos com a distribuição mais simples, a *bernoulli*. Sempre que você encontrar situações que a variável assume apenas dois valores possíveis (_sim_ e _não_, _cara_ e _coroa_, _sucesso_ e _fracasso_), você pode modelar isso com uma distribuição de bernoulli. A distribuição de bernoulli é a base para muitas outras distribuições, como a binomial, a geométrica, a hipergeométrica, entre outras.

#definition([Distribuição de Bernoulli])[
  Uma variável aleatória discreta $X$ segue uma distribuição de bernoulli com parâmetro $p in [0,1]$ quando sua função de massa de probabilidade é dada por
  $
    p_X (x) = cases(
      p quad x = 1,
      1 - p quad x = 0,
      0 quad "otherwise"
    )
  $

  Denotamos como
  $
    X ~ "Bernoulli"(p)
  $
]

Essa distribuição é muito útil para modelar eventos que podem ter apenas dois resultados, como cara ou coroa, sucesso ou fracasso, sim ou não, etc. Ela parece até bem bobinha, mas ela é a base para muitas outras distribuições que veremos mais a frente. Essa distribuição é a que se aplica justamente no caso de uma moeda honesta, onde $p = 1/2$, basta montarmos a variável aleatória como $1$ se for cara e $0$ se for coroa.

#theorem[
  Se $X ~ "Bernoulli"(p)$, então
  $
    EE[X] = p   \
    VV[X] = p (1 - p)
  $
]<mean-and-variance-of-bernoulli>
#proof[
  $
    EE[X] &= 1 dot p + 0 dot (1 - p) = p   \

    VV[X] &= EE[X^2] - (EE[X])^2 = p - p^2 = p (1 - p)
  $
]

== Binomial
A partir de agora, vamos definir cada distribiução a partir de uma *história*, dessa forma, não ficamos limitados apenas à função de massa daquela distribuição, mas ao que essa distribuição significa. Sempre que um problema indicar que ele quer contar *de quantas formas* um evento pode ocorrer, ou *quantas vezes* um evento ocorre, provavelmente ele está pedindo para modelar o problema com uma distribuição binomial.

#definition([Distribuição Binomial])[
  Suponha que $n$ tentativas de Bernoulli independentes sejam realizadas, cada uma com a mesma probabilidade $p$ de sucesso. Seja $X$ o *número de sucessos* nessas $n$ jogadas, a distribuição de $X$ é chamada de _"binomial"_ com parâmetros $n$ e $p$. Ela é denotada por
  $
    X ~ "Bin"(n,p)
  $
]

#theorem([PMF da Binomial])[
  Se $X ~ "Bin"(n,p)$, então a função de massa de probabilidade de $X$ é dada por
  $
    PP(X=k) = mat(n;k) p^k (1 - p)^(n - k)
  $
  para $k = 0, 1, 2, ..., n$.
]
#proof[
  Imagine que temos as letras _"S"_ e _"F"_ representando sucesso e fracasso, respectivamente. Para achar a pmf da binomial, dado sua história, podemos imaginar que temos $n$ espaços para formar uma sequência de _"S"_ e _"F"_ e queremos saber de quantas formas diferentes podemos fazer isso. Vamos supor que ocorreram $k$ sucessos, então temos que escolher $k$ espaços para colocar _"S"_ e os outros $n-k$ espaços serão preenchidos com _"F"_. Ou seja, aplicando o principio multiplicativo, a probabilidade seria
  $
    p^k (1 - p)^(n - k)
  $
  no entanto, existem $mat(n;k)$ formas diferentes de escolher os $k$ espaços para colocar _"S"_. Logo, a probabilidade total será
  $
    PP(X=k) = mat(n;k) p^k (1 - p)^(n - k)
  $
]

#theorem([Simetria da Binomial])[
  Se $X ~ "Bin"(n,p)$ e $q = 1-p$, então
  $
    n-X ~ "Bin"(n,q)
  $
]
#proof[
  Dada a história da distribuição, se $X$ é a quantidade de sucessos entre $n$ tentativas, então $n-X$ é a quantidade de fracassos entre $n$ tentativas. Como a probabilidade de fracasso é $q = 1-p$, então definindo $Y = n-X$, temos que:
  $
    PP(Y=k) = PP(n-X=k) = PP(X=n-k)   \
    
    =mat(n;n-k) p^(n-k) (1-p)^k = mat(n;k) q^k (1-q)^(n-k)
  $
]

#theorem[
  Se $X ~ "Bin"(n,p)$, então
  $
    EE[X] = n p   \
    VV[X] = n p (1 - p)
  $
]
#proof[
  Vou demonstrar a esperança de duas formas. A primeira é a mais algébrica. Expresse a esperança de $X$ como a definição:
  $
    EE[X] = sum_(k=0)^n k mat(n;k) p^k (1 - p)^(n - k)
  $
  pelo @choice-of-leader, podemos reescrever o somatório como
  $
    EE[X] = sum_(k=1)^n n mat(n-1;k-1) p^k (1 - p)^(n - k)
  $
  se tormarmos $j=k-1$, também podemos reescrever o somatório como
  $
    EE[X] &= n sum_(j=0)^(n-1) mat(n-1;j) p^(j+1) (1 - p)^(n - 1 - j)   \

    &= n p sum_(j=0)^(n-1) mat(n-1;j) p^j (1 - p)^(n - 1 - j)   \
  $
  perceba que o somatório ao lado é a soma de todas as probabilidades de uma distribuição binomial com parâmetros $n-1$ e $p$, logo, o somatório é igual a $1$. Portanto, temos que
  $
    EE[X] = n p
  $
  A forma mais intuitiva é utilizando a história da distribuição. Lembra que falamos que ela é a *realização de múltiplas bernoullis independentes*? Como a Bernoulli pode ser expressa como $0$ para fracasso e $1$ para sucesso, podemos expressar a variável aleatória $X$ como a soma de $n$ variáveis aleatórias independentes de Bernoulli, ou seja,
  $
    X = II_1 + II_2 + ... + II_n
  $
  onde $II_j ~ "Bernoulli"(p)$. Assim, a soma dessas variáveis será exatamente a quantidade de sucessos. Aplicando a linearidade da esperança, temos que
  $
    EE[X] = EE[II_1 + II_2 + ... + II_n] = EE[II_1] + EE[II_2] + ... + EE[II_n] = p + p + ... + p = n p
  $

  Para a variância, podemos utilizar a mesma ideia. Como as variáveis aleatórias de Bernoulli são independentes, temos que
  $
    VV[X] &= VV[II_1 + II_2 + ... + II_n]   \
    
    &= VV[II_1] + VV[II_2] + ... + VV[II_n]   \
    
    &= p (1 - p) + p (1 - p) + ... + p (1 - p)    \
    
    &= n p (1 - p)
  $
]

== Hípergeométrica
Essa é uma das mais confusas, pois sua história é bem longa, mas vamos simplificar ao máximo. Quando você conseguir associar um problema com retirar elementos de *dois grupos diferentes* (sem reposição), então você está diante de uma distribuição hípergeométrica.

#definition([Distribuição Hípergeométrica])[
  Suponha que tenhamos *uma urna* com $w$ *bolas brancas* e $b$ *bolas pretas*. Se tirarmos $n$ bolas da urna _com reposição_, isso nos dá uma distribuição binomial para o número de bolas brancas que tiramos. No entanto, se tirarmos $n$ bolas da urna *sem reposição*, e $X$ for a quantidade de bolas brancas retiradas, então ela segue uma distribuição hípergeométrica, denotada como
  $
    X ~ "HGeo"(w, b, n)
  $
]

#theorem([PMF da Hípergeométrica])[
  Se $X ~ "HGeo"(w, b, n)$, então a função de massa de probabilidade de $X$ é dada por
  $
    PP(X=k) = frac(mat(w;k) mat(b;n-k), mat(w+b;n))
  $
  para $k = max(0, n-b), ..., min(n, w)$.
]
#proof[
  Temos no total, $w+b$ bolas, e vamos retirar $n$ no total, então nosso espaço amostral é o total de combinação que podemos fazer com $n$ bolas dentre $w+b$, ou seja, $mat(w+b;n)$. Agora, para que tenhamos exatamente $k$ bolas brancas, precisamos escolher $k$ bolas dentre as $w$ brancas e $n-k$ bolas dentre as $b$ pretas. Pelo principio multiplicativo, temos que o número de combinações possíveis é $mat(w;k) dot mat(b;n-k)$.
]

#theorem([Simetria da Hípergeométrica])[
  As distribuições
  $
    X ~ "HGeo"(w, b, n)   \
    Y ~ "HGeo"(n, w+b-n, w)
  $
  são idênticas
]
#proof[
  Pela história da distribuição, $X$ é a quantidade de bolas brancas retiradas dentre $n$ bolas retiradas de uma urna com $w$ bolas brancas e $b$ bolas pretas. Se nós criarmos um conjunto de etiquetas, e colocarmos nas bolas, de forma que, se a bola *possui* uma etiqueta, então nós tiramos ela quando estávamos amostrando as bolas, então sabemos que de todas as $w+b$ bolas, $n$ tem a etiqueta e $w+b-n$ *não tem*. Com isso em mente, podemos afirmar que $Y$ representa a quantidade de formas possíveis de escolher $w$ e que essas $w$ bolas *tem a etiqueta*, ou seja, são as bolas que foram retiradas. Logo, a quantidade de bolas brancas retiradas é a mesma que a quantidade de bolas com etiqueta dentre as $w$ bolas brancas. Portanto, as distribuições são idênticas.
]

#theorem[
  Se $X ~ "HGeo"(w, b, n)$, então
  $
    EE[X] = n w/(w+b)   \
    VV[X] = n w/(w+b) b/(b+w) (w + b - n)/(w + b - 1)
  $
]
#proof[
  Vamos numerar as bolas brancas de $1$ até $w$, e definir
  $
    II_j = cases(
      1 quad "bola branca" j "foi retirada",
      0 quad "bola branca" j "não foi retirada"
    )
  $
  definindo essa variável indicadora, podemos expressar a variável aleatória $X$ como
  $
    X = II_1 + II_2 + ... + II_w
  $
  vale ressaltar que $X$ *não é binomial*, pois as variáveis aleatórias $II_j$ *não são independentes*. No entanto, podemos utilizar a linearidade da esperança para calcular a esperança de $X$:
  $
    EE[X] = EE[sum_(j=1)^w II_j] = sum_(j=1)^w EE[II_j] = sum_(j=1)^w PP(I_j=1)
  $
  como cada bola tem a mesma probabilidade de ser retirada, temos que
  $
    PP(I_j=1) = n / (w + b)
  $
  logo
  $
    EE[X] = n w / (w + b)
  $

  Para a variância, aplicamos ela em $X$, mas como $II_j$ não são independentes, precisamos aplicar a correção com covariância conforme enunciado no @variance-of-generic-variables:
  $
    VV[X] &= VV[sum_(j=1)^w II_j]   \

    &= sum_(j=1)^w VV[II_j] + 2 sum_(i<j) "Cov"(II_i, II_j)   \
  $
  como $II_j$ é bernoulli, pelo @mean-and-variance-of-bernoulli, temos que
  $
    VV[II_j] = n/(w+b) (1 - n/(w+b))
  $
  já para a covariância entre duas variáveis aleatórias $II_i$ e $II_j$, temos que
  $
    "Cov"(II_i, II_j) = EE[II_i II_j] - PP(II_i=1) dot PP(II_j=1)
  $
  pela definição de $II_i$ e $II_j$, $EE[II_i II_j] = 1$ apenas quando ambos são $1$, logo
  $
    EE[II_i II_j] = PP(II_i=1, II_j=1)
  $
  Para que ambas as bolas apareçam na mesma amostragem, precisamos escolher $n-2$ bolas dentre as $w+b-2$ restantes, logo
  $
    PP(II_i=1, II_j=1) = mat(w+b-2;n-2) / mat(w+b;n) = (n (n-1))/((w+b) (w+b-1))
  $
  logo
  $
    "Cov"(II_i, II_j) = (n (n-1))/((w+b) (w+b-1)) - n^2/(w+b)^2 = - (n (w+b-n))/((w+b)^2 (w+b-1))
  $
  voltando para a variância de $X$, o termo abaixo
  $
    2 dot sum_(i<j) "Cov"(II_i, II_j) &= 2 mat(w;2) (- (n (w+b-n))/((w+b)^2 (w+b-1)))    \
    
    &= - w (w-1) n (w+b-n)/((w+b)^2 (w+b-1))
  $
  somando tudo
  $
    VV[X] &= n w/(w+b) (1 - n/(w+b)) - w (w-1) n (w+b-n)/((w+b)^2 (w+b-1))    \

    &= n w/(w+b) - n^2 w / (w+b)^2 - w (w-1) n (w+b-n)/((w+b)^2 (w+b-1))    \

    &= (w n (w+b-n))/((w+b)^2) (1 - (w-1)/(w+b-1))    \

    &= (w n (w+b-n))/((w+b)^2) (b)/(w+b-1)    \
  $
  reorganizando
  $
    VV[X] = n w/(w+b) b/(b+w) (w + b - n)/(w + b - 1)
  $
]

== Geométrica
Sempre que o seu problema puder ser associado com uma quantidade de tentativas até que um evento ocorra, você pode modelar o problema com uma distribuição geométrica. Ela é muito útil para modelar problemas de confiabilidade, como a quantidade de tentativas até que um equipamento falhe, ou a quantidade de tentativas até que um paciente se recupere.

#definition([Distribuição Geométrica])[
  Suponha que tenhamos uma sequência de tentativas de Bernoulli independentes, cada uma com a mesma probabilidade $p$ de sucesso. Seja $X$ o número de tentativas *até o primeiro sucesso* (inclusivo, ou seja, a tentativa do sucesso em si entra na contagem), a distribuição de $X$ é chamada de _"geométrica"_ com parâmetro $p$. Ela é denotada por
  $
    X ~ "Geom"(p)
  $
]

#theorem([PMF da Geométrica])[
  Se $X ~ "Geom"(p)$, então a função de massa de probabilidade de $X$ é dada por
  $
    PP(X=k) = (1 - p)^(k - 1) p
  $
  para $k = 1, 2, 3, ...$.
]
#proof[
  Cada jogada que realizarmos terá a probabilidade $1-p$ de falhar, logo, se queremos que o número de jogadas seja $k$, precisamos que as primeiras $k-1$ jogadas falhem e a última jogada seja um sucesso. Pela regra do produto, temos que a probabilidade de isso acontecer é
  $
    (1-p)^(k - 1) p
  $
]

#theorem[
  Se $X ~ "Geom"(p)$, então temos que
  $
    EE[X] = 1/p   \
    VV[X] = (1-p)/p^2
  $
]
#proof[
  Sabemos que a função $f(x) = 1/(1-x)$ converge e pode ser expressa como uma série geométrica, ou seja,
  $
    1/(1-x) = sum_(k=0)^infinity x^k
  $
  com $|x| < 1$. Derivando ambos os lados, temos que
  $
    (dif f)/(dif x) &= 1/(1-x)^2    \

    &= 1 + 2x + 3x^2 + 4x^3 + ...    \
    
    &= sum_(k=1)^infinity k x^(k-1)
  $
  e que a segunda derivada é tal que
  $
    (dif^2 f)/(dif x^2) &= 2/(1-x)^3    \

    &= 2 + 6x + 12x^2 + 20x^3 + ...    \
    
    &= sum_(k=0)^infinity k (k-1) x^(k-2)
  $
  mas o que isso tem a ver? Veja que:
  $
    EE[X] &= sum_(k=1)^infinity k (1-p)^(k-1) p = p sum_(k=1)^infinity k (1-p)^(k-1)    \

    &= p f'(1-p) = p / (1 - (1-p))^2    \
    
    &= 1/p
  $

  Para calcular a variância, vamos utilizar de um truque inteligente. Sabemos que $VV[X] = EE[X^2] - (EE[X])^2$. Vamos então calcular $EE[X(X-1)]$:
  $
    EE[X(X-1)] = EE[X^2 - X] = EE[X^2] - EE[X]
  $
  utilizando o LOTUS (@lotus-two-variables), temos que
  $
    EE[X(X-1)] &= sum_(k=0)^infinity k (k-1) (1-p)^(k-1) p    \
  $
  deixando $p$ em evidência e tirando um fator $1-p$ para fora, temos que
  $
    EE[X(X-1)] &= p (1-p) sum_(k=0)^infinity k (k-1) (1-p)^(k-2)    \

    &= p (1-p) f''(1-p) = 2 p (1-p) / (1 - (1-p))^3   \
    
    &= 2 (1-p)/p^2
  $
  e como vimos antes
  $
    EE[X^2] &= EE[X(X-1)]+EE[X]   \

    &= 2 (1-p)/p^2 + 1/p = (2 - p)/p^2
  $
  voltando para a variância, temos que
  $
    VV[X] &= EE[X^2] - (EE[X])^2    \

    &= (2 - p)/p^2 - 1/p^2 = (1-p)/p^2
  $
]

== Binomial Negativa
Muito parecida com a geométrica, no entanto, é quando o problema pode ser modelado como a quantidade de tentativas até que múltiplos eventos ocorram. Por exemplo, a quantidade de tentativas até que um paciente se recupere *duas vezes*, ou a quantidade de tentativas até que um equipamento falhe *três vezes*.

#definition([Distribuição Binomial Negativa])[
  Suponha um experimento onde eu vou realizar tentativas de Bernoulli independentes até obter $r$ *sucessos* e cada tentativa tem a mesma probabilidade $p$ de sucesso. Seja $X$ a quantidade de tentativas necessárias para obter $r$ sucessos (onde o último sucesso entra na contagem), dizemos que $X$ tem distribuição *binomial negativa* com parâmetros $r$ e $p$, denotada por
  $
    X ~ "NegBin"(r,p)
  $
]

#theorem([PMF da Binomial Negativa])[
  Se $X ~ "NegBin"(r,p)$, então a função de massa de probabilidade de $X$ é dada por
  $
    PP(X=k) = mat(k-1;r-1) p^r (1 - p)^(k - r)
  $
  para $k = r, r+1, r+2, ...$.
]
#proof[
  Seja $Y$ o número de sucesso nas primeiras $k-1$ tentativas e $Z$ o número de sucessos que ocorreram na $k$-ésima tentativa ($Z in {0,1}$). O $r$-ésimo sucesso acontece no $k$-ésimo lançamento se, e somente se, $Y=r-1$ e $Z=1$, isto é
  $
    X=k <=> Y=r-1, Z=1
  $
  Como $Y$ e $Z$ são independentes, temos que
  $
    PP(X=k) = PP(Y=r-1, Z=1) = PP(Y=r-1) dot PP(Z=1)
  $
  como $Y$ é binomial com parâmetros $k-1$ e $p$ e $Z$ é bernoulli com parâmetro $p$, temos que
  $
    PP(X=k) = mat(k-1;r-1) p^(r-1) (1 - p)^((k-1) - (r-1)) dot p = mat(k-1;r-1) p^r (1 - p)^(k - r)
  $
]

#theorem[
  Se $X ~ "NegBin"(r,p)$, então temos que
  $
    EE[X] = r/p   \
    VV[X] = r (1-p)/p^2
  $
]
#proof[
  Assim como a binomial, podemos subdividir essa variável aleatória em $r$ variáveis com outra distribuição. Se eu estou procurando $r$ sucessos, eu posso dividir como a quantidade de jogadas até o primeiro, depois até o segundo etc. E isso é exatamente a distribuição geométrica. Ou seja, podemos expressar $X$ como
  $
    X = Y_1 + Y_2 + ... + Y_r
  $
  com $Y_j ~ "Geom"(p)$

  Dessa forma, aplicando a linearidade da esperança, temos que
  $
    EE[X] = EE[sum_(j=1)^r Y_j] = sum_(j=1)^r EE[Y_j] = sum_(j=1)^r 1/p = r/p
  $
  aplicando a mesma coisa com a variância
  $
    VV[X] = VV[sum_(j=1)^r Y_j] = sum_(j=1)^r VV[Y_j] = sum_(j=1)^r (1-p)/p^2 = r (1-p)/p^2
  $
]

== Poison
Essa é um pouco mais complexa. A poisson representa a quantidade de vezes que um evento ocorre em um intervalo de tempo fixo, mas sabendo quantas vezes ele ocorre em média. Por exemplo, fixando uma janela de $6$ segundos, sabemos que em uma avenida passam em média $10$ carros, mas não sabemos quantos carros vão passar em cada janela de $6$ segundos, podem ser $10$, $100$ num dia de pico, ou até mais se acontecer algo inesperado, então não há limite para a quantidade real de contagem. Outro exemplo é, dentro de um intervalo fixo, quantas gotas de chuva vão cair em um lago? É literalmente impossível você *limitar* a quantidade de gotas, então a distribuição de poisson é perfeita para modelar esse tipo de problema.

#definition([Distribuição de Poisson])[
  Seja $lambda$ a *média* da quantidade de eventos que ocorrem em um intervalo de tempo fixo e $X$ é a variável aleatória que representa quantas vezes o evento ocorreu nesse mesmo intervalo de tempo, então dizemos que $X$ segue uma distribuição de Poisson com parâmetro $lambda$, denotada por
  $
    X ~ "Poisson"(lambda)
  $
]

#theorem([PMF da Poisson])[
  Se $X ~ "Poisson"(lambda)$, então a função de massa de probabilidade de $X$ é dada por
  $
    PP(X=k) = frac(lambda^k e^(-lambda), k!)
  $
  para $k = 0, 1, 2, ...$.
]
#proof[
  Estamos avaliando a ocorrência de um evento dentro de um intervalo de tempo fixo. Isso significa que eu posso realizar esse evento uma quantidade $n$ de vezes, no entanto, como o intervalo de tempo não é finito, podemos assumir que $n$ pode ser extendido ao infinito (pois eu não consigo afirmar quantas tentativas podem acontecer dentro do intervalo de tempo. Uma milisegundo? Uma hora? Uma semana? $1000$ por milisegundo?). Então nós vamos pegar a distribuição binomial e vamos estender ela ao infinito. Sabemos que
  $
    PP(X=x) &= (n!)/((n-x)! x!) (p^x) (1-p)^(n-x)    \

    &= (n!)/((n-x)! x!) dot p^x dot n^x/n^x (1-(n p)/n)^(n-x)    \

    &= (n p)^x / x! dot (n!)/((n-x)! n^x) (1-(n p)/n)^(n) (1-(n p)/n)^(-x)    \
  $
  tendendo $n$ ao infinito, temos que
  $
    lim_(n->infinity) PP(X=x) &= lim_(n->infinity) (n p)^x / x! dot underbrace( (n!)/((n-x)! n^x) , "I") underbrace( (1-(n p)/n)^(n) , "II") underbrace( (1-(n p)/n)^(-x) , "III")    \
  $
  pelo teorema da multiplicação de limites, podemos separar o limite em três partes. Vamos analisar cada uma separadamente.

  *I*:
  $
    lim_(n->infinity) (n!)/((n-x)! n^x) &= lim_(n->infinity) (n (n-1) (n-2) ... (n-x+1))/n^x   \
    
    &= lim_(n->infinity) (1 - 1/n) (1 - 2/n) ... (1 - (x-1)/n)    \
    
    &= 1
  $

  *II*:
  $
    lim_(n->infinity) (1-(n p)/n)^(n)
  $
  queremos fixar $EE[X] = n p = lambda$ como fixo
  $
    lim_(n->infinity) (1-(n p)/n)^(n) = lim_(n->infinity) (1-lambda/n)^(n) = e^(-lambda)
  $

  *III*:
  $
    lim_(n->infinity) (1-(n p)/n)^(-x) = lim_(n->infinity) (1-lambda/n)^(-x) = 1
  $

  logo, voltando para a fórmula original, temos que
  $
    lim_(n->infinity) PP(X=x) = lambda^x e^(-lambda)/x!
  $
]

#theorem[
  Se $X ~ "Poisson"(lambda)$, então temos que
  $
    EE[X] = lambda    \
    VV[X] = lambda
  $
]
#proof[
  $
    EE[X] &= sum_(k=0)^infinity k e^(-lambda) lambda^k / k!   \

    &= e^(-lambda) sum_(k=0)^infinity lambda^k / (k-1)!   \
  $
  sabemos pela definição de $e^x$ que
  $
    e^x = sum_(k=0)^infinity x^k / k!
  $
  e tirando a derivada, que
  $
    e^x = sum_(k=0)^infinity k x^(k-1) / k!
  $
  note que ao multiplicarmos por $lambda$, temos
  $
    lambda e^lambda = sum_(k=0)^infinity k lambda^k / k!
  $
  logo
  $
    EE[X] = e^(-lambda) lambda e^lambda = lambda
  $

  Já para a variância, podemos utilizar o mesmo truque
  $
    VV[X] = EE[X^2] - (EE[X])^2
  $
  analisando $EE[X^2]$
  $
    EE[X^2] &= sum_(k=0)^infinity k^2 e^(-lambda) lambda^k / k!   \
  $
  vimos a derivada da função $e^x$ e podemos tirar a segunda derivada, que é
  $
    e^x = sum_(k=0)^infinity k (k-1) x^(k-2) / k!
  $
  ou seja, temos que
  $
    lambda^2 e^lambda = sum_(k=0)^infinity k (k-1) lambda^k / k!
  $
  logo
  $
    EE[X^2] = e^(-lambda) (lambda^2 e^lambda + lambda e^lambda) = lambda^2 + lambda
  $
  então
  $
    VV[X] = EE[X^2] - (EE[X])^2 = lambda^2 + lambda - lambda^2 = lambda
  $
]
