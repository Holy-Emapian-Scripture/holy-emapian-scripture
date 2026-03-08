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

== Classificação
Seja $cal(D) := {(x_1, y_1), ..., (x_N, y_N)} subset cal(X) times cal(Y)$ o conjunto de treinamento e $d: cal(D) times cal(D) -> RR^+ union {0}$ uma função de *distância*. Vamos supor que queremos classificar um vetor $x in cal(X)$ arbitrário. 

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

Observe que o algoritmo k-NN não necessita de treinamento, ou equivalentemente, o treinamento consiste em simplesmente armazenar o conjunto de dados $cal(D)$. Por conta disso, k-NN é dito ser uma abordagem de lazy learning (Atkeson et al., 1997)

== Qual distância escolher?
Até então, descrevemos o k-NN sem especificar exatamente o formato da função de distância $d$. No entanto, a escolha de uma distância apropriada pode ser crítica para o sucesso do método. Por exemplo, se os dados de entrada estão dispostos na superfície do globo terrestre, gostariamos de usar uma distância que considere a curvatura da terra (e.g., a distância esférica).

No entanto, raramente temos esse tipo de conhecimento sobre $cal(X)$ e as escolhas mais comuns para $d$ incluem casos particulares da distância de Minkowski:
$
  d_p (x, z) = ||x - z||_p = (sum_(i=1)^D |x_i - z_i|^p)^(1/p)
$

que para valores de $p = 1$ chama-se distância quarteirão ou Manhattan; $p = 2$ resulta na
distância euclidiana; e $p -> infinity$ retorna o máximo da diferença entre as componentes dos vetores.
A notação $|| dot ||_p$ é também chamada de norma $L^p$ de um vetor.

Uma possível deficiência de normas $L^p$ é que elas não incorporam nenhuma informação sobre a distribuição $PP_x : cal(X) -> RR^+ union {0}$ (Que é a distribuição que os vetores $x$ foram extraídos) — além do fato do suporte ser subconjunto dos reais. Por exemplo, se uma componente $x_i$ tiver escala muito maior às demais $x_(j!=i)$, ela pode dominar o cálculo da distância, ofuscando diferenças nas demais componentes $x_(j!=i)$. Além disso, $L^p$ são agnósticas a correlações entre componentes de $x ~ PP_x$ (Quando falamos em relação, dizemos da relação entre os componentes de um $x$. Por exemplo, digamos que $x_i=(x_(1 i), x_(2 i), ..., x_(D i))$ então a feature $2$ e $3$ são altura e peso respectivamente, sabemos que quando altura cresce, peso tende a crescer, mas a distância de Minkowski não captura essa relação). Uma alternativa para cobrir esses problema é utilizar a distância de Mahalanobis:
$
  d_M (x, z) = sqrt((x - z)^T Sigma^(-1) (x - z))
$
em que $Sigma$ é a matriz de covariância dos dados de treinamento. Uma escolha típica para $Sigma$ é a matriz de covariância amostral, não viezada:
$
  Sigma = 1/(N-1) sum_(i=1)^N (x_i - accent(x, -)) (x_i - accent(x, -))^T
$
onde $accent(x,-):= 1/N sum_(i=1)^N x_i$ é o vetor de médias amostrais. Observe que quando $Sigma$ é igual à matriz identidade, temos a distância euclidiana. Mas, afinal, qual distância utilizar? De modo geral, a
menos que tenhamos profundo conhecimento sobre a geometria de $cal(X)$ , é impossível dar uma resposta direta. O melhor que podemos fazer é testar opções diferentes.

=== Normalização para média zero e variância um
Subtrair a média $accent(x,-):= 1/N sum_(i=1)^N x_i$ de
cada vetor $x_1, ... , x_N$ e, subsequentemente, multiplicá-los pela inversa da matriz diagonal $C$ com entradas:
$
  C_(j j) = sqrt(1/(N-1) sum^N_(i=1) (x_(i j) - accent(x, -)_j)^2)
$
é um procedimento comum em ML, sendo geralmente chamado de normalização ou padronização (standardization). Aplicar
k-NN com $d(x, z) = ||x - z||_2$ em dados transformados dessa maneira equivale a aplicar k-NN nos dados originais usando a distância de Mahalanobis com $Sigma^(-1) = C^(-2)$

=== Similaridade Cosseno
As distâncias estudadas até aqui são consideradas medidas de dissimilaridade (Qualidade ou estado do que é diferente, desigual ou heterogêneo) entre vetores. De modo análogo, podemos definir a vizinhança de um ponto em termos de medidas de similaridade. Uma importante medida de similaridade entre dois vetores quaisquer $x$ e $z$ é dada pelo coseno do ângulo $gamma$ entre eles:
$
  cos(gamma) = (x^T z) / (||x||_2 ||z||_2)
$
A similaridade coseno é particularmente útil quando estamos interessados na orientação, e não na magnitude, dos vetores. Ela tem sido bastante utilizada em aplicações que envolvem dados textuais (Manning & Schütze, 1999). Note também que $cos(gamma)$ pode ser escrito como uma função do tipo $k(x, z) = Phi(x)^T Phi(z)$, i.e., como uma generalização do produto interno entre $x$ e $z$. Medidas de similaridade que podem ser descritas dessa forma são chamadas funções de kernel.

=== Aprendendo Métricas
Além de usar distâncias clássicas, como as $L^p$ e a de Mahalanobis, é possível aprender métrica (ou pseudo-métrica) de distância de modo supervisionado, com base na taxa de classificacão. Existe uma área de pesquisa em ML conhecida como aprendizado de métrica (metric learning) que se dedica a essa finalidade. Nesse nicho, um
dos métodos mais comuns é o chamado large margin nearest neighbor #link("https://jmlr.csail.mit.edu/papers/volume10/weinberger09a/weinberger09a.pdf", [(Weinberger et al., 2006)]).


== Maldição da Dimensionalidade
A expressão maldição da dimensionalidade foi introduzida por Bellman (1957) e é comumente usada para descrever problemas causados pelo aumento exponencial do volume associado em função da dimensionalidade em espaços euclidianos. No caso do k-NN, esse aumento implica na esparsidade dos exemplos de treino, fazendo com que os k-vizinhos que procuramos estejam muito distantes.

Para ilustrar tal efeito, suponha que a distribuição $PP_x$ sobre os vetores de entrada $x_1,...,x_N$ seja uniforme sobre uma hiperbola $D$-dimensional $S_D$ centrada na origem e com raio unitário (Ou seja, todo ponto dentro dessa bola é uniformemente provável de ser escolhida para ser um vetor de entrada). Suponha também que queremos classificar o vetor de origem $z = (0,...,0)^T$. Defina $r$ como o raio da hiperbola $S'_D subset.eq S_D$ que *contém os k vizinhos mais próximos de $z$*. Em esperança, o quão grande devemos esperar que $r$ seja? Antes, é intuitivo notar que $PP (x_i in S'_D)$ é a razão dos volumes de $S'_D$ e $S_D$, ou seja:
$
  PP (x_i in S'_D) = EE_(x_i ~ PP_x) [II_(x_i in S'_D)] = (pi^(D/2) r^D) / (pi^(D/2) 1^D) = r^D
$
Segue então que o número esperado de amostra, dentre as $N$ que possuímos, dentro de $S'_D$ é:
$
  sum_(i=1)^N PP (x_i in S'_D) = N r^D
$
Então, para que tenhamos, em esperança, $k$ vizinhos dentro de $S'_D$, devemos escolher $r$ tal que $r = (k/N)^(1/D)$, e a medida que $D$ cresce, temos:
$
  lim_(D -> infinity) r = lim_(D -> infinity) (k/N)^(1/D) = 1
$
Ou seja, quanto maior é a dimensão, maior é o raio de $S'_D$, o que mostra que a propriedade de "vizinhos próximos tem propriedades parecidas" é quebrada em altas dimensões, o que é um grande problema para o método k-NN.

=== Manifolds de baixa dimensão.
Na prática, não é incomum ver k-NN sendo utilizado em espaços de alta dimensão, como de imagens, e atingindo boas taxas de acurácia. Uma explicação para esse fenômeno é que os dados não estão uniformemente distribuídos e, na verdade, residem em um subespaço de baixa dimensão. Por exemplo, suponha que $cal(X) subset RR^(256 times 256 times 3)$ é o espaço de imagens de tamanho $256 times 256$ com três canais de cores — red, green, and blue (RGB) — que contém um gato. Nós esperamos que $PP_x$ aloque massa zero para fotos de paisagens, obras de arte, etc
