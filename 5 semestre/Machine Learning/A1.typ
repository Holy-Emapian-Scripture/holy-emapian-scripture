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
  image("images/knn-classification.png", width: 60%),
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

#pagebreak()

#align(center + horizon)[
  = Regressão Linear
]

#pagebreak()

Neste capítulo, vamos estudar o uso de modelos lineares para resolução de problemas deregressão. Enquanto modelos lineares são simples, eles são amplamente empregados em várias áreas de conhecimento e fornecem uma base para a construção de modelos mais expressivos, como modelos polinomiais, métodos de kernel e redes neurais de uma única camada oculta.

== O Problema
Suponha que você recebe um conjunto de dados $D$ com $N$ pares ordenados $(x_n, y_n)$, no qual $x_n in RR^D$ são as entradas (ou variáveis independentes), e $y_n in RR$ são amostras de uma variável de saída (ou variável dependente). Suponha ainda que cada variável de saída pode ser descrita aproximadamente como uma combinação afim do seu respectivo vetor de entradas, isto é:
$
  y_n = sum_(j=1)^D theta_j x_(n j) + theta_0 + epsilon_n = theta^T x_n + epsilon_n
$
onde $epsilon_n in RR$ é uma variável que reflete o grau de incerteza na observação de $y_n$

*Nota*: A partir daqui, insermos um $1$ no vetor $x$ para representar o _bias_, então vamos redefinir $x_n := (1, x_(n 1), ..., x_(n D))^T$ e $theta := (theta_0, theta_1, ..., theta_D)^T$, de modo que a expressão acima possa ser escrita de forma mais compacta como $y_n = theta^T x_n + epsilon_n$.

Uma das maneiras mais comuns de obter uma estimativa $hat(theta)$ para $theta$ é obter o aquele que minimiza a média (ou a soma) dos erros quadráticos entre as predições $hat(y)_n := hat(theta)^T x_n$ e as saídas observadas $y_n$:
$
  hat(theta)_"LS" := "argmin"_(theta in RR^(D+1)){cal(l)(theta) := 1/N sum_(n=1)^N (y_n - theta^T x_n)^2}
$
Esse método de otimização é chamado de *mínimos quadrados ordinários*
Podemos escrever a função de custo $cal(l)$ de forma matricial como:
$
  cal(l)(theta) &= 1/N ||y - X theta||_2^2    \
  &= 1/N (y - X theta)^T (y - X theta)    \
  &= 1/N (y^T y - 2 theta^T X^T y + theta^T X^T X theta)
$

Note que, quando $X^T X$ é positiva definida, a função de custo $cal(l)$ é estritamente convexa, o que garante a existência de um único mínimo global. Podemos encontrar uma solução analítica para $hat(theta)_"LS"$ derivando $cal(l)$ e igualando a zero:
$
  nabla_theta cal(l)(theta) &= 1/N (-2 X^T y + 2 X^T X theta) = 0    \

  &=> hat(theta)_"LS" = (X^T X)^(-1) X^T y
$<hat-theta-ls>

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *E se $X^T X$ não for positiva definida?*: Considere o caso em que $N > D$. Para que a inversa exista, precisamos que todas as colunas de $X$, nossas variáveis preditoras, sejam linarmente independentes. Caso contrário, não podemos calcular a inversa na Equação @hat-theta-ls. No entanto, essas variáveis não agregam nenhuma informação ao nosso modelo de regressão, e podemos pré-processar os dados de maneira a remover atributos redundantes. Uma outra alternativa, é substituir a inversa de $X^T X$ pela inversa de $X^T X + alpha I$, para algum pequeno escalar $alpha$ positivo. É possível provar que $X^T X + alpha I$ sempre possui inversa (verifique!)
]

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Casos $N = D$ e $N < D$*: No caso em que o número de dados é igual ao número atributos ($N = D$), existe uma solução ótima única, com $cal(l)=0$, se a matriz $X$ possuir inversa. Nesses casos, a função linear resultante, com $hat(theta)_"LS" = X^(-1)y$, intersecta todos as observações $D$.
  
  Quando $N < D$, no caso mais geral, o problema admite infinitas soluções com $cal(l) = 0$. Quando as linhas de $X$ são linearmente independentes — $"posto"(X) = N$ — uma opção comum é achar a solução que possui a menor norma L2, dada por $hat(theta)_"MN" = X^T (X X^T)^(-1) y$
]

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Em bancos de dados massivos*: Quando $N$ é um grande número, armazenar a matriz $X$ nas camadas de memória mais velozes de um computador se torna impraticável e, portanto, calcular $hat(theta)_"LS"$ usando a Equação @hat-theta-ls não é computacionalmente viável. Nesse caso, podemos utilizar SGD para minimizar $cal(l)$. Para tal, note que pode-se escrever $cal(l)(theta) = sum cal(l)_n (theta)$, no qual definimos $cal(l)_n (theta) := 1/N (y_n - theta^T x_n)^2$
]

#example([Regressão Linear Simples])[
  No ano 2020, o mundo foi tomado por uma pandemia do vírus Sars-Cov-2, causando milhões de infeções e centenas de milhares de mortos. No dia 29 de abril, a infeção ainda não havia atingido seu estado crítico no Ceará.

  Neste exemplo, utilizamos um modelo linear para descrever o logaritmo do número de novas infeções diárias no Ceará como uma função do número de dias que se passaram desde a data na qual o primeiro caso de infecção foi reportado. Uma das utilidades de um modelo como esse é produzir estimativas para o número de novos infectados nos próximos dias, o que pode auxiliar epidemiologistas e gestores públicos em seus processos de tomada de decisão.

  #figure(
    image("images/regression-ceara.png", width: 60%)
  )

  Vale a pena ressaltar que em geral a dinâmica de contágios em uma epidemia possui um ponto de inflexão no qual número de novos casos começa a diminuir. Portanto, um modelo linear como esse não descreve todo o processo epidemiológico e seu uso deve ser validado por um especialista.
]

#example([Antiruido])[
  O método de mínimos quadrados pode ser utilizado para remoção de ruído (denoising). Suponha que você recebe um sinal digital ruidoso $s_r (t)$ em que $t$ denota um instante de tempo discreto e $t = 1, ... , T$. Estamos interessados em encontrar a versão não ruidosa $s (t)$ de $s_r (t)$.

  Um sinal ruidoso $s_r (t)$ pode ser decrito como um sinal suave $s(t)$ adicionado de
  um ruído de alta frequência $r(t)$:

  #figure(
    image("images/ruido.png")
  )

  Queremos encontrar um sinal $s$ que seja:
  - Similar ao sinal ruidoso
  - Suave (a diferença entre os valores do sinal em instantes sucessivos seja pequena)

  Com essas propriedades em mente, podemos propor uma função custo a se minimizar da forma:
  $
    min_(s in RR^T) underbrace(||s - s_r||^2, "similar ao sinal ruidoso") + underbrace( mu sum_(t=1)^(T-1) (s(t+1) - s(t))^2, "suavidade")
  $
  onde $s$ é a representação vetorial do sinal $s(t)$. O termo $mu$ controla o peso que queremos dar a propriedade da suavidade. Essa função custo pode ser colocada na forma $min_s ||y - X s||^2$ escolhendo:
  $
    X = mat(
      I_(T times T);
      sqrt(mu) D_(T-1 times T)
    ),

    D = mat(
      -1, 1, 0, ..., 0;
      0, -1, 1, ..., 0;
      dots.v, 0, -1, 1, 0;
      0, 0, ..., -1, 1
    ),

    y = mat(
      s_r;
      0;
      0;
      dots.v;
      0
    ) in RR^(2T-1)
  $
]

Nesse formato, o valor ótimo $s^*$ para o sinal $s$ é obtido com a solução de mínimos quadrados $s^* = (X^T X)^(-1) X^T y$. As figuras abaixo mostram a solução ótima para valores de $mu in {0, 100, 20000}$. Para $mu = 0$, a solução ótima é o próprio sinal ruidoso. Com $mu = 20000$, o sinal fica muito suave, tendendo a um sinal constante. Finalmente, para $mu = 100$, temos um sinal filtrado com eliminação da componente de ruído.

#figure(
  image("images/denoising.png")
)

== Perspectiva Probabilística
Podemos obter o mesmo estimador de mínimos quadrados se assumirmos o seguinte modelo observacional para cada resposta dado sua respectiva entrada:
$
  y_n|x_n ~ N(theta^T x_n, sigma^2) forall n = 1, ... , N
$<modelo-observacional>
podemos então procurar o estimador de máxima verossimilhança $hat(theta)_"ML"$ para $theta$:
$
  => f_n (y|x, theta) &= product_(n=1)^N f (y_n|x_n, theta) = (1/(sqrt(2 pi sigma^2))^N) exp(- sum_(n=1)^N (y_n - theta^T x_n)^2 / (2 sigma^2))   \
$
$
  => log f_n (y|x, theta) = -N/2 log(2 pi sigma^2) - 1/(2 sigma^2) sum_(n=1)^N (y_n - theta^T x_n)^2
$
$
  => hat(theta)_"ML" = "argmax"_(theta in RR^(D+1)) log f_n (y|x, theta) = "argmin"_(theta in RR^(D+1)) underbrace(sum_(n=1)^N (y_n - theta^T x_n)^2, N dot cal(l)(theta))
$

ou seja, a estimativa que máximiza a verossimilhança do modelo descrito pela equação @modelo-observacional é equivalente à estimativa obtida minimizando a média dos erros quadrados. Mais importante, note que, quando fazemos regressão linear, estamos parametrizando um parâmetro (a média) do nosso modelo observacional como uma transformação linear do vetor de entrada.

== Modelo com expansão de base
O método de mínimos quadrados aplicado a modelos lineares é atraente por sua simplicidade e pelo fato de admitir uma solução ótima analítica. No entanto, a consideração que a relação entre as variáveis de entrada e de saída é linear pode não ser válida em diversos problemas. Um das formas de combinar a vantagem de termos uma solução ótima analítica com um modelo mais geral e flexível do que o linear é utilizar uma transformação não-linear das variáveis de entrada.

Nessa abordagem, de forma geral, o primeiro passo consiste em transformar as variáveis de entrada $x$ através de uma função $Phi : RR^D → RR^M$ , em que normalmente $M$ é maior que $D$. Em seguida, aplicamos um transformação linear sobre as variáveis transformadas para obtermos
as predições $hat(y)$ para as variáveis de saída $y$. Ou seja, considere as variáveis transformadas $z := Phi(x)$, o modelo preditivo é dado por:
$
  hat(y) = theta^T z = theta^T Phi(x)
$
onde o vetor $theta in RR^M$ denota os parâmetros do modelo

Note que o modelo é não linear com relação às entradas originais $x$, mas é linear no espaço das variáveis $z$. Quando a transformação $Phi$ é fixa, sem parâmetros a serem aprendidos, o modelo é dito ser linear nos parâmetros. Nesses casos, a solução de mínimos quadrados é obtida simplesmente substituindo a matriz original de regressores $X$ por uma matriz $Z = [z_1, ... , z_N ]^T$ de entradas transformadas na equação @hat-theta-ls:
$
  hat(theta)_"LS" = (Z^T Z)^(-1) Z^T y
$
A transformação $Phi$ atua como um pré-processamento das entradas $x_1, ... , x_N$ . A seguir, estudaremos algumas das escolhas mais comuns para $Phi$

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Por que $M > D$?*: As variáveis de entrada $x$ representam atributos de um objeto sob o qual queremos realizar predições. Em geral quando aplicamos a transformação não-linear $Phi$ queremos encontrar novos atributos $z$ que permitam ao modelo linear ser preciso. Dessa forma, é natural trabalharmos em espaços com dimensões maiores, aumentando a chance de encontrarmos atributos relevantes. Vale ressaltar que isso não constitui uma regra. Conforme veremos adiante, o aumento do valor M pode gerar problemas, especialmente quando temos poucas amostras proporcionalmente a $M$
]

=== Polinômios
Funções de expansão de base podem ser utilizadas para construir modelos polinômiais. Para entradas e saídas escalares, podemos descrever um modelo de regressão polinomial de grau dois como:
$
  hat(y) = theta_3 + theta_2 x + theta_1 x^2 = theta^T Phi(x) = theta^T z
$
onde $z = Phi(x)$ é dado por:
$
  z = Phi(x) = mat(
    x^2;
    x;
    1
  )
$
O mesmo pode ser feito para entradas multivariadas (A função $Phi$ fica um pouco mais complexa) e qualquer expansão de grau polinomial finito. Por exemplo, para entradas bidimensionais, obtemos um modelo de grau 2 se:
$
  Phi(x) = mat(
    x_1^2;
    x_2^2;
    x_1 x_2;
    x_1;
    x_2;
    1
  )
$

#example([Regressão Polinomial em funções não-lineares])[
  Considere o problema de regressão univariada $(D = 1)$ em que as entradas pertencem ao intervalo $[-10, 10]$ e a função alvo é dada por $f(x) = sin(x)\/x$, também conhecida como função _sinc_. Além disso, utilizamos um conjunto de dados com $200$ pares de entrada-saída $(x_i, y_i)$, em que as saídas estão corrompidas por um ruído aditivo gaussiano, ou seja, $y = f(x) + epsilon$ com $epsilon ~ N(0, 0.05)$. Nesse exemplo, empregamos modelos polinomiais com grau $d in {1, 2, 5, 10}$.

  A Figura abaixxo mostra as predições obtidas com
  os diferentes modelos. Observe que, para $d = 1$,
  temos o modelo de regressão linear básico que estudamos anteriormente, e a aproximação consiste em
  uma reta. Note que, à medida que aumentamos o
  grau do polinômio, o modelo se torna mais flexível,
  conseguindo aproximar melhor os dados (represen-
  tados por pequenos círculos pretos), e portanto o
  melhor modelo possui $d = 10$ (curva em vermelho)

  #figure(
    image("images/polynomial-regression.png")
  )
]

=== Funções de base radiais
Vamos agora estudar um novo formato para a transformação $Phi$. De forma simples, ele consiste em escolher $M$ pontos $c_1, c_2, ... , c_M$ do $RR^D$, também chamado de centros ou protótipos, e então criar o vetor de regressores $z = Phi(x)$ combinando funções radiais em torno de cada um dos centros.

#definition([Função radial no RR^D])[
  Dada uma métrica $||dot||$ no $RR^D$ e $c in RR^(D)$, dizemos que $f_c: RR^D -> RR$ é radial se existe uma função $f: [0, infinity) -> RR$ tal que $f_c (x) = f(||x - c||)$
]

Podemos então construir uma transformação $Phi$ que utiliza $M$ funções radiais da forma:
$
  Phi(x) = mat(
    f_(c_1) (x);
    f_(c_2) (x);
    dots.v;
    f_(c_M) (x)
  ) = mat(
    f(||x - c_1||);
    f(||x - c_2||);
    dots.v;
    f(||x - c_M||)
  )
$

Quando as funções $f_(c_1) (x), . . . f_(c_M) (x)$ são linearmente independentes, e a matriz
$
  mat(
    f_(c_1) (c_1), f_(c_2) (c_1), ..., f_(c_M) (c_1);
    f_(c_1) (c_2), f_(c_2) (c_2), ..., f_(c_M) (c_2);
    dots.v;
    f_(c_1) (c_M), f_(c_2) (c_M), ..., f_(c_M) (c_M)
  )
$
é não-singular, essas funções são chamadas de funções de base radiais (radial basis functions, RBFs).  modelo de regressão linear com transformações através de funções de base radiais constitui uma classe de rede neurais chamada redes RBF #link("https://sci2s.ugr.es/keel/pdf/algorithm/articulo/1988-Broomhead-CS.pdf", "(Broomhead & Lowe, 1988)")

A completa definição da transformação $Phi$ envolve duas escolhas: a localização dos centros
$c_1, ... , c_M$ e a função de base radial.

*Escolhendo os centros*. Um das formas mais simples de escolher $M$ protótipos consiste
em selecionar aleatoriamente entradas $x_i$ do próprio conjunto de dados. Nessa abordagem, o
conjunto de centros é um subconjunto ${c_1, . . . , c_M } subset.eq {x_1, . . . , x_N }$ qualquer de tamanho $M$.

No entanto, a estratégia mais comum e que se tornou padrão consiste em selecionar centros de forma a capturar a densidade dos vetores de entrada. Para isso, normalmente empregamos métodos de análise de agrupamentos (clustering), tais como o k-médias (Lloyd, 1982). A discussão sobre o impacto da escolha dos centros está fora do escopo deste material

*Escolhendo a função de base radial*. Existem diversas escolhas possíveis para $f_(c_i)$ , algumas das mais notórias são:
1. Gaussiana:
$
  f_(c_i) (x) = e^(-gamma||x-c_i||^2_2)
$
onde $gamma > 0$ é uma constante;

2. Multi-quadrática:
$
  f_(c_i) (x) = sqrt(1 + epsilon||x - c_i||^2_2)
$
onde $epsilon > 0$ é uma constante.

#block(
  width: 100%,
  fill: rgb("#c5f7fd"),
  inset: 1em,
  stroke: 1.5pt + rgb("#066875"),
  radius: 5pt
)[
  *Redes RBF e interpolação*: As redes RBF foram originalmente propostas para resolver problemas de interpolação: Dado um conjunto de $N$ pares entrada saída $(x_i, y_i)$, queremos encontrar uma função $g$ tal que
  $
    g(x_i) = y_i, wide i = 1, . . . , N
  $
  
  Escolhendo $g$ tal que $g(x) = theta^T Phi(x) = theta^T z$ com $N$ funções de base radiais e $c_i = x_i$ para todo $i = 1, ..., N$ , a matriz de regressores $Z : Z_(i j) = f_(c_j)(x_i)$ é quadrada e a condição de interpolação equivale ao sistema linear:
  $
    Z theta = y "com" Z = mat(
      f_(c_1) (x_1), f_(c_2) (x_1), ..., f_(c_N) (x_1);
      f_(c_1) (x_2), f_(c_2) (x_2), ..., f_(c_N) (x_2);
      dots.v;
      f_(c_1) (x_N), f_(c_2) (x_N), ..., f_(c_N) (x_N)
    )
  $
  Dessa forma, obtemos um interpolador com a rede RBF desde que a matriz $Z$ seja não-singular. Micchelli (1986) mostrou que matrizes $Z$ formadas usando tanto funções radiais gaussianas quanto multi-quadráticas são não-singulares (possuem inversa), e a única condição para isso é que os centros (ou equivalentemente as entradas) sejam distintos. Como consequência, no caso em que $M < N$ e os centros são um subconjunto das entradas, a matriz $Z^T Z$ utilizada na solução dos mínimos quadrados possui inversa.
]

#example([Redes RBF])[
  Este exemplo ilustra o impacto do número de funções de base na aproximação realizada por redes RBF com função radial Gaussiana. Para isso, vamos utilizar novamente o problema de regressão com função alvo _sinc_, com exatamente a mesma configuração descrita no último exemplo. Os centros das RBFs foram selecionados de forma igualmente espaçados no intervalo $[-10, 10]$.

  A Figura abaixo (lado esquerdo) mostra a aproximação obtida usando uma rede RBF com $M in {5, 20}$ e $gamma = 1$. Note que o modelo com $k = 20$ aproxima melhor os dados. O aumento no número de funções de base aumenta a flexibilidade do modelo em se ajustar aos dados. Na Figura à direita, percebemos que o aumento no valor de $gamma$ produz funções radiais com variância (ou largura de banda) pequena, resultando em um aspecto oscilatório da curva de aproximação

  #figure(
    image("images/rbf-regression.png")
  )
]
