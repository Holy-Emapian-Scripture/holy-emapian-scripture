#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.0": *
#show: thmrules.with(qed-symbol: $square$)

#import "@preview/wrap-it:0.1.1"
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
    Ciência de Redes
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

// ============================ PÁGINAS POSTERIORES =========================
#outline(title: "Conteúdo")

#pagebreak()

#align(center+horizon)[
  = Correlação de Graus
]

#pagebreak()

Nesse capítulo, temos o objetivo de entender como nós se relacionam dentro de uma rede. Imagine uma rede que os nós são pessoas e as arestas são direcionadas e apontam para nós que aquela pessoa conhece. Quando paramos para reparar, nós com muitos graus (Que muitas pessoas conhecem, logo, celebridades), tendem a apontar para outros nós com muitos graus de entrada (Celebridades conhecem muitas celebridades). Porém, muitas vezes esses critérios podem nem estar explícitos na rede em si, e queremos estudar todos os casos possíveis nesse capítulo

== Descobrindo os Critérios
Dado uma rede $G(V,E)$, vamos supor que conhecemos a distribuição dos graus dessa rede ($PP(delta(v_i) = k) = p(k)$ para simplificação de notação), queremos ver se o grau do nó tem alguma influência em como eles se ligam. Então temos que ver a probabilidade de que um nó de grau $k'$ se ligue com um de grau $k$, ou seja:
$
  PP({v_i, v_j} in E | delta(v_i) = k, delta(v_j) = k') = p({k, k'} in E)
$
Vamos escrever dessa forma para simplificar notação. Vamos ter que:
$
  p({k,k'} in E) = (k k')/(2|E|)
$
Onde $k'\/2L$ é a probabilidade do meu nó com grau $k$ se ligar com um nó de grau $k'$ e eu multiplico por $k$ pois meu nó possui $k$ arestas ligadas a ele. Essa probabilidade indica que nós com graus maiores tem mais probabilidade de se ligar com outros nós de grau grande

#definition("Matriz de Correlação por Grau")[
  A matriz de correlação por grau é a matriz que a entrada $e_(i j)$ é a probabilidade de encontrar nós de graus $i$ e $j$ nas pontas de uma aresta selecionada aleatoriamente
]

Essa matriz nos tráz informações diretas da relação *linear* entre os nós. Podemos dividir e classificar as redes de 3 formas de acordo com a relação entre seus graus

- *Rede Assortativa:* Nós com graus parecidos intelrigam entre si
- *Redes Neutras:* Os nós não apresentam um padrão para intelirgarem entre si
- *Redes Desassortativas:* Nós com graus maiores se ligam com graus menores e vice-versa

Podemos então avalisar a matriz de covariância ou a correlação entre os dados. Porém a relação entre esses pontos pode não ser linear, o que pode dar falsas impressões sobre a correlação

#figure(
  image("images/degrees-correlation.png"),
  caption: [Matriz de covariância de graus com 3 redes. A primeira é assortativa, a segunda é neutra e a última é desassortativa]
)

A matriz de correlação acaba por representar uma distribuição conjunta em $i$ e $j$ de forma que:
$
  sum_(i, j) e_(i j) = 1
$

então definindo um pouco melhor essa probabilidade, defina $K$ como a bariável aleatória que representa o grau de um nó selecionado aleatoriamente. Seja também ${v_i, v_j} in E$ uma aresta escolhida aleatoriamente dentre todas as do conjunto $E$. Para simplificar notações, também definimos $A = delta(v_i)$ e $B = delta(v_j)$. Então vamos ter que:
$
  e_(i j) = PP(A=i, B=j) = PP(A=i|B=j) dot PP(B=j) = PP(B=j|A=i) dot PP(A=i)
$

vamos então calcular cada um desses termos (Até onde for possível). Primeiro vamos calcular $PP(A=i)$
$
  PP(A = i) = (i N_i) / (2|E|) times 1/N / (1/N) = (i p(i))/(EE[K])
$

onde $N_i$ é a quantidade de nós com grau $i$ e eu multiplico por $i$ pois eu posso escolher qualquer uma das $i$ arestas presentes no nó que eu gostaria que fosse escolhido (O de grau $i$). E divido isso pela quantidade total de nós. Eu posso ainda, dividir o termo de cima e o de baixo por $N$, obtendo então a expressão na direita

Se os eventos $A$ e $B$ *não são independentes*, seria necessário saber a distribuição entre eles dois para calcular $PP(A=i|B=j)$. Porém, se $A$ e $B$ são independentes, então $PP(A=i|B=j) = PP(A=i) dot PP(B=j)$, então, no caso de $A$ e $B$ independentes, obtemos:
$
  PP(A=i|B=j) = PP(A=i) dot PP(B=j) = (i p(i) j p(j))/((EE[K])^2)
$

== Average Next Neighbour Degree
É interessante fazer o gráfico de uma matriz de covariância, porém, por ela perder essas informações antes mencionadas, as vezes ela pode ser ineficiente ou ser de difícil leitura se houver muitos vértices, então criamos a seguinte definição:

#definition("Average Next Neighbour Degree")[
  Seja $G(V,E)$ uma rede, $A$ a matriz de adjacência da mesma e $v_i in V$, então:
  $
    k_"nn" (v_i) := 1/(delta(v_i)) sum_(j=1)^(|V|) A_(i j) delta(v_j)
  $
]

Essa definição é o $k_"nn"$ para um vértice específico, mas e se quisermos o valor médio dessa medida para nós de grau $k$?
$
  k_"nn" (k) = EE[B|A=k] = sum_(k') k' PP(B=k'|A=k)
$

Podemos ver o que acontece com essa medida quando $A$ e $B$ são independentes, logo, analisar o caso das *redes neutras*
$
  k_"nn" = sum_(k') k' PP(B=k') = sum_(k') k' (k' p(k'))/EE[K] = EE[K^2] / EE[K]
$

Perceba que, quando consideramos o caso das redes neutras, *a média dos vizinhos de um nó não depende em quantos nós ele tem ou de informações sobre como o nó se relaciona com os outros, mas única e exclusivamente de características globais da rede*. A mesma lógica vale para as redes assortativas e desassortativas:

#figure(
  image("images/knn-predictions.png")
)

- *Assortativas:* A medida tende a crescer conforme aumentamos os valores de $k$ já que quanto maior o grau, maior a probabilidade de os graus se interligarem
- *Desassortativas:* Nós de grau menor tendem a interligar com nós de grau maior, o que acaba por fazer com que as probabilidades sejam altas em valores de $k$ muito pequenos, isso faz com que conforme aumentamos o $k$, o valor da medida diminua

O livro aponta que, de acordo com o gráfico mostrado anteriormente, que podemos aproximar a medida do $k_"nn"$ como:
$
  k_"nn" (k) = beta k^mu
$

de forma que:
- $mu > 0 =>$ Rede assortativa
- $mu approx 0 =>$ Rede neutra
- $mu < 0 =>$ Rede desassortativa

== Cutoffs
A gente até agora ta assumindo que as redes analisadas são simples, ou seja, entre dois nós, só pode existir *no máximo* uma aresta. Porém, em algumas redes, quando calculamos o número esperado de arestas entre nós
$
  EE_(k k') = e_(k k') EE[K] N
$

esse valor é *maior que $1$*. Então como fazemos para achar o valor de $k$ que faz com que esse valor seja $>1$?

Primeiro, vamos definir
$
  r_(k k') = E_(k k') / m_(k k')
$

onde $E_(k k')$ é o número de arestas entre todos os nós de grau $k$ e de $k'$ e $m_(k k') = min{ k N_k, k' N_(k'), N_k N_(k') }$ é a maior quantidade *possível* de restas que ligam nós de grau $k$ e $k'$. Vou explicar o porquê dessa fórmula para $m_(k k')$

- Cada nó com grau $k$ só pode se ligar a *no máximo* $k$ nós de grau $k'$, então:
$
  E_(k k') <= k N_k
$
- O mesmo argumento vale para os nós de grau $k'$
$
  E_(k k') <= k' N_(k')
$
- Eu também não consigo ligar mais que o número máximo disponível de pares entre os dois grupos de graus
$
  E_(k k') <= N_k N_(k')
$

Ou seja, temos que $r_(k k') <= 1 space forall k, k'$. Só que como mencionei anteriormente, por conta do valor esperado "não-esperado" de mais que uma aresta entre dois nós, pode ocorrer que $r_(k k') > 1$, então queremos encontrar $k_s$ tal que:
$
  r_(k_s k_s) = 1
$

Mas antes de achar $k_s$, vamos reescrever $r_(k k')$ de outra forma e fazer uma análise. Perceba que, quando $k > N p(k')$ ou $k' > N p(k)$, os efeitos das arestas múltiplas aparecem, transformando a expressão em:
$
  r_(k k') = EE_(k k') / m_(k k') = (EE[K] e_(k k'))/(N p(k) p(k'))
$

Para redes livre-de-escala, as condições são satisfeitas para $k, k' > (a |V|)^(1/(gamma+1))$ onde $a$ depende de $p(k)$. Só que esse valor é abaixo do cutoff natural, de forma que temos CERTEZA de que, se $k$ e $k'$ são maiores que isso, não podemos garantir que o valor esperado dos links será menor que 1. Olhando o caso específico das redes neutras, sabemos que:
$
  e_(k k') = (k k' p(k) p(k'))/(EE[K]^2)
$

Logo $r_(k k')$ vira:
$
  r_(k k') = (k k') / (EE[K] N)
$

Ou seja, chegamos que $k_s prop (EE[K] N)^(1/2)$

Tendo isso em mente, conseguimos dividir as *redes livre-de-escala* em dois regimes ao compararmos $k_"max"$ e $k_s$ (Lembrando: $k_max prop N^(1/(gamma-1))$)

- *Sem cutoff estrutural:* Para redes aleatórias e livre-de-escala com $gamma >= 3$, o expoente de $k_max <= 1/2 => k_max <= k_s$, logo os valores esperados dos links entre nós será *sempre* menor ou igual a 1
- *Dissassortividade estrutural:* Para redes livre-de-escala com $gamma < 3$, temos $-1/(1-gamma) > 1/2$, logo $k_s$ pode ser menor que $k_"max"$, logo, há nós entre $k_s$ e $k_max$ que podem ter $E_(k k') > 1$

#pagebreak()

#align(center+horizon)[
  = Robustez
]

#pagebreak()


