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
    Revisão para A2
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

#align(center+horizon)[
  = Variáveis Aleatórias Contínuas
]

#pagebreak()

== O Problema da abordagem Discreta
Até o momento, vimos as variáveis discretas, que assumem valores que *podem ser contados*. A quantidade de caras e coroas numa série de jogadas, quantas jogadas são necessárias até que eu consiga obter um sucesso em um experimento, assim por diante.

No entanto, considere que queremos saber a probabilidade de um *ser humano* ter *$1,80$m* de altura. Nós *não conseguimos representar esse experimento usando variáveis discretas*, já que a altura do ser humano não é um valor discreto, mas um valor *contínuo*.

É nesse contexto que introduzimos as variáveis aleatórias *contínuas*

#definition("Variável Aleatória Contínua")[
  Uma variável aleatória contínua é uma função
  $
    X: S -> RR
  $
  que associa a cada resultado do espaço amostral $S$ um número real, tal que seu conjunto de valores assumidos ($"Im"(X)$) é *não enumerável*
]

#example[
  Dado um experimento que queremos saber em quanto tempo um carro leva para chegar do local $A$ ao local $B$, o tempo é uma medida *contínua*, logo:
  $
    X = "tempo para o carro sair do ponto A ao B"
  $
  é uma variável contínua
]

== Função de Massa Acumulada
Lembra que nas variáveis discretas, tinhamos definido a função de massa como sendo a probabilidade de cada valor que $X$ pode assumir?
$
  PP(X=x)
$
acontece que essa definição é *inútil* dentro das variáveis contínuas. Por quê? Pela definição básica de probabilidade, nós fazemos
$
  PP(X=x) = ("Quando X assume x")/("Todos os valores possíveis de X")
$
no entanto, como a quantidade de valores que $X$ pode assumir é *infinita*, acaba que, por definição:
$
  PP(X=x) = 0
$
Como podemos trabalhar com essas variáveis então? É aí que entra a *função de massa acumulada*, em vez de pegarmos quando o valor específico acontece, pegamos a probabilidade de obter *valores menores ou iguais a ele*.
$
  F_X (x) = PP(X<=x)
$

Imagine o intervalo $[0,100)$. Queremos sortear um valor desse intervalo ($X in [0,100)$). Como já falamos, se formos falar, por exemplo, de $PP(X=2)=0$ por definição de variável contínua. Vamos supor que cada um dos valores desse intervalo tem igual chance de ser sorteado.

Levando isso em conta e que a função de massa acumulada de $X$ deve seguir as seguintes propriedades:
- $F_X (x)$ é não-decrescente
- $lim_(x->-infinity) F_X (x) = 0$ e $lim_(x->infinity) F_X (x) = 1$

Podemos idealizar uma função acumulada para esse cenário (de forma intuitiva). Como cada valor é igualmente provável, então faz sentido que, conforme a gente vai aumentando $x$ em $F_X (x)$ a função vai seguindo linearmente pra cima, já que é como se, a cada valor, a mesma proabilidade vai se somando com as anteriores. Dessa forma bem intuitiva de se pensar, podemos chegar na seguinte função:
$
  F_X (x) = cases(
    0 "se" x < 0,
    x/100 "se" 0 <= x <= 100,
    1 "se" x > 100
  )
$

Mas antes de prosseguirmos, eu enunciei as propriedades anteriores, mas por que elas são válidas? A primeira propriedade diz que $F_X (x)$ deve ser não-crescente, mas por quê? De uma forma intuitiva *(para ficar matematicamente correta, tem que ter algumas modificações)*, é como se $F_X (x)$ pudesse ser reescrita assim:
$
  PP(X<=x) &= PP(X<=x-1) + PP(X=x)   \

  F_X (x) &= F_X (x-1) + PP(X=x)
$

Então a cada novo valor que eu adiciono, a função cresce, do contrário, eu precisaria que $PP(X=x)$ fosse *negativo*, o que é impossível. Reforçando que isso é uma abordagem intuitiva e não está matematicamente correta.

A segunda propriedade fala sobre a função ser limitada em $1$ superiormente e em $0$ inferiormente. Seguindo na mesma lógica de uma argumentação não-rigorosa e intuitiva, em um experimento, temos o espaço amostral dos nossos eventos. A probabilidade de que *algum evento ocorra* é sempre $1$, e essa probabilidade pode ser representada como a soma das probabilidades de todos os eventos possíveis no meu espaço amostral (algo como _ou valor $x$, ou valor $y$, ou valor $z$, ..._ para todos os valores do espaço amostral). Aqui é a mesma lógica, conforme nós aumentamos o $x$ em $F_X (x)$, estamos cada vez mais, entre várias aspas, "chegando no limite do espaço amostral", então a função acumulada vai se aproximar cada vez mais de $1$, a mesma lógica vale para conforme diminuímos o valor de $x$.

== Função de Densidade
A visão intuitiva é muito legal, mas temos que começar a ver definições mais rigorosas. Uma definição muito importante é a *função de densidade* (que nada mais é que a derivada da função acumulada)

#definition("Função de Densidade de Probabilidade")[
  Seja $X$ uma variável aleatória contínua, definimos sua função de densidade de probabilidade como:
  $
    f_X (x) = dif / (dif x) F_X (x)
  $
]
#example[
  Usando o exemplo do início do capítulo
  $
    F_X (x) = cases(
      0 "se" x < 0,
      x/100 "se" 0 <= x <= 100,
      1 "se" x > 100
    )
  $
  temos que a sua fdp é dada por
  $
    f_X (x) = cases(
      0 "se" x < 0,
      1/100 "se" 0 <= x <= 100,
      0 "se" x > 100
    )
  $
]

Essa definição é interessante pois nos permite trazer outra definição de variável aleatória contínua.

#definition("Variável Aleatória Absolutamente Contínua")[
  Dizemos que $X$ é uma variável aleatória absolutamente contínua quando $exists f_X : RR -> RR$ com $f_X (x) >= 0 space forall x$ tal que:
  $
    F_X (x) = PP(X<=x) = integral_(-infinity)^(x) f_X (t) dif t
  $
]

Aqui nesses resumos, utilizaremos apenas variáveis contínuas que se encaixen na definição de *absolutamente* contínuas, o que facilita bastante nossa vida.

Por conta dessa definição, temos algumas propriedades que derivam diretamente dela:

#theorem[
  $
    integral_(-infinity)^(+infinity) f_X (t) dif t = 1
  $
]

#theorem[
  $
    f_X (x) >= 0
  $
]

#theorem[
  $
    PP(a<=X<=b) = integral_(a)^(b) f_X (t) dif t
  $
]

Podemos agora nos perguntar se $f_X (x_0)$ tem algum significado! Afinal, $F_X (x_0)$ traz uma interpretação diretamente da definição. Primeira coisa, podemos reescrever o seguinte:
$
  f_X (x_0) dot Delta x approx integral_(x_0)^(x_0+Delta x) f_X (t) dif t = PP(X in [x_0, x_0+Delta x])
$

Ou seja, como $f_X$ representa a taxa de crescimento da função acumulada, ela indica *quais valores são mais prováveis*. Como assim? Se temos que $f_X (a)$ é relativamente baixo, no entanto, com um $epsilon > 0$, temos que $f_X (a+epsilon)$ já é um valor grande, isso indica que os números entre $a$ e $a+epsilon$ são mais prováveis (pois a taxa ser grande, quer dizer que a função acumulada ta aumentando muito rápido).

== Valor Esperado
Também temos a definição de valor esperado para variáveis contínuas!

#definition("Valor Esperado para Variáveis Contínuas")[
  Dado uma variável contínua $X$, temos que a esperança de $X$, denotada por $EE[X]$ é dada por:
  $
    EE[X] = integral_(-infinity)^(infinity) x f_X (x) dif x
  $
  desde que a integral seja bem definida (pode divergir)
]

Dessa definição, há paralelos que conseguimos fazer das definições e teoremas que vimos para variáveis discretas.

#theorem([LOTUS])[
  Seja $X$ uma variável aleatória discreta, $h$ uma função e $Y = h(X)$:
  $
    EE[Y] = EE[h(X)] = integral_(-infinity)^(infinity) y g(y) dif y = integral_(-infinity)^(infinity) h(x) f_X (x) dif x
  $
]<lotus>

Com o teorema do LOTUS, a definição de variância para $X$ sai facilmente.

#definition("Variância para Variáveis Contínuas")[
  Seja $X$ uma variável aleatória contínua, temos que sua variância é definida como
  $
    VV[X] = EE[(X - EE[X])^2] = integral_(-infinity)^infinity (x - EE[X])^2 f_X (x) dif x
  $
]


== Quantis
Também podemos definir os famosos *quantis*, que nada mais são que a definição inversa da probabilidade

#definition([q-quantil])[
  O $q$-quantil de uma variável aleatória contínua $X$ (com $q in (0,1)$), é qualquer valor $x_q$ tal que
  $
    F_X (x_q) = q
  $
]

== Moda
Outra definição interessante é a de *moda*. Para variáveis aleatórias discretas, a definição é bem direta, o valor de $X$ que maximiza $PP(X=x)$. No entanto, levar essa definição para as variáveis contínuas é meio impossível, como fazemos então?

#definition("Moda para Variáveis Contínuas")[
  A moda de uma variável contínua $X$ é o valor $x$ onde *$f_X (x)$ é máximo*, ou seja:
  $
    x "tal que" f'_X (x) = 0
  $
]

A ideia por trás dessa definição pode ser entendia na mesma ideia da explicação não-rigorosa do significado de $f_X (x_0)$. Se $f_X (x_0)$ indica como os valores próximos de $x_0$ contribuem para a probabilidade, eu quero pegar o valor que *mais contribui*, que seria justamente o que *maximiza* $f_X (x)$

== Densidades de Transformações
Em problemas reais, é muito comum acontecer de termos uma variável aleatória $X$ com uma densidade $f_X$, no entanto, queremos descobrir a densidade de uma transformação $Y = h(X)$, como fazemos?

#theorem([Densidade de uma transformação monotônica])[
  Se $X$ é uma v.a contínua com densidade $f_X (x)$ e $Y=h(X)$ com $h$ sendo uma função monotônica, então temos que a densidade de $Y$ é dada por:
  $
    f_Y (y) = (f_X (x)) / (|h'(x)|)
  $
]
#proof[
  Seja $F_X (x) = PP(X<=x)$, então $PP(Y<=y) = PP(h(X) <= h(x))$. Como $h$ é monotônica, vamos analisar ambos os casos:

  Se $h$ é *crescente*, então temos:
  $
    PP(h(X)<=h(x)) = PP(X<=x) = F_X (x) => F_X (x) = F_Y (y)
  $
  então derivando ambos os lados em relação a $x$, temos:
  $
    f_Y (h(x)) dot h'(x) = f_X (x)    \

    <=> f_Y (y) = (f_X (x)) / (h'(x))
  $

  Se $h$ é *decrescente*, então temos:
  $
    PP(h(X)<=h(x)) = PP(X>=x) = 1 - F_X (x) => 1 - F_X (x) = F_Y (y)
  $
  então derivando ambos os lados em relação a $x$, temos:
  $
    f_Y (h(x)) dot h'(x) = -f_X (x)    \

    <=> f_Y (y) = (f_X (x)) / (|h'(x)|)
  $
  Aqui eu posso colocar o módulo pois $h'(x)$ é negativo sempre ($h$ é decrescente)
]

== Desigualdade de Chebyshev
Já discorremos sobre essa desigualdade no resumo da A1, então vou apeans enunciar o teorema e sua demonstração para variáveis aleatórias contínuas.

#theorem([Desigualdade de Chebyshev])[
  Seja $X$ uma v.a contínua com valor esperado $mu = EE[X]$ e desvio-padrão $sigma = sigma(X)$, então:
  $
    PP(mu - k sigma < X < mu + k sigma) >= 1 - 1/k^2
  $
  ou
  $
    PP(|X - mu| > k sigma) <= 1/k^2
  $
]
#proof[
  $
    VV[X] = integral_(-infinity)^(infinity) (x - mu)^2 f(x) dif x    \

    = integral_(-infinity)^(mu - k sigma) (x - mu)^2 f(x) dif x + integral_(mu - k sigma)^(mu + k sigma) (x - mu)^2 f(x) dif x + integral_(mu + k sigma)^infinity (x - mu)^2 f(x) dif x     \

    >= integral_(-infinity)^(mu - k sigma) (k sigma)^2 f(x) dif x + integral_(mu + k sigma)^infinity (k sigma)^2 f(x) dif x     \

    = (k sigma)^2 (integral_(-infinity)^(mu - k sigma) f(x) dif x + integral_(mu + k sigma)^infinity f(x) dif x)    \

    = k^2 sigma^2 [ PP(X<=mu-k sigma) + PP(X>= mu + k sigma) ]    \

    = k^2 sigma^2 [ PP(|X-mu| >= k sigma) ]     \

    => 1 / k^2 >= PP(|X-mu| >= k sigma)
  $
]

#pagebreak()

#align(center+horizon)[
  = Distribuições de Variáveis Aleatórias Contínuas
]

#pagebreak()

== Distribuições
Assim como em variáveis aleatórias discretas, as contínuas também possuem distribuições pré-definidas e conhecidas. Nessa seção, vamos comentar sobre elas e suas propriedades

== Uniforme
É a distribuição contínua base, já falamos sobre ela no início do capítulo anterior! Ela é definida sobre um intervalo e a ideia é que todos os valores são igualmente prováveis de sair em um sorteio.

#definition([Distribuição Uniforme])[
  Uma variável aleatória contínua $U$ tem distribuição uniforme no intervalo $(a,b)$ se sua fdp é dada por:
  $
    f_U (u) = cases(
      1/(b-a) "se" a < x < b,
      0 "caso contrário"
    )
  $
  ou seja, $f_U (u)$ é constante. Denotamos $U ~ "Unif"(a,b)$
]

#theorem[
  Seja $U ~ "Unif"(a,b)$ e $(c,d)$ um subintervalo de $(a,b)$ com tamanho $l = d - c$, então $PP(c < U < d) prop l$
]
#proof[
  Como a fdp de $U$ é constante $1/(b-a)$, a área da fdp em baixo de $(c,d)$ é $l/(b-a)$, que é $l$ vezes a constante.
]

#theorem[
  
]
