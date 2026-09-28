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

#align(center + top)[
  FGV EMAp

  João Pedro Jerônimo
]

#align(horizon + center)[
  #text(17pt)[
    Cálculo I
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

#block(
  width: 100%,
  fill: rgb(255, 148, 162),
  inset: 1em,
  stroke: 1.5pt + rgb(117, 6, 21),
  radius: 5pt
)[
  *Nota*: Este material foi feito por um aluno de Ciência de Dados, então muitos conceitos não terão demonstrações rígidas, utilizando bastante dos conceitos intuitivos.
]

#outline(title: [Sumário])

#pagebreak()

#align(center+horizon)[
  = Sequências
]

#pagebreak()

== O que são sequências?
Antes de entrarmos nos conceitos do cálculo, podemos primeiro construir a intuição por trás deles com alguns conceitos mais simples!

#definition("Sequência")[
  Uma sequência é uma função cujo domínio é o conjunto dos números naturais. Ou seja, uma sequência é uma lista de números ordenados, que podem ser representados por uma função $f: NN -> RR$, onde $f(n) = a_n$, e $a_n$ é o $n$-ésimo termo da sequência.
]

#example[
  Um exemplo de sequência é a sequência
  $
    1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10, ...
  $

  onde a função que representa essa sequência é $a_n = f(n) = 1/n$.
]

#example[
  Outro exemplo de sequência é a sequência
  $
    1, 0, 1, 0, 1, 0, 1, 0, 1, 0, ...
  $

  onde a função que representa essa sequência é
  $
    a_n = cases(
      1 "se" n=2k+1,
      0 "se" n=2k
    )

    =

    (1 + (-1)^(n-1))/2
  $
]

Ou seja, sequências são só uma lista de números que seguem algum tipo de padrão, padrão esse representado pela função $f(n)$.

== Sequências Limitadas

#definition("Sequência Limitada Superiormente")[
  Uma sequência é limitada superiormente, se existe um número real $M$ ($exists M in RR$) tal que $a_n <= M$ para todo $n in NN$ ($forall n in NN$)
]
#example[
  A sequência $a_n = 1/n$ é limitada superiormente por $M = 1$, pois nenhum termo da sequência é maior que 1. Ou seja, $a_n <= 1$ para todo $n in NN$
]

#definition("Sequência Limitada Inferiormente")[
  Uma sequência é limitada inferiormente, se existe um número real $m$ ($exists m in RR$) tal que $a_n >= m$ para todo $n in NN$ ($forall n in NN$)
]
#example[
  A mesma sequência $a_n = 1/n$ é limitada inferiormente por $m = 0$, pois nenhum termo da sequência é menor que 0. Ou seja, $a_n >= 0$ para todo $n in NN$. Perceba que, mesmo que os números fiquem cada vez menores, eles ficam *muito* próximos de $0$, mas nunca chegam a ser menores que $0$, essa noção será muito importante.
]

#example[
  A sequência $f(n) = 2n$ é uma sequência limitada inferiormente por $m = 2$, pois nenhum termo da sequência é menor que 2. Ou seja, $a_n >= 2$ para todo $n in NN$, mas não é limitada superiormente, pois os números vão crescendo infinitamente.
]

Então sequências limitadas são aquelas que possuem algum tipo de valor que limita os valores da sequência, seja por cima ou por baixo. Ou seja, a sequência não cresce infinitamente para cima ou para baixo.

== Sequências Convergentes
Sequências convergentes, de forma intuitiva, são aquelas que a sequência fica *cada vez mais próxima* de algum número real, chamado de *limite da sequência*. Antes de entrar em detalhes na definição formal, mas vamos olhar dois exemplos para fixar a ideia

#example[
  A sequência $a_n = 1/n$ converge para $0$. Ou seja, o limite da sequência é $0$, pois os números vão ficando cada vez mais próximos de $0$.
]

#example[
  A sequência $f(n) = (-1)^n$ não converge, pois os números da sequência ficam alternando entre $1$ e $-1$, eles não ficam _"comportados"_ perto de algum número real. Ou seja, não existe um limite para essa sequência.
]

Ou seja, se eu tenho um valor $L$ que minha sequência *não ultrapassa* (seja para cima ou para baixo), mas que *qualquer outro valor menor que esse, a sequência eventualmente ultrapassa*, então a sequência converge para $L$. Caso contrário, a sequência não converge.

#definition("Sequência Convergente")[
  Uma sequência ${a_n}$ é dita convergente ao número $L$ se
  $
    epsilon > 0, exists n_0 in NN "tal que" |a_n - L| < epsilon, forall n >= n_0
  $
]

*Minha nossa senhora*, o que é ese bando de coisa que ta escrito? Vamos por partes. Eu estou afirmando primeiramente que $epsilon > 0$, assim eu posso ter *qualquer* valor $epsilon$ desde que seja maior que $0$, então eu poderia ter $epsilon = 0.01$, $epsilon=0.00001$, $epsilon = 0.0000000000000000000000001$ e assim vai. Depois eu estou dizendo que existe algum $n_0$ nos naturais que a condição descrita depois passa a valer. Quando eu faço $|x-y|$, eu estou pegando a distância entre $x$ e $y$, por exemplo, se eu faço $|1-3|$, eu tenho uma distância de $2$ unidades, então $|a_n - L| < epsilon$ diz que a distância entre $a_n$ e $L$ é menor que $epsilon$, ou seja, a sequência está ficando cada vez mais próxima de $L$. E por fim, eu estou dizendo que isso vale para todo $n$ maior ou igual a $n_0$, ou seja, depois de algum ponto da sequência, todos os números da sequência ficam cada vez mais próximos de $L$. Essa condição de ser $<epsilon$ permite que a sequência fique cada vez mais próxima de $L$, mas nunca chegue a ser igual a $L$, como no exemplo de $1/n$, onde os números chegam cada vez mais perto de $0$, mas nunca chegam a ser $0$.

#figure(
  image("images/A1/convergent-sequence.jpg", width: 60%),
  caption: "Visualização dos termos da definição formal",
)

Pelos exemplos que eu passei, perceba que a segunda sequência *é limitada*, pois os valores sempre ficam no intervalo $[-1,1]$, mas ela *não é convergente*, isso nos dá um teorema bem importante (que não entrarei em detalhes da demonstração)

#theorem[
  Dada uma sequência ${a_n}$
  $
    {a_n} "convergente" => {a_n} "limitada"
  $
  mas a volta não vale, ou seja, uma sequência limitada não necessariamente é convergente.
]

== Primeira noção de limites
Conversamos que em uma sequência convergente, os números vão ficando cada vez mais próximos de um valor específico, muitas vezes *sem chegar nesse valor*, mas qualquer outro valor menor que esse em específico, a sequência eventualmente vai ultrapassá-lo. Podemos _"formalizar"_ isso com a seguinte notação:
$
  lim_(n -> infinity) a_n = L
$
onde $L$ é o valor que a sequência converge, ou seja, o limite da sequência. A notação $n -> infinity$ significa que estamos olhando para os valores da sequência quando $n$ fica cada vez maior. No entanto, como vimos antes, existem algumas sequências que divergem, ou até outras que podem convergir, mas tem um padrão estranho. Por conta disso, existe um teorema interessante

#theorem("Convergência das subsequências")[
  $
    {a_n} "convergente" <=> "toda subsequência" {a_n_k} "convergente" e "com o mesmo limite"
  $
]

#example[
  Vamos analisar a sequência
  $
    f(n) = 1/2^n + (-1)^n
  $
  dentro dessa sequência, existem duas subsequências, uma que pega os valores de $n$ pares e outra que pega os valores de $n$ ímpares.
  $
    f(n) = cases(
      1/2^n - 1 "se" n=2k+1,
      1/2^n + 1 "se" n=2k
    )
  $
  A subsequência de termos ímpares converge para $-1$, enquanto a subsequência de termos pares converge para $1$, ou seja, a sequência *não possui limite*
]

== Sequências Monótonas
Sequências monótonas são aquelas que sempre crescem ou sempre decrescem, ou seja, elas não oscilam. Por exemplo, a sequência $1/n$ é monótona decrescente, pois os números vão ficando cada vez menores, enquanto a sequência $2n$ é monótona crescente, pois os números vão ficando cada vez maiores.

#definition("Sequência Crescente")[
  Uma sequência ${a_n}$ é dita crescente se $a_n <= a_(n+1)$ para todo $n in NN$.
]

#definition("Sequência Decrescente")[
  Uma sequência ${a_n}$ é dita decrescente se $a_n >= a_(n+1)$ para todo $n in NN$.
]

Essa propriedade de monotonicidade da origem a dois teoremas fáceis de se visualizar

#theorem[
  Se uma sequência ${a_n}$ é crescente e limitada superiormente, então ela converge.
  $
    lim_(n -> infinity) a_n = sup {a_n}
  $
]

#theorem[
  Se uma sequência ${a_n}$ é decrescente e limitada inferiormente, então ela converge.
  $
    lim_(n -> infinity) a_n = inf {a_n}
  $
]

É fácil de visualizar isso. Vamos pegar o caso de ela ser crescente e limitada superiormente. Como ela é limitada superiormente, existe algum valor $M$ que a sequência não ultrapassa, e como ela é crescente, os números vão ficando cada vez maiores, então eventualmente a sequência vai ficar cada vez mais próxima de $M$, ou seja, ela converge para $M$. O mesmo raciocínio vale para o caso de uma sequência decrescente e limitada inferiormente.

== Operações básicas com limites iniciais
Sejam duas sequências ${a_n}$ e ${b_n}$, e que elas convergem para $a$ e $b$, respectivamente. Então podemos fazer algumas operações básicas com os limites dessas sequências.

- ${a_n + b_n}$ é convergente e $lim_(n -> infinity) (a_n + b_n) = a + b$
- $a_n dot b_n$ é convergente e $lim_(n -> infinity) a_n dot b_n = a dot b$
- Se $b_n != 0$ para todo $n$, então $1 / b_n$ é convergente e $lim_(n -> infinity) 1 / b_n = 1/b$

Quando as sequências divergem, também temos algumas propriedades! Quando a sequência não converge, ou seja, seus valores vão crescendo (ou decrescendo) indefinidamente, colocamos a seguinte notação
$
  lim_(n -> infinity) a_n = infinity "ou" -infinity
$

Para as próximas propriedades, considere que $lim_(n->infinity) a_n = infinity$

- Se $b_n >= a_n space forall n >= k$, então $lim_(n->infinity) a_n = infinity => lim_(n->infinity) b_n = infinity$

- Seja ${b_n}$ tal que $lim_(n->infinity) b_n = infinity$ então $lim_(n->infinity) (a_n + b_n) = infinity$ e $lim_(n - infinity) a_n b_n = infinity$

- Se $lim_(n->infinity) c_n = c$, então $lim_(n->infinity)(c_n + a_n) = infinity$

- Se $lim_(n->infinity) c_n = c$ e $c>0$, então $lim_(n->infinity)(c_n dot a_n) = infinity$

- $lim_(n->infinity) 1/a_n = 0$

- Se $lim_(n->infinity) a_n = 0$ e $a_n > 0$ para todo $n$, então $lim_(n->infinity) 1/a_n = infinity$

=== Casos problemáticos
No entanto, nem todas as formulações de limites são intuitivas e simples, nós temos a presença de alguns *casos problemáticos*

Vamos supor que duas sequências tendem ao infinito, parece ser intuitivo pensar que $infinity - infinity = 0$ correto? Mas na verdade isso não é verdade! Vamos ter por exemplo $a_n = n + c$ e $b_n = n$, ambas $-> infinity$ quando $n->infinity$, porém
$
  a_n - b_n = c => a_n - b_n -> c
$
agora olhando o caso $a_n = 2n$ e $b_n = n$, ambas $-> infinity$ quando $n->infinity$, porém
$
  a_n - b_n = n => a_n - b_n -> infinity
$
que é um resultado diferente do anterior

Então $infinity - infinity$ é o que chamamos de *indeterminação*, ou seja, não podemos determinar o valor do limite diretamente, precisamos de algum tipo de *truque* ou *refatoração* para achar o limite.

O mesmo vale para $0 dot infinity$, vejamos dois casos que dão resultados diferentes. Vamos supor que $a_n = 1/n$ e $b_n = c dot n$, então
$
  a_n dot b_n = c => a_n dot b_n -> c
$
agora suponha que $a_n = 1/n$ e $b_n = n^2$, então
$
  a_n dot b_n = n => a_n dot b_n -> infinity
$
ou seja, $0 dot infinity$ é também uma indeterminação.

Por último, outro caso problemático é quando temos $infinity / infinity$, vejamos dois casos que dão resultados diferentes. Vamos supor que $a_n = n$ e $b_n = c dot n$, então
$
  a_n / b_n = 1/c => a_n / b_n -> 1/c
$
agora suponha que $a_n = n^2$ e $b_n = n$, então
$
  a_n / b_n = n => a_n / b_n -> infinity
$
ou seja, $infinity / infinity$ é também uma indeterminação.

Outra indeterminação é $0/0$, vejamos dois casos que dão resultados diferentes. Vamos supor que $a_n = 1/n$ e $b_n = 1/n^2$, então
$
  a_n / b_n = n => a_n / b_n -> infinity
$
agora suponha que $a_n = 1/n^2$ e $b_n = 1/n$, então
$
  a_n / b_n = 1/n => a_n / b_n -> 0
$
ou seja, $0/0$ é também uma indeterminação.

#pagebreak()

#align(center+horizon)[
  = Limites
]

#pagebreak()

Agora que já entendemos o conceito de limites em sequências, podemos estender esse conceito para funções. A ideia é a mesma, mas agora estamos olhando para o comportamento da função quando $x$ se aproxima de algum valor específico, ou até mesmo quando $x$ tende ao infinito. Agora que passamos pelas definições assustadoras e compreendemos elas um pouco melhor, vamos olhar para o conceito de limites de funções.

#definition("Limite")[
  $
    forall epsilon > 0, exists delta > 0 "tal que, se" 0 < |x - a| < delta "então" |f(x) - L| < epsilon
  $
]

O que *diabos* é isso que eu estou vendo? Na verdade é bem mais simples do que parece, em síntese, o que esse enunciado diz é: *para qualquer valor de $x$ dentro do intervalo $(a-delta, a+delta)$, o valor de $f(x)$ estará dentro do intervalo $(L-epsilon, L+epsilon)$*. E lembra que a gente ta sempre olhando para $delta$ e $epsilon$ beeeeem pequenininhos, mas diferentes de $0$? Isso quer dizer que, conforme eu vou aproximando do valor $a$ (vou diminuindo $delta$), o valor de $f(x)$ vai ficando cada vez mais próximo de $L$ (diminuindo $epsilon$). E por fim, a condição de $0 < |x - a|$ quer dizer que eu não posso pegar o valor de $x = a$, ou seja, eu não posso olhar para o valor da função no ponto $a$, mas sim para os valores próximos a ele.


