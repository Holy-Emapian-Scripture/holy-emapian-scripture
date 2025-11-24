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
    Otimização para Ciência de Dados
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

#outline(title: "Conteúdo")

#pagebreak()

#align(center+horizon)[
  = Introdução
]

#pagebreak()

Antes de iniciarmos com o conteúdo de verdade, vou relembrar alguns conceitos importantes da A1 que vão ajudar a entender os métodos presentes nesse PDF.

#theorem("Aproximação de Primeira Ordem")[
  Quando $f$ é continuamente diferenciável, em uma vizinhança de um ponto $x$ podemos mostrar que:
  $
    forall d in RR^n "com" ||d||=1 wide space (dif f)/(dif d) = nabla f(x)^T d
  $
  e, além disso, temos:
  $
    forall y in RR^n "na vizinhança" wide f(y) = f(x) + nabla f(x)^T (y-x) + o(||y-x||)
  $
  Onde $o: RR_+ -> RR$ satisfaz $lim_(t->0^+) (o(t))/t = 0$
]<first-order-approximation>

#theorem("Aproximação Linear")[
  Seja $f: U -> RR$ uma função duas vezes continuamente diferenciável e $U subset.eq RR^n$, e seja $x in U$ e $r > 0$ tais que $B(x, r) subset U$ então:
  $
    forall y in B(x, r) space exists xi in [x, y] "tal que" \
    f(y) = f(x) + nabla f(x)^T (y - x) + 1/2 (y - x)^T nabla^2 f(xi) (y - x) 
  $
]<linear-approximation>

#theorem("Aproximação de Segunda Ordem")[
  Seja $f: U -> RR$ uma função duas vezes continuamente diferenciável e $U subset.eq RR^n$, e seja $x in U$ e $r > 0$ tais que $B(x, r) subset U$ então:
  $
    forall y in B(x, r) "vale" \
    f(y) = f(x) + nabla f(x)^T (y - x) + 1/2 (y - x)^T nabla^2 f(x) (y - x) + o(||y-x||^2)
  $
]<second-order-approximation>

#pagebreak()

#align(center+horizon)[
  = Método do Gradiente
]

#pagebreak()

== Caso Global
É o método de otimização mais clássico que existe! Vamos supor que queremos resolver o problema:
$
  min_(x in RR^n) f(x)
$

Lembra do que vimos em cálculo? Que $gradient f(x)$ é o vetor que aponta pra direção em que $f(x)$ aumenta? Então que tal a gente seguir na direção contrária a $f(x)$? Isso faz bastante sentido, e funciona! Mas deve ter um motivo mais matemático por trás, não é? Vamos primeiro mostrar o algoritmo:

#figure(
  pseudocode-list(
    booktabs: true
  )[
    + *func* GradientDescent($f$) {
      + $x^((0)) in RR^n$
      + $alpha > 0$
      + *for* $t in [T]$ *do* {
        + $x^((t+1)) = x^((t)) - alpha gradient f(x^((t)))$
      +  }
      + *return* $x^((T))$
    + }
  ],
  supplement: [Algoritmo],
  caption: [Gradient Descent]
)<gradient-descent>

Antes de entender um motivo mais matemático por trás do algoritmo, vamos ver algumas definições

#definition([Funções $M$-Lipschitz])[
  Dizemos que uma função $f: RR^n -> RR^m$ é $M$-Lipschitz quando:
  $
    ||f(x)-f(y)|| <= M ||x-y|| wide forall x, y in RR^n
  $
]<m-lipschitz>

#definition([Função $L$-Suave])[
  Uma função $f: RR^n -> RR$ é $L$-suave quando seu gradiente é $L$-Lipschitz:
  $
    ||gradient f(x) - gradient f(y)|| <= L ||x - y|| wide forall x,y in RR^n
  $
]<l-suave>

Essa definição de suavidade tem uma interpretação, imagine que, se eu estou na posição $x$ e vou pra posição $y$, a variação que eu vou ter na função, dentro dessa passada, não ultrapassa o quanto eu andei vezes uma constante $L$. Então funções muito onduladas, e com ondulações

#figure(
  image("images/func-nao-suave.png", width: 30%),
  caption: [Função bem desregular, mas suave, $f(x) = sin(10x)+cos(10y)$]
)

#theorem("Aproximação linear de funções suaves")[
  Seja $f: RR^n -> RR$ uma função diferenciável. Então $f$ é $L$-suave se, e somente se, $forall x, y in RR^n$:
  $
    |f(y)-f(x)+gradient f(x) ^T (y - x)|<= L/2 ||y-x||^2_2
  $
]

Usando esse teorema, a gente pode escrever isso:
$
  f(x^((t+1))) &<= f(x^((t))) + gradient f(x^((t)))^T (x^((t+1))-x^((t))) + L/2 ||x^((t+1))-x^((t))||^2   \
  &<= f(x^((t))) - alpha ||gradient f(x^((t)))||^2 + (alpha^2 L)/2 ||gradient f(x^((t)))||^2    \
  &<= f(x^((t))) - alpha (1 - (alpha L)/2) ||gradient f(x^((t)))||^2
$<iterated-aproximation>

E isso vale quando $alpha in (0, 2/L)$, ou seja, se o ponto atual $x^((t))$ *NÃO É ESTACIONÁRIO*, o valor da função no próximo ponto será *menor* que o valor do ponto atual menos o tamanho do gradiente ao quadrado vezes um termo de regulação. Parece complicado, mas o que isso quer dizer? Eu vou usar esse fato para mostrar que, independente do ponto que eu iniciar o método do gradiente, eu *sempre vou encontrar um ponto mínimo local utilizando o método do gradiente*

#theorem("Convergência do Gradient Descent")[
  Suponha que $f: RR^n -> RR$ é $L$-suave. Tome qualquer passo:
  $
    alpha = beta/L
  $
  para algum $beta in (0, 2)$. Então:
  $
    min_(t in [T])||gradient f(x^((t)))||^2_2 <= 1/T sum^(T)_(t=1) ||gradient f(x^((t)))||^2_2 <= ((2\/beta)/(2-beta)) (L(f(x^((1))) - f^*))/(T)
  $
]<gradient-descent-convergence>
#proof[
  Sabemos que, dado $n$ pontos $x_i$, a média $1/n sum^n_(i=1)x_i in [min(x_i), max(x_i)]$, então a desigualdade inicial já está provada. Vamos provar a segunda. Usando a equação @iterated-aproximation, temos que:
  $
    alpha (1 - (alpha L)/2) ||gradient f(x^((t)))||^2 <= f(x^((t))) - f(x^((t+1)))
  $
  isso para todo $t in [T]$, então vamos somar todos os termos para obter:
  $
    alpha (1 - (alpha L)/2) sum^(T)_(t=1)||gradient f(x^((t)))||_2^2 &<= sum^(T)_(t=1) (f(x^((t))) - f(x^((t+1))))   \
    
    &<= f(x^((1))) - f(x^((T+1)))   \

    &= f(x^((1))) - f^* + f^* + f(x^((T+1)))    \

    &<= f(x^((1))) - f^*
  $
  A primeria desigualdade eu fiz uma soma telescópica, depois eu somei $0$ ($f^* - f^*$) e, como $f^*$ é o valor mínimo da função, com certeza subtrair a parte que eu somei $f^*$ vai dar um valor maior, então eu obtenho o resultado do enunciado do teorema dividindo tudo por $alpha(1-(alpha L)/2)T$
]

Por que esse teorema mostra que, independentemente do lugar, o algoritmo converge para um ponto estacionário? Ele ta me dizendo isso daqui:
$
  min_(t in [T]) ||gradient f(x^((t)))||_2^2 = O(1/T)
$
Ou seja, o mínimo *converge para $0$* conforme $T -> infinity$ *independentemente do ponto inicial $x^((0))$*

Só que se pararmos para pensar, se $gradient f(x)$ é uma direção de subida, então $-gradient f(x)$ é de descida, mas será que é a melhor? Será que *precisa* ser a melhor para o método funcionar? Se eu escolher *uma direção de descida arbitrária* ele funciona? Mas antes disso, vamos entender o que é uma direção de descida

#definition("Direção de Descida")[
  Dizemos que $d in RR^n$ é uma direção de descida para a funçaõ $f: RR^n -> RR$ no ponto $x in RR^n$ quando:
  $
    d^T gradient f(x) < 0
  $
]

então podemos considerar um novo algoritmo

#figure(
  pseudocode-list(
    booktabs: true
  )[
    + *func* GradientDescentWithArbitraryDescentDirection($f$) {
      + $x^((0)) in RR^n$
      + $alpha > 0$
      + *for* $t in [T]$ *do* {
        + Encontrar *uma* direção de descida $d^((t))$
        + $x^((t+1)) = x^((t)) + alpha d^((t))$
      +  }
      + *return* $x^((T))$
    + }
  ],
  supplement: [Algoritmo],
  caption: [Gradient Descent com Direção de Descida Arbitrária]
)<gradient-descent>

Podemos provar, analogamente ao @gradient-descent-convergence, que o algoritmo converge para um ponto estacionário

== Caso Convexo
Antes, não assumimos nada além da suavidade da função, agora vamos mostrar que, assumindo que $f$ é convexa, o algoritmo converge para uma solução global. Primeiro, nós sabemos que:
$
  x^((t+1)) &= x^((t)) - alpha gradient f(x^((t)))    \

  <=> x^((t+1)) - x^* &= x^((t)) - x^* - alpha gradient f(x^((t)))    \

  <=> ||x^((t+1)) - x^*||_2^2 &= ||x^((t)) - x^* - alpha gradient f(x^((t)))||_2^2
$

Pelas propriedades da convexidade:
$
  (x^* - x^((t)))^T gradient f(x^((t))) <= f(x^*) - f(x^((t))) 
$

e pelo que vimos na equação @iterated-aproximation, se $alpha in (0, 2/L)$, podemos chegar que:
$
  ||x^((t+1))-x^*||_2^2 <= ||x^((t))-x^*||_2^2 - alpha (2 - 1/(1-(alpha L)/2))(f(x^((t)))-f^*)
$

ou seja, a distância do próximo iterado pro ponto ótimo é menor a distância atual, menos um termo proporcional a distância dos resultados de $x^((t))$ e do ponto ótimo. Vamos usar isso para provar a convergência global do resultado

#theorem("Convergência Convexa do Método do Gradiente")[
  Suponha que $f: RR^n -> RR$ é $L$-suave e convexa e tome qualquer passo
  $
    alpha = beta/L
  $
  para algum $beta in (0, 1)$, então:
  $
    f(x^((T))) - f^* <= 1/T sum^T_(t=1) (f(x^(t)) - f^*) <= (beta^(-1)-1/2)/(1-beta) (L||x^((1)) - x^*||_2^2)/T
  $
]
#proof[
  Somando-se em $t \in [T]$ a recorrência:
  $
  alpha (2 - 1/(1 - alpha L/2) (f(x^t) - f^*)
  <= ||x^((t)) - x^*||_2^2 - ||x^((t+1)) - x^*||_2^2
  $

  obtemos novamente uma soma telescópica:
  $
    alpha ((1-alpha L)/(1-alpha L/2))
    sum_(t=1)^T (f(x^((t))) - f^*)
    & <= sum_(t=1)^T (||x^((t)) - x^*||_2^2 - ||x^((t+1)) - x^*||_2^2)    \
    &<= ||x^((1)) - x^*||_2^2 - ||x^((T+1)) - x^*||_2^2   \
    &<= ||x^1 - x^*||_2^2.
  $


  Dividindo-se por $alpha ( (1-alpha L)/(1-alpha L/2))T$, e lembrando que, pelo , a sequência ${f(x^((t)))}$ é decrescente:
  $
  f(x^((T))) - f^*
  <= 1/T sum_{t=1}^T (f(x^((t)))-f^*)
  <= (alpha^(-1)(1-alpha L/2))/T ||x^1 - x^*||_2^2.
  $
]

== Interpretação via regularização
Outra formas que podemos ver e interpretar o algoritmo do gradiente é resolver a seguinte fórmula:
$
  x^((t+1)) = "argmin"_(x in RR^n) (
    underbrace(f(x^((t))) + (x - x^((t)))^T gradient f(x^((t))),
    "Aproximação Linear"
  ) + underbrace(
    1/(2 alpha^((t)))||x-x^((t))||_2^2,
    "Regularização Proximal"
  ))
$

Ou seja, eu vou pegar qual que é o valor que minimiza a aproximação linear regularizada por um termo quadrático

#pagebreak()

#align(center+horizon)[
  = Método do Subgradiente
]

#pagebreak()

Até agora vimos um método que usa o Gradiente da função, logo, para que ele funcione, estamos assumindo que a função é diferenciável em todos os pontos, porém em aplicações reais muitas funções não são diferenciáveis em todos os pontos. Então faz sentido utilizar esse método? Claro que não, porém, podemos utilizar uma versão muito parecida!

#definition("Subgradiente")[
  Seja uma função $f: RR^n -> RR$ e dado $x in RR^n$, um vetor $g_x in RR^n$ é chamado de *subgradiente* de $f$ em $x$ quando
  $
    f(y) >= f(x) + (y-x)^T g_x wide forall y in RR^n
  $
]

#definition("Subdiferencial")[
  O conjunto de todos os subgradientes de $f$ em $x$ é chamado de *subdiferencial* de $f$ em $x$ (Denotado por $partial f(x)$)
  $
    partial f(x) := {g_x in RR^n: f(y) >= f(x) + (y-x)^T g_x space forall y in RR^n}
  $
]

O que seria um subgradiente *intuitivamente* então? Note que, se eu definir $y = x^*$ (Sendo o ponto mínimo), vamos obter o seguinte:
$
  f(x^*) >= f(x) + g^T (x^* - x)
$
sabendo que $f(x^*) <= f(x)$, temos que:
$
  f(x) >= f(x) + g^T (x^*-x) <=> 0 >= g^T (x^*-x) <=> 0 <= g^T (x-x^*)
$

Ou seja, o subgradiente faz um ângulo *maior que $90º$* com o vetor que aponta de $x$ para $x^*$. O que isso quer dizer? Que os subgradientes são direções que, se seguirmos na *direção oposta*, nós *não* estamos indo eu uma direção em que nós temos *certeza* que ela sobe

Nem sempre existirão subgradientes, porém, quando falamos das *funções convexas*, mesmo elas não sendo *diferenciáveis*, elas possuem um subgradiente. Logo, um subgradiente é uma direção que, se eu vou na direção contrária a ela, eu tenho *certeza* que minha função não está aumentando

#theorem[
  Seja $f: RR^n -> RR$, então vale que:
  $
    f "é convexa" <=> partial f (x) != emptyset space forall x
  $
]<gradient-existence-convex>

Vale ressaltar que funções subdiferenciáveis podem não ser suaves. E por que isso é importante? Acontece que antes, no método do gradiente e na direções de descida, utilizamos o fato das funções serem suaves para provar a convergência do método, porém, aqui estamos trabalhando com funções que não necessariamente são diferenciáveis, logo, intuitivamente, elas podem ter vários picos, ou paradas bruscas, etc.

#figure(
  pseudocode-list(
    booktabs: true
  )[
    + *func* SubgradientMethod($f$) {
      + $x^((1)) in RR^n$
      + ${alpha^((t))} subset (0, infinity)$
      + *for* $t in [T]$ *do* {
        + Compute um subgradiente $g^((t))$ de $f$ em $x^((t))$
        + $x^((t+1)) = x^((t)) - alpha^((t)) g^((t))$
      +  }
      + *return* $x^((T)) := 1/T sum^T_(t=1) alpha^((t))/(sum^T_(l=1) alpha^((l))) x^((t))$
    + }
  ],
  supplement: [Algoritmo],
  caption: [Método do Subgradiente]
)<subgradient-descent>

Esse algoritmo parece até que "ingênuo", tipo, nada garante que o subgradiente vai fazer com que a função desça né?? Vamos mostrar que na verdade esse método converge sim! Porém, vamos assumir algumas coisas também. Para esse caso, vamos assumir que a função é $M$-Lipschitz (@m-lipschitz)

Usando o que foi mostrado na introdução (@linear-approximation), podemos mostrar o seguinte teorema:

#theorem([Aproximação Linear de funções $M$-Lipschitz])[
  Seja $f: RR^n -> RR$ uma função convexa, então $f$ é $M$-Lipschitz contínua se, e somente se, $forall x, y in RR^n$ e todo subgradiente $g_x in RR^n$ de $f$ em $x$:
  $
    |f(y) - f(x) + g_x^T (y - x)| <= M ||y - x||_2^2
  $
]

E no que isso me é útil? Só parece um bando de complicação esquisita. Na verdade, o que será útil na demonstração é uma *consequência* desse teorema

#corollary[
  Seja $f: RR^n -> RR$ uma função convexa, então $f$ é $M$-Lipschitz se, e somente se, $forall x in RR^n$ e todo subgradiente $g_x$ de $f$ em $x$, vale que $||g_x||_2 <= M$
]

Vamos então mostrar a convergência do algoritmo. Um ponto interessante a se dizer é que, como você *talvez* possa ter pensado, nem sempre um subgradiente vai ser uma direção de *descida*. O que isso quer dizer? Isso quer dizer que, não necessariamente, a cada iteração, $f(x^((t+1)))<=f(x^((t)))$, porém, ele decresce o valor sobre a *média de todas iterações*.

#theorem("Convergência do Subgradiente")[
  Suponha que $f: RR^n -> RR$ é $M$-Lipschitz contínua e convexa. Então:
  $
    f(overline(x)^((T))) - f^* <= 1/T sum^T_(t=1)(f(x^((t))) - f^*) <= (||x^((1)) - x^*||_2^2 + M^2 sum^(T)_(t=1)(alpha^((t)))^2)/(sum^(T)_(t=1)alpha^((t)))
  $
  em particular, para qualquer $beta > 0$, consideramos:
  $
    alpha^((t)) = beta / sqrt(T) wide t in [T]
  $
]
#proof[
  Primeiramente, temos que:
  $
    ||x^((t+1)) - x^*||_2^2 &= ||x^((t)) - x^* - alpha^((t)) g^((t))||_2^2    \

    &<= ||x^((t)) - x^*||_2^2 + 2 alpha^((t)) (x - x^*)^T g^((t)) + (alpha^((t)))^2 ||g^((t))||_2^2
  $
  e pela definição de subgradiente ($f$, por ser convexa, é garantida de ter subgradientes pelo @gradient-existence-convex), temos que:
  $
    (x^* - x^((t)))^T g^((t)) <= f(x^*) - f(x^((t)))
  $
  A partir disso, também podemos escrever:
  $
    ||x^((t+1)) - x^*||_2^2 <= ||x^((t))-x^*||_2^2 - alpha^((t)) (f(x^((t)))-f^*) + ( M alpha^((t)) )^2
  $

  Agora nós vamos fazer novamente a soma por recursão:
  $
    sum_(t=1)^T alpha^((t)) (f(x^((t))) - f^*) &<= sum_(t=1)^T (||x^((t)) - x^*||_2^2 - ||x^((t+1))-x^*||_2^2) + M^2 sum^T_(t=1) (alpha^((t)))^2    \

    &<= ||x^((1))-x^*||_2^2 + M^2 sum_(t=1)^T (alpha^((t)))^2
  $

  Dividindo por $sum_(t=1)^T alpha^((t))$ e, usando a desigualdade de Jensen
  $
    f(overline(x)^((T))) - f^* <= 1/T sum^T_(t=1) (f(x^((t))) - f^*) <= (||x^((1)) - x^*||_2^2 + M^2 sum_(t=1)^T (alpha^((t)))^2)/(sum_(t=1)^T alpha^((t)))
  $
  Ou seja, a média das iterações converge para próximo de $x^*$
]

Nós assumimos que $alpha^((t))$ está em um conjunto de passos, e não que é um único passo, mas e se assumirmos que é um único, qual seria o melhor passo? Tomando $alpha^((t)) = alpha$:
$
  f(overline(x)^((T))) - f^* <= (||x^((1)) - x^*||_2^2)/(T alpha) + M^2 alpha
$

perceba também que:
$
  min_(alpha>0){ (||x^((1)) - x^*||_2^2)/(T alpha) + M^2 alpha } = (M ||x^((1))-x^*||_2)/(sqrt(T))
$

logo, temos que:
$
  alpha^((t)) = (||x^((1))-x^*||_2)/(M sqrt(T))
$

então teremos a taxa de convergência:
$
  f(overline(x)^((T))) - f^* <= (2M ||x^((1)) - x^*||_2)/(sqrt(T))
$

Porém, na maioria esmagadora das vezes, não sabemos $M$ e $||x^((1))-x^*||$, então utilizamos o passo sequencial já definido anteriormente
