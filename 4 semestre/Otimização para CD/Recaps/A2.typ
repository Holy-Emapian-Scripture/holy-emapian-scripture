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
  = Método do Gradiente
]

#pagebreak()

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
]

#definition([Função $L$-Suave])[
  Uma função $f: RR^n -> RR$ é $L$-suave quando seu gradiente é $L$-Lipschitz:
  $
    ||gradient f(x) - gradient f(y)|| <= L ||x - y|| wide forall x,y in RR^n
  $
]

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

#theorem[
  Suponha que $f: RR^n -> RR$ é $L$-suave. Tome qualquer passo:
  $
    alpha = beta/L
  $
  para algum $beta in (0, 2)$. Então:
  $
    min_(t in [T])||gradient f(x^((t)))||^2_2 <= 1/T sum^(T)_(t=1) ||gradient f(x^((t)))||^2_2 <= ((2\/beta)/(2-beta)) (L(f(x^((1))) - f^*))/(T)
  $
]
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
