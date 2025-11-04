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
  = Percolação e Robustez
]

#pagebreak()

No contexto de redes, um problema muito comum são nós pararem de funcionar e atrapalharem o fluxo da informação implícita na rede. Por exemplo, pode acontecer de a rede de internet ter falhas aleatórias dentro dela, então alguns roteadores falham. Nosso objetivo aqui é entender quando que essas falhas (Sejam propositais ou não) afetam o fluxo da rede. A *Percorlação* nos diz como e quando uma rede colapsa, enquanto a *Robustez* vai medir e indicar como previnir esse colapso

== Percolação
Em nosso contexto, vamos definir da seguinte forma. Queremos olhar a *capacidade da rede* de *se manter conexa após perder uma fração de seus nós*. Para começar, não vamos partir para a teoria em si, vamos analisar *um caso específico* primeiro para pegar a noção

#figure(
  image("images/square-lattice.png"),
  caption: [Rede quadrada onde cada cruzamento representa um nó (Pode ou não existir)]
)<square-lattice>

Vamos imaginar um grid onde cada intersecção de linhas é um nó que pode ou não existir com probabilidade $p$ e há uma aresta entre dois nós se eles forem vizinhos. Podemos fazer então duas perguntas:
- Qual o tamanho esperado do maior cluster?
- Qual o tamanho médio dos clusters?

Olhando o gráfico presente na @square-lattice, o tamanho médio dos clusters não muda gradativamente de acordo com o valor de $p$, mas ele se explode conforme se aproxima de um valor crítico $p_c$. Isso ocorre porque, conforme $p -> p_c$, os pequenos clusters se aglutinam e formam uma componente maior muito grande

Então, de acordo com o observado podemos fazer algumas definições e observações:

- Tamanho médio de clusters:
$
  EE[S] prop |p - p_c|^(-gamma_p)
$

- Parâmetro de ordem (Probabilidade de um nó selecionado aleatoriamente pertencer ao maior cluster):
$
  p_infinity prop (p - p_c)^(beta_p)
$

- Correlação de tamanho (Distância média entre dois nós do mesmo cluster):
$
  xi prop |p-p_c|^(-upsilon)
$

Perceba que, em $p_c$, o maior cluster tem tamanho infinito, assim ele cobre todo o quadriculado. $gamma_p, beta_p$ e $upsilon$ são chamados de expoentes críticos e a teoria da percolação diz que eles são universais (Não dependem da natureza do grid, pode ser triangular, hexagonal, enfim)

Agora que entendemos um pouco melhor o comportamento do nosso caso específico, vamos analisar ele como uma rede em si. Imagine que vamos remover uma fração $f$ dos nós da rede antes mencionada. Conforme aumentamos a fração $f$, em algum momento, a componente gigante vai se desfazer e, para algum $f_c$, vale que $forall f > f_c => p_infinity = 0$, logo, não há mais uma componente gigante

Para redes aleatórias, *sob falhas aleatórias*, compartilham os mesmos expoentes críticos que uma rede de percolação dimensional-infinita:
$
  gamma_p = 1 wide beta_p = 1 wide upsilon = 1/2
$

Já em uma rede livre-de-escala, os expoentes são:
$
  beta_p = cases(
    1/(3-gamma) "se" 2 < gamma < 3,
    1 /(gamma-3) "se" 3 < gamma < 4,
    1 "se" 4 < gamma
  )

  wide

  gamma_p = cases(
    1 "se" gamma > 3,
    -1 "se" 2 < gamma < 3
  )
$

Perceba que no regime $2 < gamma < 3$ *sempre há uma componente gigante*. Temos também a relação da *quantidade de componentes de tamanho $s$* ($n_s$)
$
  n_s prop s^(-tau) e^(-s\/s^*)
$
$
  s^* prop |p-p_c|^(-sigma)
$
$
  tau = cases(
    5/2 "se" gamma > 4,
    (2 gamma - 3)/(gamma - 2) "se" 2 < gamma < 4
  )
$
$
  sigma = cases(
    (3-gamma)/(gamma-2) "se" 2 < gamma < 3,
    (gamma-3)/(gamma-2) "se" 3 < gamma < 4,
    1/2 "se" gamma > 4
  )
$

== Robustez
Vimos um exemplo específico com redes quadriculadas, mas e se não seguirmos esse padrão? O que fazemos? Na verdade a ideia é bem parecida! Isso nos vai revelar um comportamento muito interessante sobre as redes livre-de-escala.

#figure(
  image("images/scale-free-network-and-internet.png", width: 80%),
  caption: [Comparação do tamanho relativo de uma rede livre-de-escala qualquer e da rede de internet conforme removemos uma fração *aleatória* $f$ de seus nós]
)

Os gráficos acima indicam uma resistência muito forte das redes livre-de-escala contra falhas aleatórias dentro da mesma. Será que podemos encontrar um meio matemático de entender o porquê que isso acontece?

== Critério de Molloy-Reed

#theorem("Critério de Molloy-Reed")[
  Dado que $K$ é a variável aleatória que representa o grau de um nó selecionado aleatoriamente dentro de uma rede $G(V,E)$. Para que uma componente gigante exista dentro dessa rede, ela deve satisfazer:
  $
    EE[K^2] / EE[K] >= 2
  $
]
#proof[
  Para que minha rede tenha uma componente gigante, um nó *da componente* deve ter grau médio maior ou igual a $2$, já que caso contrário, quer dizer que muitos nós possuem apenas uma ou menos conexões. Defina $PP(delta(v_i)=k_i|v_i <-> v_j)$ como a probabilidade de que $v_i$ tem grau $k$ dado que ele se liga com $j$ *e $j$ está na componente gigante*. Por questões de simplificação de notação, chamemos a probabilidade antes definida como $PP(k_i|i<->j)$. Temos que:
  $
    EE[K=k_i|i<->j] = sum_(k_i) k_i PP(k_i|i<->j) >= 2
  $
  Vamos calcular alguns termos. Sabemos que:
  $
    PP(k_i|i<->j) = (PP(i<->j|k_i) dot PP(k_i))/PP(i<->j)
  $
  E também temos que:
  $
    PP(i<->j) = (|E|) / (mat(|V|;2)) = EE[K] / (|V| - 1)
  $
  Além de que:
  $
    PP(i<->j|k_i) = k_i / (|V|-1)
  $
  Então, substituindo, vamos ter:
  $
    EE[K=k_i|i<->j] = sum_(k_i) k_i (k_i p(k_i))/(EE[K]) = EE[K^2] / EE[K] >=2
  $
]

Olhando o caso específico de *redes aleatórias*, nós vamos obter que:
$
  EE[K^2]/EE[K] >= 2 <=> EE[K](1 + EE[K])/EE[K] >= 2 <=> EE[K] >= 1
$

O que coincide com os resultados vistos no primeiro resumo

== Limite Crítico
Vamos agora utilizar do critério visto anteriormente para entender o porquê de as redes livre-de-escala serem robustas a falhas aleatórias. Primeiro de tudo, ao remover uma fração dos nós de uma rede *aleatoriamente*, existem duas consequências:
- Altera o grau de alguns nós [$k' <= k$]
- Muda a distribuição dos graus [$p_k -> p'_k'$]

Vamos primeiro descobrir a nova distribuição dos graus após a remoção da fração $f$. Vamos fixar que estamos analisando um nó $v in V$ que, antes da remoção, tem grau $k$, ou seja, tem $k$ vizinhos. Para saber quantos vizinhos vão sobrar após remover a fração, definimos uma variável indicadora para cada um dos vizinhos do nó $v$
$
  II_j = cases(
    1 "se o vizinho NÃO foi removido com probabilidade" 1-f,
    0 "se o vizinho foi removido com probabilidade" f
  )
$

então a quantidade de vizinhos de $v$ APÓS A REMOÇÃO dos $f$ nós é:
$
  sum_(j=1)^k II_j
$

e como isso é uma soma de bernoullis independentes, essa soma nos dá uma distribuição $"Binomial"(k, 1-f)$, então temos que:
$
  PP(K'=k'|K=k) = mat(k;k')f^(k-k')(1-f)^k'
$

Considere que $K$ é a variável aleatória do grau de um nó selecionado aleatoriamente na rede ANTERIOR à remoção da fração $f$ e $K'$ é selecionando um nó na rede POSTERIOR à remoção da fração. Então para achar a nova distribuição dos graus após as remoções, apenas fazemos:
$
  PP(K'=k') &= sum_(i)^infinity PP(K'=k'|K=i)PP(K=i)   \
  &= sum^(infinity)_(i) PP(K=i) mat(i;k')f^(i-k')(1-f)^(k')
$

Agora vamos assumir que sabemos $EE[K]$ e $EE[K^2]$ (distribuição original), e queremos calcular $EE[K']$ e $EE[K'^2]$, então fazemos:
$
  EE[K'] = EE\[underbrace(EE[K'|K], "Bin"(k, 1-f))\] = EE[(1-f)K] = (1-f) EE[K]
$
$
  EE[K'^2] &= VV[K'] + (EE[K'])^2   \
  &= VV[K'] + (1-f)^2(EE[K])^2    \
  
  VV[K'] &= EE[VV[K'|K]] + VV[EE[K'|K]]   \
  &= (1-f)f EE[K] + (1-f)^2VV[K]    \
$
$
  => EE[K'^2] &= (1-f)f EE[K] + (1-f)^2 ( VV[K] + EE[K]^2 )   \
  &= (1-f)f EE[K] + (1-f)^2 EE[K^2]
$

Agora que sabemos os momentos da distribuição após a remoção dos $f$, podemos aplicar o critério de Molloy-Reed na rede posterior à remoção
$
  EE[K'^2] / EE[K'] = 2  <=> ((1-f)f EE[K] + (1-f)^2 EE[K^2]) / ((1-f) EE[K]) = 2   \
  
  f + EE[K^2] / EE[K] - f EE[K^2] / EE[K] = 2    \

  f(1-EE[K^2] / EE[K]) = 2 - EE[K^2] / EE[K]   \

  f = 1 - 1/(EE[K^2]/EE[K] - 1)
$

Note que a fração limite depende única e exclusivamente das informações da distribuição. Se olharmos o caso *específico* das redes aleatórias:
$
  f_c = 1 - 1/(EE[K])
$

Ou seja, quanto mais densa a rede, maior a fração crítica de nós necessários para a remoção. Agora, para redes livre-de-escala, vamos fazer um passo-a-passo diferente. Vamos primeiro calcular o $m$-ésimo momento do grau de uma rede livre-de-escala:
$
  EE[K^m] &= (gamma-1) k_"min"^(gamma-1) integral_(k_"min")^(k_"max") k^(m-gamma) dif k   \

  &= (gamma-1)/(m-gamma+1) k_"min"^(gamma-1) [k^(m - gamma + 1)]^(k_"max")_(k_"min")    \

  &= (gamma-1)/(m-gamma+1) k_"min"^(gamma-1) [k_"max"^(m - gamma + 1) - k_"min"^(m - gamma + 1)]
$

Agora calculamos o limite crítico $f_c$
$
  kappa = EE[K^2]/EE[K] = ( (2-gamma)k_"max"^(3-gamma) - k_"min"^(3-gamma) ) / ( (3-gamma)k_"max"^(2-gamma) - k_"min"^(2-gamma) )
$
então, obtemos:
$
  kappa = |(2-gamma)/(3-gamma)| cases(
    k_"min" "se" gamma > 3,
    k_"max"^(3-gamma)k_"min"^(gamma-2) "se" 2 < gamma < 3,
    k_"max" "se" 1 < gamma < 2
  )
$
daí, utilizando todas as contas que vimos agora relebrando o fato, visto no último resumo, que:
$
  k_"max" = k_"min" N^(1/(gamma-1))
$

vamos obter que:
$
  f_c &= 1 - 1/(kappa - 1)    \
  &= 1 - C/(N^((3-gamma)/(gamma-1)))
$

== Tolerância a Ataques
Até agora, vimos apenas falhas aleatórias, na rede de internet, por exemplo, se alguns roteadores falharem aleatoriamente, a rede tem estrutura suficiente para se manter, porém, e se um ataque planejado for feito e derrubar todos os pontos com maiores conexões? Esse é o contexto que vamos analisar, em vez de retirarmos nós aleatoriamente, vamos retirar sempre os nós com *maior grau*

#figure(
  image("images/scale-free-network-random-failure-vs-attacks.png"),
  caption: [Tamanho relativo do maior cluster conforme retiramos os nós seguindo o regime de falhas aleatórias e de ataques em uma rede *livre-de-escala*]
)

Perceba que, para redes livre-de-escala, elas são *muito* mais sucetíveis a ataques direcionados. O que faz bastante sentido, já que a presença de hubs é muito marcante nesse tipo de rede.

Agora a gente gostaria de entender como que a remoção dos hubs afeta a rede e o limite para que ela colapse. Para entender isso, devemos saber que remover um hub afeta a rede de duas formas:
- Muda o grau máximo de $k_"max"$ para $k'_"max"$
- A distribuição de graus muda de $p_k$ para $p'_k'$

Lembrando que, para o problema das redes livre-de-escala, temos:
$
  p_k = c k^(-gamma)    \
  k in {k_"min",...,k_"max"}    \
  c approx (gamma-1)/(k_"min"^(-gamma+1) - k_"max"^(-gamma+1))
$

Após removermos a fração $f$ de nós, temos que:
$
  f = integral_(k'_max)^k_max p_k dif k
$
