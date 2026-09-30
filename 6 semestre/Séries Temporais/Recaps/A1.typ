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
    Séries Temporais
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
  = Introdução às Séries Temporais
]

#pagebreak()

== Definições

#definition("Série Temporal de Tempo Discreto")[
  Conjunto de observações $y_t$ registradas em intervalos de tempo específico $t$ medidas de forma *discreta*.
  $
    {y_t}|_(t=1)^T
  $
]

#example[
  A temperatura de uma região registrada *diariamente*
]

#definition("Modelo de Séries Temporais")[
  Um modelo de séries temporais para ${y_t}$ é a *especificação da distribuição conjunta* de uma *sequência de variáveis aleatórias* ${Y_t}$ das quais ${y_t}$ é esperada ser uma realização
  $
    PP(X_1 <= x_1,...,X_n<=x_n), -infinity < x_1,...,x_n < infinity, n=1,2,...
  $
]

Modelar essa distribuição é muito complexo, pois temos acesso apenas à uma realização da série temporal ${Y_t}$. Para contornar essa limitação, focamos nos momentos de *primeira* e *segunda* ordem
$
  EE[Y_t] "e" EE[Y_t Y_(t+h)]
$

== Por que modelar séries temporais é importante?
Até agora, discutimos principalmente o tratamento de dados que não possuem uma estrutura temporal. No entanto, muitas vezes nos deparamos com dados onde o tempo desempenha um papel crucial.

=== Dependência Temporal dos Resíduos
Quando os modelos discutidos anteriormente não conseguem capturar completamente a estrutura dos dados, pode restar uma dependência temporal nos resíduos. Isso significa que as
observações ao longo do tempo estão correlacionadas, e essa dependência não foi removida.

Modelar essa dependência temporal pode levar a previsões mais precisas, pois aproveitamos a
informação contida na sequência temporal dos dados.

=== Como identificar dependência temporal nos resíduos?
Podemos utilizar ferramentas que vamos conhecer ao longo do curso, como gráficos de
autocorrelação (ACF) e testes estatísticos (como o teste de Ljung-Box) para identificar padrões
temporais nos resíduos. Esses métodos nos ajudam a verificar se há correlação significativa entre os resíduos em diferentes lags temporais.

=== Como modelar essa dependência?
Uma vez identificada a dependência temporal, podemos usar modelos de séries temporais, como
por exemplo os modelos auto-regressivos (AR), modelos de média móvel (MA) ou modelos
ARIMA, que são projetados para capturar e modelar essas dependências de maneira eficaz.

=== Usos
Existem $3$ usos complementares *principais* para séries temporais:

*Descrever*. Entender o que aconteceu na série: tendência, sazonalidade, choques, mudanças de regime. A pergunta é interpretativa — _o que o traço temporal revela?_

*Diagnosticar*. Avaliar se um modelo (clássico com covariáveis, baseline ingênuo, etc.) ainda deixou memória no tempo nos resíduos. Se os erros em $t$ e em $t+h$ ainda se relacionam de forma sistemática, a estrutura temporal não foi absorvida. Ferramentas formais de identificação (por exemplo ACF e testes como Ljung-Box) entram mais adiante no curso; o ponto conceitual já agora é: diagnóstico temporal é parte do trabalho, não um acessório opcional.

*Prever*. Produzir expectativas para $t+1,...,t+h$ com base no passado disponível até o momento.
Previsão boa não é apenas “ajustar bem o histórico”; é generalizar para a frente, sob a mesma seta do tempo



#pagebreak()

#align(center + horizon)[
  = Modelagem Clássica aplicada ao Tempo
]

#pagebreak()

== Modelo linear padrão
É o modelo mais simples que podemos utilizar para modelar a dependência entre uma variável dependente $y_t$ e variáveis explicativas $x_(i t)$ ao longo do tempo. Já vimos esse modelo $n$ vezes nos semestres passados, então vou reescrever apenas os passos mais importantes
$
  y_t = beta_0 + sum_(i = 1)^P beta_i x_(i t) + epsilon_t wide epsilon_t ~ N(0, sigma^2)
$
ou, em forma matricial
$
  y = X beta + epsilon wide epsilon ~ N(0, sigma^2 I) => y ~ N(X beta, sigma^2 I)
$
onde $y in RR^T$ é o vetor das observações da variável dependente, $X in RR^(T times P)$ é a matriz de observações das variáveis explicativas, $beta in RR^P$ é o vetor de pesos atribuindo a importância de cada parâmetro para explicar $y$ e $epsilon in RR^T$ é um ruído gaussiano. Com essa estrutura, podemos obter o estimador de máxima verossimilhança de $beta$
$
  hat(beta) = (X^T X)^(-1) X^T y
$

== Balanço Viés-Variância
Vale relembrar que dentro do ramo da estatística (inclusive das séries temporais), sempre existirá o balanço *viés e variância*. O erro mais comum de se minimizar em contextos estatísticos é o erro quadrático médio
$
  EE[(y_t - hat(y)_t)^2] = "Bias"(hat(y)_t)^2 + VV[hat(y)_t]^2 + sigma^2
$

Obter modelos mais precisos na previsão de $y_t$ (com menos viés) acaba resultando em modelos com variação alta (mudanças pequenas nos dados podem impactar muito os resultado) e vice-versa

== Regularização Lasso e Ridge
Quando temos muito mais parâmetros do que amostras, o modelo pode se tornar muito instável, e isso pode ser recorrente na análise de séries temporais. Pode ocorrer de um paciente poder ser analisado por apenas 3 semanas, enquanto o modelo leva em conta 15 informações sobre o mesmo. Nesses cenários, podemos introduzir um parâmetro de regularização em nossos modelos

=== Lasso (Least Absolute Shrinkage and Selection Operator)
Em vez de minimizarmos simplesmente o erro quadrático, adicionamos um peso nos valores absolutos dos coeficientes, de forma que se eles crescem muito em módulo, a nossa função de perca não diminui como esperado
$
  sum_(t=1)^T (y_t - hat(y)_t)^2 + lambda sum_(i=1)^P |beta_i|
$
essa abordagem tente a zerar alguns coeficientes, indicando quais coeficientes realmente influenciam ou não

=== Ridge Regression
Em vez dos valores absolutos, usamos a soma dos quadrados
$
  sum_(t=1)^T (y_t - hat(y)_t)^2 + lambda sum_(i=1)^P beta_i^2
$
essa abordagem não costuma zerar os coeficientes, mas os puxa para muito próximo de $0$

== Generalized Additive Models (GAM)
Extensão dos modelos lineares, permitindo que cada variável possua uma função não-linear associada com ela. A estrutura do GAM é dada por
$
  y_t = f_1 (x_(1 t)) + ... + f_p (x_(p t)) + epsilon_t
$

Aqui, $f_j (dot)$ são funções não-lineares suaves que modelam a relação entre $y_t$ e $x_(j t)$. O exemplo mais conhecido de GAM são os modelos polinomiais

== Deep Learning (DL)
Em deep learning, expressamos a relação entre $y_t$ e suas covariáveis através de uma função complexa $f$
$
  y_t = f(x_(1 t), ..., x_(p t)) + epsilon_t
$
onde $f$ é uma função altamente flexível modelada por uma rede neural, capaz de capturar padrões complexos e não-lineares dos dados

=== Janelas, Batches e Seta do Tempo
As redes neurais, durante seu treinamento, assumem uma hipótese que muitas vezes esquecemos, mas que são MUITO importantes no nosso contexto. Os dados *podem ser trocados*, eu posso embaralhar minhas amostras *sem perca de informação*. No entanto, o conceito de séries temporais não permite essa premissa, o que podemos fazer para mitigar isso? É aí que entram as *janelas*, onde empacotamos o passado e a dependência temporal entre elas. Por exemplo, imagine que temos a seguinte sequência:
$
  {10, 12, 9, 14, 11, 13, 8, 15...}
$
para podermos alimentar essas informações em uma rede neural, vamos criar uma janela de tamanho $3$ e gerar nossos conjuntos de dados e alvo
$
  "Janela 1" -> {10, 12,  9}  ->  14    \
  "Janela 2" -> {11,  13, 8}  ->  15    \
$

perceba que eu sempre pego um conjunto de $3$ valores e digo que o valor resultante (alvo) deve ser o seguinte e assim por diante. Dessa forma, a ordem *entre janelas* passa a ser irrelevante pois a informação de passado e como ele influencia na resposta está incorporada na própria janela. No entanto, vale ressaltar que a ordem *dentro da janela* é *sagrada* e *nunca deve ser alterada*, do contrário a informação temporal entre amostras *se perde*

Como nem tudo são flores, existem alguns pontos de atenção que devemos tomar cuidado. O primeiro é quando formos separar nossos dados nos conjuntos de *treino* e *teste*. Não podemos, ao realizar a divisão, criar janelas com dados em conjuntos diferentes. Por exemplo, se temos a seguinte série, e fazemos a seguinte separação:
$
  {underbrace("10, 12, 9, 14, 11", "TREINO"), underbrace("13, 8, 15", "TESTE")...}
$
em hipótese alguma podemos, dentro das nossas janelas de treino, ter uma janela tipo ${14, 11, 13}$, pois estariamos misturando pontos de treino e teste, de forma que nosso modelo estaria vendo o futuro fora do controlado

Além disso, devemos tomar cuidado com *janelas sobrepostas*. Como falei antes, criamos as janelas para que elas possam ser independentes, no entanto, é possível criar janelas que não são independentes (ainda podemos embaralhar elas como artimanha computacional). Por exemplo, dado a série:
$
  {10, 12, 9, 14, 11, 13, 8, 15, ...}
$
as janelas ${10, 12, 9}$ e ${12, 9, 14}$ se sobrepõem, de tal forma que elas NÃO são independentes pois contém a mesma parcela do passado e como ela influencia nos valores internos. O ponto é que, para um SGD, você *pode* embaralhar essas janelas, mas isso não lhe permite tratá-las como *independentes*


#pagebreak()

#align(center + horizon)[
  = Diagnóstico Visual
]

#pagebreak()

== Introdução
Antes de testes formais, ARIMA, ACF, PACF, etc., podemos fazer um diagnóstico visual da série temporal. O objetivo é identificar padrões, tendências, sazonalidades e possíveis anomalias nos dados. Essa análise inicial nos ajuda a formular hipóteses sobre o comportamento da série e a escolher modelos apropriados para previsão. Podemos primeiro pensar na série como
$
  y_t = T_t + S_t + R_t
$

onde $T_t$ representa a tendência (nível que a série se move no médio/longo prazo), $S_t$ a sazonalidade (padrões que se repetem em intervalos fixos) e $R_t$ os resíduos (por definição, o que sobra após fixar $T_t$ e $S_t$)

#example[
  Vamos analisar a seguinte figura

  #figure(
    image("images/A1/tsr-example.png")
  )

  Visualmente conseguimos identificar cada um dos componentes da série temporal.

  *$T$*: No médio/longo prazo, a tendência é um crescimento linear, com inclinação positiva. Mesmo que existam flutuações de subida e descida, é perceptível que a cada ano o valor de $y_t$ tende a aumentar.
  *$S$*: A série mostra uma sazonalidade de subida no inicio de cada ano e descida no final, mostrando um padrão anual claro (mas de forma que a descida sempre se mantém acima do padrão anterior, gerando a tendência positiva citada anteriormente)
]

== Covariáveis
Dentro dessa estrutura, podem existir também *covariáveis explicativas* que influenciam a série temporal. Por exemplo, em uma série de vendas de um produto, fatores como campanhas de marketing, feriados ou eventos especiais podem afetar os valores observados. Incorporar essas covariáveis nos modelos pode melhorar a precisão das previsões e fornecer insights sobre os fatores que impactam a série. Ainda dentro do nosso framework visual, podemos introduzir essas covariáveis como
$
  y_t = underbrace(T_t + S_t, "Estrutura Temporal") + underbrace(x_t^T beta, "Covariáveis") + R_t
$

Na prática, $T_t$ e $S_t$ são incorporados dentro de $x_t$ e não são derivados explicitamente, mas é importante entender que eles existem e como eles caracterizam a série temporal. A análise visual pode nos ajudar a identificar quais covariáveis podem ser relevantes para o modelo e como elas se relacionam com os padrões observados na série.

== Tendência
Tendência é o movimento lento do nível da série: crescimento, queda ou platô ao longo de muitos períodos. Em dados mensais, uma média móvel com janela da ordem de um ano (por exemplo 12) alisa oscilações curtas e ajuda a ver esse nível. A média móvel aqui é ajuda visual, não um modelo formal

#figure(
  image("images/A1/tsr-trend.png", width: 100%),
  caption: "Exemplo de tendência em uma série temporal"
)

== Sazonalidade
Sazonalidade é estrutura que se repete em fases do calendário (mês do ano, dia da semana, hora do dia, ...). Distinguir sazonalidade de “subiu uma vez e nunca mais” é parte da descrição. Três gráficos olham a mesma sazonalidade, mas respondem perguntas diferentes.

*Overlay por ano*. Eixo = mês; uma linha por ano. Serve para ver *o ciclo se repetindo*: o formato do ano (pico/vale em quais meses); se o padrão é estável ou muda de ano para ano (linhas parecidas vs. um ano “fora”); a amplitude. Anos mais “altos” no gráfico ainda carregam tendência — o formato relativo é o que importa

#figure(
  image("images/A1/tsr-seasonality-overlay.png", width: 100%),
  caption: "Exemplo de sazonalidade em uma série temporal (overlay por ano)"
)

*Série sem tendência*. Plotar $y_t$ menos a média móvel (12) no calendário real. Serve para ver a *onda anual na seta do tempo*, depois de tirar o nível lento $T_t$. Dá para ver se a oscilação volta
todo ano (liga a $S_t$) e se a amplitude muda ao longo dos anos. Ainda mistura sazonalidade + ruído — não é puro.

#figure(
  image("images/A1/tsr-seasonality-detrended.png", width: 100%),
  caption: "Exemplo de sazonalidade em uma série temporal (série sem tendência)"
)

*Boxplot por mês*. Resume o nível típico de cada mês, agregando os anos. Serve para o ranking (quais meses são sistematicamente mais altos/baixos), a dispersão dentro do mês (caixa larga = aquele mês varia muito entre anos) e outliers. Não mostra a trajetória no tempo — cada mês aparece uma vez.

#figure(
  image("images/A1/tsr-seasonality-boxplot.png"),
  caption: "Exemplo de boxplot por mês"
)

== Resíduos
Por definição $R_t = y_t - (T_t + S_t)$, ou seja, o que sobra após extraírmos a tendência e a sazonalidade. Tomemos por exemplo o seguinte gráfico

#figure(
  image("images/A1/tsr-not-residuals.png", width: 100%),
  caption: "Exemplo de resíduos em uma série temporal"
)

Aqui, estratificamos $T$ que é a média móvel, no entanto, o gráfico ainda contém a estrutura da *sazonalidade*. Podemos, nesse caso, interpretar a sazonalidade como a *média mensal* de $y_t - T_t$ (detalhes serão melhor compreendidos posteriormente). Removendo essa sazonalidade $S_t$, então obtemos um gráfico dos resíduos

#figure(
  image("images/A1/tsr-residuals.png", width: 100%),
  caption: "Exemplo de resíduos em uma série temporal"
)

Essa extração visual é temporária, serve no momento para termos um entendimento do que são resíduos e como eles se comportam. Posteriormente, vamos aprender a extrair $T$ e $S$ de forma formal, utilizando modelos estatísticos

== Split Temporal
Comentamos anteriormente sobre, para fazer modelos preditivos das séries temporais, para separar eles em *treino* e *teste*. Sendo mais formal, isso é feito a partir de um *split temporal*, onde, ao invés de embaralhar os dados, pegamos uma parte inicial da série para treino e uma parte final para teste a partir de uma data-fronteira.

#figure(
  image("images/A1/tsr-split.png", width: 100%),
  caption: "Exemplo de split temporal em uma série temporal"
)

#pagebreak()

#align(center + horizon)[
  = Estacionariedade e ACF
]

#pagebreak()

== Introdução
Visualizamos anteriormente como utilizar de métodos *visuais* para identificar séries temporais, agora nosso foco vai ser formalizar esse conceito. Para tal, no entanto, precisamos definir alguns conceitos muito importantes, como média, covariância e a noção de *estacionariedade*

== Exemplos de Série
Esses serão os exemplos que vamos utilizar de forma recorrente

#example("Ruído Branco")[
  $
    Y_t = epsilon_t
  $
  Não existe memória, cada instante contém um ruído que não conseguimos traçar a partir dos anteriores

  #image("images/A1/whitenoise.png")
]

#example("AR")[
  $
    Y_t = phi Y_(t-1) + epsilon_t, wide |phi| < 1
  $
  Depende diretamente do valor anterior, mas não de valores mais antigos. A memória é curta, mas existe

  #image("images/A1/AR.png")
]

#example("Passeio Aleatório")[
  $
    Y_t = Y_(t-1) + epsilon_t
  $
  Acumula os ruídos passados, de forma que a memória é longa e o valor atual depende de todos os valores anteriores

  #image("images/A1/randomwalk.png")
]

#example("Tendência Linear")[
  $
    Y_t = beta_0 + beta_1 t + epsilon_t
  $
  A tendência linear é um caso especial de passeio aleatório, onde o valor atual depende do tempo e de todos os valores anteriores

  #image("images/A1/lineartrend.png")
]

== Conceitos

#definition("Função Média")[
  Seja ${Y_t}$ uma série temporal onde $EE[Y_t^2] < infinity$, então a média em cada instante, denotada como
  $
    mu_Y (t) = EE[Y_t]
  $

  É a tendência central do processo ao longo de $t$. Em geral pode depender do tempo: nada obriga $EE[Y_i] = EE[Y_j]$ para $i != j$
]

Nos quatro exemplos que comentamos, temos que $EE[epsilon_t] = 0$, então temos que:
- *Ruído Branco*: $mu_Y (t) = 0$
- *Tendência Linear*: $mu_Y (t) = beta_0 + beta_1 t$
- *AR*: $mu_Y (t) = phi dot mu_Y (t-1)$
- *Passeio Aleatório*: $mu_Y (t) = mu_Y (t-1)$, se considerarmos $Y_0 = 0$, então $mu_Y (t) = 0$, perceba que se mantém constante, isso mostra que uma realização não altera a *média*, mas sim a *covariância* do processo, que cresce com o tempo

#definition("Covariância")[
  Dados dois instantes $r,s$, definimos a covariância entre $Y_r$ e $Y_s$ como
  $
    gamma_Y (r,s) = EE[(Y_r - mu_Y (r))(Y_s - mu_Y (s))]
  $
]

Para vermos como a correlação nos exemplos vistos se comportam, tenha em mente que $VV[epsilon_t] = sigma^2$ e $gamma_epsilon (r, s) = 0$ para $r != s$

- *Ruído Branco*: $gamma_Y (r,s) = 0$ para $r != s$, ou seja, não existe correlação entre os valores da série temporal e $gamma_Y (r,s) = sigma^2$ se $r = s$, ou seja, a variância é constante ao longo do tempo
- *Tendência Linear*: 
  $
    gamma_Y(r,s)
    &= "Cov"(Y_r,Y_s) \
    &= "Cov"(beta_0 + beta_1 r + epsilon_r, beta_0 + beta_1 s + epsilon_s) \
    &= "Cov"(epsilon_r,epsilon_s) \
    &=
    cases(
      sigma^2 wide r=s,
      0 wide r != s.
    )
  $
- *AR*: Dado que $Y_t = phi Y_(t-1) + epsilon_t$, então temos:
  $
    VV[Y_t] = VV[phi Y_(t-1) + epsilon_t] = phi^2 VV[Y_(t-1)] + sigma^2
  $
  e se assumirmos que $Y_t = Y_(t-1)$:
  $
    VV[Y_t] = phi^2 VV[Y_t] + sigma^2 => VV[Y_t] = sigma^2 / (1 - phi^2)
  $
- *Passeio Aleatório*: Assumindo o caso onde $Y_t = epsilon_1 + epsilon_2 + ... + epsilon_t$, temos que:
  $
    VV[Y_t] = VV[epsilon_1 + epsilon_2 + ... + epsilon_t] = t sigma^2
  $
  Ou seja, a variância do passeio aleatório cresce linearmente com o tempo. Além disso, a covariância entre dois instantes $r$ e $s$ é dada por
  $
    gamma_Y (r,s) = EE[Y_r Y_s] = EE[(epsilon_1 + ... + epsilon_r)(epsilon_1 + ... + epsilon_s)] = min(r,s) sigma^2
  $

#definition("Estacionariedade Fraca")[
  Dizemos que uma série temporal ${Y_t}$ é *estacionária fraca* se:
  - Média $mu_Y (t)$ é constante no tempo
  - Covariância $gamma_Y (r,s)$ depende apenas da diferença $|r-s|$ e não dos instantes absolutos $r$ e $s$
]

Como vemos pelos exemplos, as únicas séries que são estacionárias fracas são o *ruído branco* e o *AR*. A tendência linear e o passeio aleatório não são estacionários fracos, pois a média e a covariância dependem do tempo

== ACF e ACVF
Como falamos, a covariância de uma série temporal estacionária fraca depende apenas da diferença entre os instantes, então podemos definir a função de covariância como uma função do lag $h = |r-s|$, assim:

#definition("ACVF")[
  Dada a série temporal ${Y_t}$ estacionária fraca, definimos a função de autocovariância como
  $
    gamma_Y (h) = EE[(Y_r - mu_Y)(Y_(r+h) - mu_Y)]
  $
]

#definition("ACF")[
  Dada a série temporal ${Y_t}$ estacionária fraca, definimos a função de autocorrelação como
  $
    rho_Y (h) = frac(gamma_Y (h), gamma_Y (0))
  $
]

A ACF é uma função que mede a correlação entre os valores da série temporal em diferentes lags. Ela nos ajuda a identificar padrões de dependência temporal e a determinar a ordem de modelos AR e MA, é como se ela fosse a função que mede a *memória* da série temporal. Vale ressaltar que não é porque uma série tem estacionaridade fraca que ela não possui memória, como vimos no caso do AR, que é estacionário fraco, mas possui memória curta. O mesmo não ocorre com o passeio aleatório, que não é estacionário fraco e possui memória longa

== IID v.s Ruído Branco
A distinção entre um processo *I.I.D.* (independente e identicamente distribuído) e um *Ruído Branco* (White Noise - WN) baseia-se na intensidade da independência estocástica exigida entre os instantes de tempo

#definition("Ruído IID")[
  ${Y_t} ~ "I.I.D"(0, sigma^2)$ com $sigma^2 < infinity$ se
  $
    EE[Y_t] &= 0   \

    gamma_Y (h) &= cases(
      sigma^2 wide h=0,
      0 wide h != 0
    )
  $ 

  Exige independência estocástica completa entre todas as variáveis aleatórias $Y_t$ e $Y_s$ ($t != s$). Não há qualquer dependência (linear ou não-linear) ou variação nas distribuições marginais
]

#definition("Ruído Branco")[
  ${Y_t} ~ "WN"(0, sigma^2)$ com $sigma^2 < infinity$ se
  $
    EE[Y_t] &= 0   \

    gamma_Y (h) &= cases(
      sigma^2 wide h=0,
      0 wide h != 0
    )
  $ 

  Exige apenas ausência de correlação linear ($"Cov"(Y_(t+h), Y_t) = 0$ para $h != 0$) e estacionariedade de 2ª ordem
]

#theorem("Relação entre IID e White Noise")[
  $
    "I.I.D" (0, sigma^2) => "WN"(0, sigma^2)
  $
]

== Estimação Amostral
No dia a dia, não conseguimos dizer com precisão os parâmetros de uma série temporal, como a média e a covariância. Para contornar essa limitação, utilizamos estimadores amostrais, que são funções das observações da série temporal que nos permitem inferir sobre os parâmetros populacionais

#definition("Estimador de média amostral de processo estocástico fracamente estacionário")[
  Dada uma realização ${y_1, y_2, ..., y_T}$ de um processo estocástico fracamente estacionário $\{Y_t\}$ com média populacional $EE[Y_t] = mu$ e função de autocovariância $gamma(h) = "Cov"(Y_t, Y_(t+h))$, o estimador da média amostral é definido por
  $
    overline(Y)_t = 1/T sum_(t=1)^T Y_t
  $
]

#theorem("Não-viesamento e Variância da Média Amostral")[
  Se ${Y_t}$ for um processo fracamente estacionário com $EE[Y_t] = mu$ e autocovariância $gamma(h)$ então
  - $overline(Y)_t$ é um estimador não-viesado de $mu$
  - A variância de $overline(Y)_t$ é dada por
    $
      VV[overline(Y)_t] = 1/T sum_(h=-(T-1))^(T-1) (1 - (|h|)/T) gamma(h)
    $
]
#proof[
  *Parte do não-viesamento*: Aplicamos a esperança no estimador
  $
    EE[overline(Y)_t] = EE[1/T sum_(t=1)^T Y_t] = 1/T sum_(t=1)^T EE[Y_t] = 1/T sum_(t=1)^T mu = mu
  $

  *Parte da variância*: Pela definição da variância da soma de variáveis aleatórias, temos
  $
    VV[overline(Y)_t] = VV[1/T sum_(t=1)^T Y_t] = 1/T^2 VV[sum_(t=1)^T Y_t] = 1/T^2 sum_(r=1)^T sum_(s=1)^T "Cov"(Y_r, Y_s)
  $
  como o processo é fracamente estacionário, podemos reescrever a covariância como uma função do lag $h = |r-s|$, assim
  $
    VV[overline(Y)_t] = 1/T^2 sum_(r=1)^T sum_(s=1)^T gamma(|r-s|)
  $

  se agruparmos os pares $(r,s)$ cuja a diferença $r-s$ seja igual a um determinado lag $h$ (${-(T-1),...,T-1}$), nota-se que existem exatamente $T-|h|$ pares com aquele lag $h$. Logo, podemos reescrever a soma como
  $
    VV[overline(Y)_t] = 1/T^2 sum_(h=-(T-1))^(T-1) (T - |h|) gamma(h) = 1/T sum_(h=-(T-1))^(T-1) (1 - (|h|)/T) gamma(h)
  $
]

#definition("Autocovariância Amostral")[
  A autocovariância amostral usual para um lag $h>=0$ é definida com o divisor $T$
  $
    hat(gamma)(h) = 1/T sum_(t=1)^(T-h) (Y_t - overline(Y)_t)(Y_(t+h) - overline(Y)_t) wide 0<=h<T
  $
]

#theorem("Propriedades do estimador de Autocovariância Amostral")[
  + O estimador de autocovariância amostral é viesado em amostra finita, mas é *assintoticamente não-viesado* (isto é, $lim_(T->infinity) EE[hat(gamma)(h)] = gamma(h)$)
  + O uso do divisor $T$ em vez de $T-h$ garante que a matriz de autocovariância amostral seja *semi-definida positiva*, o que é importante para a consistência de estimadores de modelos de séries temporais e minimiza o MSE para lags elevados  
]
#proof[
  Para simplificar a demonstração sem perder generalidade, considere inicialmente o estimador simplificado com $mu$ conhecido
  $
    tilde(gamma)(h) = 1/T sum_(t=1)^(T-h) (Y_t - mu)(Y_(t+h) - mu)
  $
  tomando a esperança desse estimador
  $
    EE[tilde(gamma)(h)] &= 1/T sum_(t=1)^(T-h) EE[(Y_t - mu)(Y_(t+h) - mu)]   \
    &= 1/T sum_(t=1)^(T-h) gamma(h)   \
    &= (T-h)/T gamma(h)
  $
  logo
  $
    EE[tilde(gamma)(h)] - gamma(h) = -h/T gamma(h)
  $

  Quando substituímos $mu$ por $overline(Y)_t$, o estimador se torna viesado, mas a diferença entre os dois estimadores é de ordem $O(1/T)$, logo, o estimador com média amostral também é assintoticamente não-viesado
  $
    lim_(T->infinity) EE[hat(gamma)(h)] = lim_(T->infinity) (1 - h/T) gamma(h) = gamma(h)
  $

  Com relação à matriz semi-definida positiva, considere o vetor de observações centradas $Y = (Y_1 - overline(Y)_T,...,Y_T - overline(Y)_T)^T$. A matriz de autocovariância amostral de ordem $k times k$ definida como
  $
    hat(Gamma)_k = [hat(gamma)(i - j)]^k_(i,j=1)
  $
  pode ser escrita da seguinte forma matricial
  $
    hat(Gamma)_k = 1/T X^T X
  $
  onde $X_(r j) = Y_(r - j + 1) - overline(Y)_T$ para $r in {1,...,T+k-1}$ e $j in {1,...,k}$. Para qualquer vetor não-nulo $a = (a_1, ..., a_k)^T in RR^k$:
  $
    a^T hat(Gamma)_k a = a^T (1/T X^T X) a = 1/T (X a)^T (X a) = 1/T ||X a|| >= 0
  $
  Se dividíssemos por $T-h$ em vez de $T$, esse cancelamento matricial exato falharia, podendo gerar matrizes de autocovariância amostrais não-definidas positivas (com variâncias teóricas negativas para combinações lineares da série) e maior variabilidade estatística em $h$
]

#definition("Autocorrelação Amostral")[
  A autocorrelação amostral é a razão normalizada
  $
    hat(rho)(h) = (hat(gamma)(h)) / (hat(gamma)(0))
  $
]

#theorem("Distribuição Limite sob Hipótese IID - Bartlett")[
  Se ${Y_t} ~ "IID"(0, sigma^2)$ com $EE[Y_t^4]<infinity$, então para qualquer $h>0$ fixo, quando $T->infinity$:
  $
    sqrt(T) hat(rho)_h ->^d cal(N)(0,1)
  $
  e isso implica que $hat(rho)_h approx cal(N)(0,1/T)$ para $T$ grande
]<acf-amostral-dist>
#proof[
  Sob a hipótese de ruído IID, temos que $mu=0$, $gamma(0) = sigma^2$ e $gamma(k) = 0 space forall k!=0$.

  *Passo 1 - Comportamento do Numerador*: Considere o estimador $tilde(gamma)(h) = 1/T sum_(t=1)^(T-h) Y_t Y_(t+h)$. Defina a sequência de variáveis $W_t = Y_t Y_(t+h)$. Como ${Y_t}$ é IID, de média $0$

  + $EE[W_t] = EE[Y_t Y_(t+h)] = EE[Y_t] EE[Y_(t+h)] = 0$
  + Para $t!=s$, as variáveis $W_t$ e $W_s$ são não-correlacionadas (Formam uma sequência de diferenças de martingale)
  + $VV[W_t] = EE[W_t^2] = EE[Y_t^2 Y_(t+h)^2] = EE[Y_t^2] EE[Y_(t+h)^2] = sigma^4$

  Pelo Teorema Central do Limite, para Sequências de Diferenças de Martingale, temos que
  $
    sqrt(T) tilde(gamma)(h) = 1/sqrt(T) sum_(t=1)^(T-h) W_t ->^d cal(N)(0, sigma^4)
  $

  *Passo 2 - Comportamento do Denominador*: O denominador $hat(gamma)(0)$, pela lei forte dos grandes números:
  $
    hat(gamma)(0) = 1/T sum_(t=1)^T (Y_t - overline(Y)_T)^2 ->^p VV[Y_t] = sigma^2
  $

  *Passo 3 - Aplicação do Teorema de Slutsky*: A autocorrelação pode escrita como
  $
    sqrt(T) hat(rho)(h) = sqrt(T) (tilde(gamma)(h)) / (hat(gamma)(0))
  $

  Como a substituição de $overline(Y)_T$ por $mu = 0$ introduz apenas termos de ordem $o_p (1)$ (que somem assintoticamente), aplicamos o Teorema de Slutsky combinando a convergência em distribuição do numerador com a convergência em probabilidade do denominador:
  $
    sqrt(T) hat(rho)(h) = (sqrt(T) hat(gamma)(h)) / (hat(gamma)(0)) ->^d (cal(N)(0, sigma^4)) / (sigma^2) = cal(N) (0, sigma^4 / (sigma^2)^2 ) = cal(N)(0, 1)
  $
]



#corollary("Construção formal do intervalo de confiança da ACF")[
  Do @acf-amostral-dist, decorre que quando temos um ruído IID e amostras grandes, podemos construir um intervalo de confiança para a autocorrelação amostral. Para um nível de confiança $1-alpha$:
  $
    PP(-z_(1-alpha\/2) <= sqrt(T) hat(rho) (h) <= z_(1-alpha\/2)) approx 1-alpha    \

    PP(-z_(1-alpha\/2) / sqrt(T) <= hat(rho) (h) <= z_(1-alpha\/2) / sqrt(T)) approx 1-alpha
  $
]

Com esse corolário, podemos interpretar o seguinte: Em um teste de nível de significância $alpha=0.05$ (confiança $95%$), usamos o quantil $z_(0.975) approx 1.96$, logo o intervalo de confiança é dado por
$
  [-1.96 / sqrt(T), 1.96 / sqrt(T)]
$

se o valor amostral $hat(rho) (h)$ ultrapassar um desses limites, então rejeita-se a hipótese nula $H_0$ da *ausência de autocorrelação* no lag $h$, ou seja, existe evidência de que a série temporal possui memória linear. Caso contrário, não rejeitamos a hipótese nula, indicando que não há evidência suficiente para afirmar que existe autocorrelação nesse lag


#pagebreak()

#align(center + horizon)[
  = Previsão e Baselines
]

#pagebreak()

No capítulo passado, nós definimos ACF, e como podemos utilizar ela para *diagnosticar* a presença de memória linear em uma série temporal. No entanto, não falamos sobre como utilizar essa informação para *prever* o futuro da série temporal

== Previsão via Autocorrelação $rho(h)$ e Esperança Condicional

#definition()[
  Seja ${Y_t}$ um processo estocástico *gaussiano* e *fracamente estacionário*, com média constante $EE[Y_t] = mu$, variância $VV[Y_t] = gamma_Y (0) = sigma^2$ e função de autocorrelação $rho_Y (h) = gamma_Y (h) \/ sigma^2$. O vetor formado pela observação presente $Y_n$ e pela observação futura $Y_(n + h)$ segue uma distribuição normal bivariada
  $
    mat(Y_n;Y_(n+h)) ~ cal(N)(mat(mu;mu), mat(sigma^2, rho_Y (h) sigma^2; rho_Y (h) sigma^2, sigma^2))
  $
]

#theorem("Condicional Gaussiana")[
  Sob a hipótesse de gaussianidade no processo ${Y_t}$, a distribuição condicional de $Y_(n+h)$ dado $Y_n=y_n$ é dada por
  $
    Y_(n+h) | Y_n = y_n ~ cal(N)(mu + rho_Y (h) (y_n - mu), sigma^2 (1 - rho_Y (h)^2))
  $
]
#proof[
  Defina a variável transformada $Z=(Y_(n+h) - mu) - beta (Y_n - mu)$ onde $beta$ é uma constante real *a ser determinada* para que $Z$ e $Y_n$ sejam *não-correlacionadas*. Pela definição de covariância, temos que
  $
    "Cov"(Z, Y_n) &= "Cov"((Y_(n+h) - mu) - beta (Y_n - mu), Y_n)   \
    
    &= "Cov"(Y_(n+h), Y_n) - beta VV[Y_n]   \
    
    &= gamma_Y (h) - beta sigma^2
  $

  para anular a covariância, escolhemos $beta = (gamma_Y (h)) / sigma^2 = rho_Y (h)$, assim:
  $
    Z = (Y_(n+h) - mu) - rho_Y (h) (Y_n - mu)
  $

  como $(Z, Y_n)$ é um vetor normal, temos que o fato de $"Cov"(Z, Y_n) = 0$ implica que $Z$ e $Y_n$ são independentes. Utilizando desse fato, sabemos que
  $
    EE[Z | Y_n] = EE[Z] &= 0    \
    EE[Y_(n+h) - mu - rho_Y (h) (Y_n - mu) | Y_n] &= 0   \
    EE[Y_(n+h) | Y_n] - mu - rho_Y (h) (Y_n - mu) &= 0   \
    EE[Y_(n+h) | Y_n] &= mu + rho_Y (h) (Y_n - mu)
  $

  Já para a variância condional, temos que
  $
    VV[Y_(n+h) | Y_n] &= VV[Z + rho_Y (h) (Y_n - mu) | Y_n]
  $
  como é DADO $Y_n$, o termo $rho_Y (h) (Y_n - mu)$ é uma constante, logo
  $
    VV[Y_(n+h) | Y_n] &= VV[Z | Y_n] = VV[Z]   \
    &= VV[Y_(n+h) - mu - rho_Y (h) (Y_n - mu)]   \
    &= VV[Y_(n+h)] + rho_Y (h)^2 VV[Y_n] - 2 rho_Y (h) "Cov"(Y_(n+h), Y_n)   \
    &= sigma^2 + rho_Y (h)^2 sigma^2 - 2 rho_Y (h) gamma_Y (h)   \
    &= sigma^2 + rho_Y (h)^2 sigma^2 - 2 rho_Y (h)^2 sigma^2   \
    &= sigma^2 (1 - rho_Y (h)^2)
  $
]

Dado esse contexto, podemos agora mostrar que para *qualquer preditor $g(Y_n)$*, *o preditor que minimiza o erro quadrático médio* é a *média condicional $EE[Y_(n+h) | Y_n]$*.

#theorem("Preditor que minimiza o MSE")[
  Para qualquer preditor $g(Y_n)$ baseado na observação $Y_n$, o preditor que minimiza o erro quadrático médio ($EE[(Y_(n+h) - g(Y_n))^2]$) é dado por
  $
    g(Y_n) = EE[Y_(n+h) | Y_n]
  $
]
#proof[
  Definindo o erro quadrático médio como $f$, temos:
  $
    f(y_n) &= EE[(Y_(n+h) - g(Y_n))^2|Y_n=y_n]
  $
  
  expandindo o termo quadrático, derivando e igualando a $0$, vamos ter que
  $
    g(Y_n) = EE[Y_(n+h) | Y_n=y_n]
  $
]

Sob a hipótese de gaussianidade, o preditor linear possui forma fechada de:
$
  EE[Y_(n+h) | Y_n] = mu + rho_Y (h) (Y_n - mu)
$
no entanto, sem essa premissa, o preditor linear pode não possuir forma fechada, mas ainda assim é o preditor que minimiza o erro quadrático médio. E como podemos perceber, a função $rho_Y (h)$ determina diretamente a qualidade e o formato da predição

- $rho_Y (h) -> 0$: A previsão tende a $mu$ e o erro quadrático médio tende a $sigma^2$, ou seja, a informação presente $Y_n$ não traz informação útil sobre o futuro $Y_(n+h)$. O melhor preditor reduz-se à média incondicional e a incerteza atinge a variância total da série
- $rho_Y (h) -> 1$: A previsão tende a $Y_n$ e o erro quadrático médio tende a $0$, ou seja, a informação presente $Y_n$ praticamente carrega toda a informação sobre o futuro $Y_(n+h)$. O melhor preditor aproxima-se do valor atual e a incerteza diminui significativamente

Mas como eu comentei antes, esse é o melhor preditor *sobre gaussianiedade*, mas não necessariamente o melhor preditor *sobre a série temporal*. No entanto, é possível chegar que, definindo um preditor genérico $l(Y_n) = alpha Y_n + beta$, o melhor $l$ é exatamente o preditor linear que obtivemos na prova anterior

#theorem("Preditor Linear que minimiza o MSE")[
  Para qualquer preditor linear $l(Y_n) = alpha Y_n + beta$ baseado na observação $Y_n$, o preditor que minimiza o erro quadrático médio ($EE[(Y_(n+h) - l(Y_n))^2]$) é dado por
  $
    l(Y_n) = mu + rho_Y (h) (Y_n - mu)
  $
  e apresenta um erro quadrático médio de $sigma^2 (1 - rho_Y (h)^2)$
]
#proof[
  Queremos determinar os escalares $alpha$ e $beta$ que minimizam o erro quadrático médio
  $
    f(alpha, beta) = EE[(Y_(n+h) - (alpha Y_n + beta))^2]
  $
  expandindo o termo quadrático (e lembrando que $EE[Y_n] = EE[Y_(n+h)] = mu$), temos que
  $
    f(alpha, beta) = EE[Y_(n+h)^2] - 2 alpha EE[Y_n Y_(n+h)] - 2 beta mu + alpha^2 EE[Y_n^2] + 2 alpha beta mu + beta^2
  $
  e derivando com relação à $alpha$
  $
    (partial f)/(partial alpha) = -2 EE[Y_n Y_(n+h)] + 2 alpha EE[Y_n^2] + 2 beta mu = 0
  $
  igualando a $0$ e isolando $alpha$, temos que
  $
    alpha = (EE[Y_n Y_(n+h)] - beta mu) / EE[Y_n^2]
  $
  agora derivando com relação à $beta$
  $
    (partial f)/(partial beta) = -2 mu + 2 alpha mu + 2 beta = 0
  $
  igualando a $0$ e isolando $beta$, temos que
  $
    beta = mu(1 - alpha)
  $
  substituindo $beta$ na equação de $alpha$, temos que
  $
    alpha = (EE[Y_n Y_(n+h)] - mu^2(1 - alpha)) / EE[Y_n^2]   \
    alpha EE[Y_n^2] = EE[Y_n Y_(n+h)] - mu^2 + alpha mu^2   \
    alpha (EE[Y_n^2] - mu^2) = EE[Y_n Y_(n+h)] - mu^2   \
    alpha VV[Y_n] = "Cov"(Y_n, Y_(n+h))   \
    alpha = rho_Y (h)
  $
  
  Voltando na equação de $beta$, temos que
  $
    beta = mu(1 - alpha) = mu(1 - rho_Y (h))
  $

  agora substituindo na equação do preditor linear, temos que
  $
    l(Y_n) &= alpha Y_n + beta   \
    &= rho_Y (h) Y_n + mu(1 - rho_Y (h))   \
    &= mu + rho_Y (h) (Y_n - mu)
  $

  Substituindo isso tudo que encontramos na fórmula do erro quadrático médio, vamos acabar chegando que
  $
    f(alpha, beta) = sigma^2 (1 - rho_Y (h)^2)
  $
]

== Métodos simples de previsão (baseline)
Um baseline estabelece o padrão mínimo. Se um modelo sofisticado perde para aa média ou para o último valor (previsores que vimos anteriormente), o sofisticado ainda não justificou sua complexidade. O baseline estabelece um *limite inferior* para o desempenho de modelos mais complexos.

#definition[
  $hat(Y)_(T+h|T)$ representa a previsão do valor futuro $Y_(T+h)$ dado os dados observados até o instante $T$.
]

=== Método da média
#figure(
  image("images/A1/mean.png"),
  caption: "Ilustração do método da média"
)

Prevemos todas as observações futuras pela média aritmética histórica da amostra:
$
  hat(Y)_(T+h|T) = overline(Y)_T = (1)/(T) sum_(t=1)^T Y_t wide forall h >= 1
$

o método da média assume que o processo é *fracamente estacionário*, sem tendência e sem sazonalidade
$
  Y_t = mu + epsilon_t, wide epsilon_t ~ "WN"(0, sigma^2)
$

Corresponde ao caso em que a autocorrelação $rho(h) approx 0$ para todo $h >= 1$ (série sem memória linear)

Conseguimos notar também que esse estimador é *não-viesado* e *consistente*, ou seja, a previsão converge para o valor real da série temporal à medida que o tamanho da amostra aumenta (pois a média amostral converge para a média populacional).

#theorem("Variância do Erro de Previsão")[
  $
    VV[epsilon_(T+h)] = sigma^2(1 + 1/T) wide forall h >= 1
  $
  Ou seja, a precisão converge para a variância do ruído branco à medida que o tamanho da amostra aumenta ($T -> infinity$)
]
#proof[
  $
    VV[Y_(T+h) - overline(Y)_T] &= VV[epsilon_(T+h)]   \
    
    &= VV[Y_(T+h)] + VV[overline(Y)_T] - 2 "Cov"(Y_(T+h), overline(Y)_T)   \
    &= sigma^2 + sigma^2/T    \
    &= sigma^2(1 + 1/T)
  $
  Aqui a covariância entre $Y_(T+h)$ e $overline(Y)_T$ é nula, pois o ruído branco não possui memória linear, logo não há correlação entre o valor futuro e a média amostral (além de que o valor futuro está fora dos valores utilizados para a estimação da média amostral, pois $h>=1$)
]

=== Método ingênuo (Passeio aleatório sem tendência)
#figure(
  image("images/A1/naive.png"),
  caption: "Ilustração do método ingênuo"
)

A previsão para qualquer horizonte futuro é o *último valor observado* da série
$
  hat(Y)_(T+h|T) = Y_T wide forall h >= 1
$

ele assume que o processo segue um *Passeio Aleatório* puro (não-estacionário na variância)
$
  Y_t = Y_(t-1) + epsilon_t, wide epsilon_t ~ "IID"(0, sigma^2)
$

É o caso limite em que a autocorrelação de curto prazo é extremamente alta ($rho(h) approx 1$ para $h$ pequeno). O estado atual $Y_T$ é a melhor estimativa para a posição futura

O erro de previsão acaba por ser a soma dos ruídos futuros acumulados
$
  Y_(T+h) - hat(Y)_(T+h|T) = Y_(T+h) - Y_T = epsilon_(T+1) + ... + epsilon_(T+h)
$

É fácil ver que o estimador é não-viesado (basta tirar a esperança do erro de previsão). E podemos mostrar que a variância da previsão aumenta linearmente com o horizonte de previsão, pois a variância do erro de previsão é a soma das variâncias dos ruídos futuros

#theorem("Variância do Erro de Previsão")[
  $
    VV[Y_(T+h) - hat(Y)_(T+h|T)] = h sigma^2 wide forall h >= 1
  $
  Ou seja, a precisão da previsão diminui linearmente com o horizonte de previsão, pois a variância do erro de previsão aumenta linearmente com o horizonte de previsão
]
#proof[
  $
    VV[Y_(T+h) - hat(Y)_(T+h|T)] &= VV[epsilon_(T+1) + ... + epsilon_(T+h)]   \
    &= VV[epsilon_(T+1)] + ... + VV[epsilon_(T+h)]   \
    &= h sigma^2
  $
]

=== Método ingênuo sazonal
#figure(
  image("images/A1/seasonal_naive.png"),
  caption: "Ilustração do método ingênuo sazonal"
)

Para séries com sazonalidade de período $m$ (ex: $m = 12$ para dados mensais, $m = 4$ para dados trimestrais), a previsão copia o valor observado na mesma fase do ciclo sazonal anterior
$
  hat(Y)_(T+h|T) = Y_(T+h-m(K+1)) wide forall h >= 1 wide K = floor((h-1)/m)
$

Esse método assume um modelo de *Passeio Aleatório Sazonal* sem tendência:
$
  Y_t = Y_(t-m) + epsilon_t, wide epsilon_t ~ "IID"(0, sigma^2)
$

Já aqui, conseguimos mostrar que a incerteza cresce não com $h$, mas a *cada ciclo sazonal completo*
$
  VV[epsilon_(T+h)] = (K+1) sigma^2
$

#theorem("Variância do Erro de Previsão")[
  $
    VV[Y_(T+h) - hat(Y)_(T+h|T)] = (K+1) sigma^2 wide forall h >= 1 wide K = floor((h-1)/m)
  $
  Ou seja, a precisão da previsão diminui a cada ciclo sazonal completo, pois a variância do erro de previsão aumenta a cada ciclo sazonal completo
]
#proof[
  $
    VV[Y_(T+h) - hat(Y)_(T+h|T)] &= VV[epsilon_(T+h-m(K+1)) + ... + epsilon_(T+h)]   \
    &= VV[epsilon_(T+h-m(K+1))] + ... + VV[epsilon_(T+h)]   \
    &= (K+1) sigma^2
  $
]

=== Método do desvio (drift)
#figure(
  image("images/A1/drift.png"),
  caption: "Ilustração do método do desvio"
)

Extrapola uma tendência linear permitindo que a previsão mude ao longo do tempo a uma taxa constante $C$
$
  hat(Y)_(T+h|T) = Y_T + h C wide forall h >= 1
$

onde a taxa de variação (inclinação do desvio) é estimada pela variação média por período entre a primeira e a última observação da amostra
$
  C = (Y_T - Y_1) / (T - 1)
$

na intuição geométrica, estamos traçando uma linha reta entre o primeiro e o último ponto da série temporal, e projetando essa linha para frente. Esse método assume um modelo de *Passeio Aleatório com Drift (Tendência)*:
$
  Y_t = C + Y_(t-1) + epsilon_t, wide epsilon_t ~ "WN"(0, sigma^2)
$

== Valores Ajustados V.S Previsões
É importante notar que os métodos de previsão que vimos até agora são *modelos de previsão*, e não *modelos de ajuste*. Ou seja, eles não são modelos que descrevem a série temporal, mas sim modelos que descrevem como prever o futuro da série temporal. 

Para um modelo de séries temporais ajustado sobre um conjunto de dados históricos $cal(F)_T = {Y_1,...,Y_T}$ temos as seguintes definições

#definition("Valores ajustados")[
  O valor ajustado $hat(Y)_(t|t-1)$ é a estimativa *dentro da amostra* de um passo à frente ($h=1$) para instantes passados $t = 2, 3, ..., T$. Representa o valor que o modelo teria previsto para o instante $t$ conhecendo as observações anteriores $Y_1, Y_2, ..., Y_(t-1)$ e com parâmetros globais *já calibrados na amostra completa*
]

#definition("Previsão (Forecast)")[
  A previsão $hat(Y)_(T+h|T)$ são as projeções *fora da amostra* de $h$ passos à frente ($h>=1$) para instantes futuros $t = T+1, T+2, ...$. Utilizam estritamente a informação disponível até o instante de corte $T$, sem qualquer acesso visual ou numérico às realizações reais de $Y_(T+h)$
]


#pagebreak()

#align(center + horizon)[
  = Diagnóstico de Resíduos
]

#pagebreak()

== Introdução

No capítulo passado visualizamos formas de previsão utilizando da relação linear que as covariáveis possuem entre si ($rho(h)$). Nesse capítulo, vamos entender que tipo de informações conseguimos retirar a partir dos *resíduos* das previsões

#definition("Resíduo")[
  Um resíduo $e_t$ é a diferença entre o valor observado $Y_t$ e o valor previsto $hat(Y)_t$
  $
    e_t = Y_t - hat(Y)_t
  $
]

ele representa justamente aquilo que o modelo não absorveu, ou seja, a parte da série temporal que não foi explicada pelo modelo. Se o modelo for bom, os resíduos devem se comportar como *ruído branco*, ou seja, não devem apresentar autocorrelação significativa, ou seja, eles devem apresentar $EE[e_t] = 0$ e $"Cov"(e_t, e_(t+h)) = 0$, garantindo que não houve memória não explorada.

Algumas outras características, não obrigatórias, mas desejáveis, são variância constante $VV[e_t] = sigma^2$ e distribuição *aproximadamente* normal, essencial para o ajuste de intervalos de confiança e testes de hipóteses.

Nós vamos ver alguns testes de hipótese que trabalham em cima dos resíduos e testam justamente as propriedades que citamos, mas, mesmo que nós já tenhamos visto isso em matérias anteriores, vale ressaltar que o teste *passar*, não significa que o modelo é bom, mas sim que *não há evidência suficiente* para rejeitar a hipótese nula de que os resíduos são ruído branco. Já se o teste *falha*, significa que o modelo é *inadequado* e que há memória não explorada na série temporal, ou seja, há espaço para sua melhoria.

== Testes de Autocorrelação conjunta
Antes de iniciarmos, os dois testes apresentados serão os _testes portmanteau_, que têm o mesmo objetivo, avaliar a autocorrelação conjunta dos resíduos até um lag limite $l$
$
  H_0: rho_e (1) = rho_e (2) = ... = rho_e (l) = 0    \
  H_1: exists h in {1,...,l} "tal que" rho_e (h) != 0
$
ou seja, atuam sobre a hipótese nula que *não existe* autocorrelação significativa nos resíduos até o lag $l$. Antes de partirmos para os testes, vale também ressaltar a definição:
$
  r_k = hat(rho)_e (k) = (sum_(t=k+1)^T (e_t - overline(e))(e_(t-k) - overline(e))) / (sum_(t=1)^T (e_t - overline(e))^2) wide forall k in {1,...,l}
$

Os testes vão se basear no @acf-amostral-dist que nos garante que, sob a hipótese nula de IID, temos que
$
  sqrt(T) r_k ->^d cal(N)(0,1) wide forall k in {1,...,l}
$

=== Teste de Box-Pierce
Dado o @acf-amostral-dist, então podemos enunciar o seguinte teorema

#theorem("Normalidade Conjunta")[
  Se ${Y_t} ~ "IID"(0, sigma^2)$ com $EE[Y_t^4]<infinity$, então para qualquer $h>0$ fixo, quando $T->infinity$ e para um $l$ fixo:
  $
    sqrt(T) mat(r_1,...,r_l)^T ->^d cal(N)(0, I_l)
  $
]

Sabendo que cada um dos lags $r_k$ converge para uma distribuição normal padrão, podemos construir a estatística de teste de Box-Pierce como
$
  Q = T sum_(k=1)^l r_k^2
$
dessa forma, sob a hipótese nula, temos que
$
  Q ->^d chi^2_l
$

No entanto esse teste possui uma limitação em amostras finitas, pois sob $H_0$, é possível mostrar que a variância de $r_k^2$ para um lag $k$ é
$
  EE[T r_k^2] approx (T - k) / (T + 2) < 1
$

como a estatística de teste $Q$ trata $EE[T r_k^2] = 1$, então $Q$ torna-se sistematicamente *superestimado* em amostras finitas, o que leva a rejeitar a hipótese nula de ruído branco mesmo quando ela é verdadeira (muito conservador). Para contornar esse problema, foi proposto o teste de Ljung-Box

=== Teste de Ljung-Box
Aplica um fator de reescalonamento que pondera cada lag pelo inverso de sua variância exata sob a hipótese nula, assim, a estatística de teste de Ljung-Box é definida como
$
  Q^* = T (T + 2) sum_(k=1)^l (r_k^2 / (T - k))
$
assim, a distribuição empírica de $Q^*$ aproxima-se com maior precisão da distribuição teórica Qui-Quadrado em amostras finitas, sendo o teste preferido na prática

=== Distribuição Assintótica e Regra de Decisão Formal
Sob a hipótese nula $H_0$, ambas as estatísticas seguem assintoticamente uma distribuição Qui-Quadrado:
$
  Q ->^a Chi^2(d) wide Q^* ->^a Chi^2(d)
$

onde $d = l - K$ representa os graus de liberdade, $l$ o número de lags testados. Há uma regra prática de fixar $l = 10$ para dados não-sazonais e $l = 2m$ para dados sazonais. A escolha de $l$ deve ser fixada antes do cálculo do $p$-valor. $K$ é o número de parâmetros estimados no modelo que gerou os resíduos5 (para as baselines simples sem calibração por otimização, $K = 0 => d = l$)

Fixando o nível de significância $alpha$, queremos rejeitar $H_0$ quando a estatística de teste $Q$ ou $Q^*$ forem maiores que um $c_(1-alpha)$, ou seja
$
  PP(Q > c_(1-alpha)) = alpha
$

dado que, sob a hipótese nula, $Q$ e $Q^*$ seguem uma distribuição Qui-Quadrado com $d$ graus de liberdade, então o limite crítico $c_(1-alpha)$ é dado pelo quantil $(1-alpha)$ da distribuição Qui-Quadrado, logo
$
  c_(1-alpha) = chi^2_d (1-alpha)
$
e o p-valor
$
  p = PP(Chi^2_d > Q|H_0 "verdade") = 1 - F_(Chi^2_d)(Q)
$

#figure(
  image("images/A1/box_pierce.png", width: 85%),
  caption: "Ilustração do teste de Box-Pierce"
)

=== Intervalos de Precisão
Sob a premissa de que os erros seguem distribuição Normal $e_t ~ cal(N)(0, sigma^2)$ e são não-correlacionados, o intervalo de previsão com $95$% de confiança para o horizonte $h$ é
$
  hat(Y)_(T+h|T) plus.minus 1.96 sqrt(VV[Y_(T+h) - hat(Y)_(T+h|T)]) = hat(Y)_(T+h|T) plus.minus 1.96 sqrt(h sigma^2)
$
onde o desvio padrão do erro de previsão é estimado como
$
  hat(sigma) = sqrt(1/(T - K - M) sum_(t=1)^T hat(e)_t^2)
$

A acumulação do desvio padrão futuro $hat(sigma)_h$ varia conforme a estrutura de cada baseline

- *Naive*: $hat(sigma)_h = sqrt(h) dot hat(sigma)$
  #figure(
    image("images/A1/naive-std.png", width: 85%),
    caption: "Ilustração do método ingênuo"
  )

- *Mean*: $hat(sigma)_h = hat(sigma) sqrt(1 + 1/T)$
  #figure(
    image("images/A1/mean-std.png", width: 85%),
    caption: "Ilustração do método da média"
  )

- *Naive Sazonal*: $hat(sigma)_h = sqrt(K+1) dot hat(sigma)$ com $K = floor((h-1)/m)$
  #figure(
    image("images/A1/seasonal-naive-std.png", width: 85%),
    caption: "Ilustração do método ingênuo sazonal"
  )

- *Drift*: $hat(sigma)_h = hat(sigma) dot sqrt((h (h+1))/(T-1))$
  #figure(
    image("images/A1/drift-std.png", width: 85%),
    caption: "Ilustração do método do desvio"
  )

== Intervalo de Previsão por Bootstrap
Quando a distribuição dos resíduos apresenta assimetria ou caudas pesadas, a premissa de normalidade falha, gerando intervalos paramétricos mal calibrados

Algoritmo de Construção das Trajetórias Simuladas:

+ Extrair os resíduos observados de 1 passo ${ hat(e)_1, ..., hat(e)_T }$.
+ Para o horizonte $h = 1$, sortear com reposição um resíduo $e_(T+1)^* in (hat(e)_t )$ e calcular $Y_(T+1)^* = hat(Y)_(T+1 | T) + e_(T+1)^*$.
+ Para os passos subsequentes $h = 2, 3, ...$, sortear com reposição um novo resíduo $e_(T+h)^*$ e atualizar recursivamente $Y_(T+h)^* = hat(Y)_(T+h | T+h-1)^* + e_(T+h)^*$.
+ Repetir esse processo $B$ vezes (gerando $B$ trajetórias futuras) e extrair os quantis empíricos de $2,5$% e $97,5$% para formar o intervalo a $95$% de confiança.

O bootstrap não conserta um modelo com erros autocorrelacionados. Se a ACF dos resíduos indicar memória, a reamostragem i.i.d. mistura choques dependentes como se fossem independentes, destruindo a cobertura nominal do intervalo. O bootstrap relaxa a hipótese de normalidade, mas exige rigorosamente a ausência de autocorrelação.

#figure(
  image("images/A1/bootstrap.png", width: 100%),
  caption: "Ilustração do método de bootstrap"
)


#pagebreak()

#align(center + horizon)[
  = Métricas de Avaliação
]

#pagebreak()

== Erro de previsão V.S Resíduos
Antes de aprendermos sobre métricas de avaliação, é importante destacarmos a diferença entre *erro de previsão* e *resíduo*, a diferença é sutil e se encontra no fato da amostra *estar* ou *não estar* no conjunto de treino (ajuste do modelo)

- *Resíduo* $e_t = y_t - hat(y)_(t|t-1) space forall t in {1,...,T}$: Mede a discrepância entre a observação real e o valor ajustado dentro da *amostra utilizada para calibrar o modelo*

- *Erro de previsão* $e_(T+h) = y_(T+h) - hat(y)_(T+h|T) space forall h >= 1$: Mede a discrepância entre a observação real e o valor previsto *fora da amostra utilizada para calibrar o modelo*

== Métricas de Avaliação Pontual
Para as próximas definições, defina $H$ como o número de pontos *do conjunto de testes* que você reservou para a análise.

=== Métricas de Escala
Fornecem medidas de erro expressa na mesma escala dos dados (ex: R\$, litros, galões etc.), tornando a interpretação direta.

#definition("Erro Absoluto Médio (MAE)")[
  $
    "MAE" = (1)/(H) sum_(h=1)^H |e_(T+h)|
  $
]

O interessante dessa métrica é que o erro é tratado de forma proporcional, então errar $10$ unidades machuca no bolso exatamente $10$ vezes mais que errar $1$ unidade. Utilizamos esse erro quando o custo operacional/financeiro cresce proporcionalmente ao erro cometido. Já vimos em teoremas de outras disciplinas que o MAE é minimizado pela *mediana* da distribuição de erros, ou seja, o preditor que minimiza o MAE é $"MED"(Y_(T+h|Y_T))$

#definition("Root Mean Squared Error")[
  $
    "RMSE" = sqrt(1/H sum_(h=1)^H e_(T+h)^2)
  $
]

O erro RMSE penaliza erros grandes de forma mais severa, pois o erro é elevado ao quadrado. Utilizamos esse erro quando o custo operacional/financeiro de uma falha pequena é relevante, mas o custo de uma falha grande é inaceitável. Por exemplo, na previsão de demanda de energia elétrica, um erro de $10$MW não é $10$ vezes pior do que um de $1$MW — ele pode derrubar a rede elétrica e causar um apagão. O quadrado captura essa _"gravidade exponencial"_. Também vimos em disciplinas passadas que o preditor que minimiza esse erro é $EE[Y_(T+h|T)]$

Por mais interessantes que essas métricas seja, existe um claro problema com elas, eles *não* podem ser usados para comparar erros de séries temporais com *escalas ou magnitudes diferentes*.

#example("Escalas iguais, magnitudes diferentes")[
  Vamos pensar em um varejo com dois produtos $A$ e $B$, onde o produto $A$ vende aproximadamente $10$ por dia, enquanto o $B$ vende $10000$ por dia. Se o modelo de previsão tem um $"MAE"$ de $10$ para ambos, enquanto no produto $B$ isso é irrelevante, já que é uma quantidade de produtos errados muito baixa comparado ao volume de vendas, para o produto $A$ isso é um *completo desastre*, pois o modelo errou a previsão de vendas em $100%$.
]

=== Erros Percentuais
Essas são as métricas que são *livres de escala*, permitindo comparação entre séries temporais com magnitudes diferentes e permitem fácil comunicação com stakeholders

#definition("Mean Absolute Percentage Error")[
  $
    P_j = 100 dot e_j / y_j   \

    "MAPE" = 1/H sum_(j=1)^H |P_j|
  $
]

Por mais útil que esse erro seja, ainda existem alguns pontos para se ficar atento. Se $y_j = 0$ o $"MAPE"$ é indefinido, e se $y_j$ é muito pequeno, o $"MAPE"$ pode *explodir*. Além disso, o $"MAPE"$ é *assimétrico*, ou seja, ele penaliza mais previsões que *subestimam* a demanda do que previsões que *superestimam* a demanda

#example([Assimetria do $"MAPE"$])[
  Suponha que $y=1$ e $hat(y)=2$, então o erro percentual é $|P| = |100 dot (1 - 2)/1| = 100%$, agora basta inverter e assumir $y=2$ e $hat(y)=1$ e teremos $|P| = |100 dot (2 - 1)/2| = 50%$
]

=== Erros Escalados
A ideia desse erro é calcular o $"MAE"$ do seu modelo e dividir esse erro pelo erro de um modelo *ingênuo* (baseline)

#definition("Mean Absolute Scaled Error")[
  Em séries não-sazonais
  $
    q_j = e_j / (1/(T-1) sum^T_(t=2)|y_t - y_(t-m)|)
  $
  em séries sazonais
  $
    q_j = e_j / (1/(T-m) sum^T_(t=m+1)|y_t - y_(t-m)|)
  $
  e o $"MASE"$ é dado por
  $
    "MASE" = 1/H sum_(j=1)^H |q_j|
  $
]

Cada $q_j$ indica a quantos _"passos típicos de passeio aleatório"_ equivale o erro de teste.
- $"MASE" < 1$: Na janela de teste, o modelo foi superior ao Naive.

- $"MASE" = 1$: O modelo empatou com o Naive.

- $"MASE" > 1$: O modelo é pior que o Naive.

A escala é calculada no treino (ficando fixa antes do teste). Não sofre com zeros no teste, não é assimétrica e permite comparar métodos em coleções mistas de séries

== Métricas de Avaliação Distribucional
$"MAE"$ e $"RMSE"$ avaliam *um* número $hat(y)$. O intervalo $hat(y) plus.minus 1.96 hat(sigma)_h$ era um recorde de uma *distribuição preditiva* $F$ de $Y_(t+h)$ dado o passado. Agora nós gostaríamos de avaliar a *distribuição preditiva*.

=== Erro de Quantil
Avalia a precisão de um quantil $hat(q)_(t+h|T)$ da distribuição preditiva $F$ de $Y_(t+h)$ dado o passado.

#definition("Pinball Loss")[
  $
    Q_(p,t) (hat(q)_(p,t), y_t) = cases(
      2(1-p)(hat(q)_(p,t)-y_t) wide &y_t<hat(q)_(p,t),

      2 p (y_t - hat(q)_(p,t)) wide &y_t>=hat(q)_(p,t)
    )
  $
]<pinball-loss>

O valor de $y$ que minimiza $EE[Q]$ é o *quantil verdadeiro* da distribuição

#theorem([Minimizador teórico de $Q$])[
  Seja $Y$ uma variável aleatória contínua com função de distribuição acumulada (cdf) $F_Y (y) = PP(Y<=y)$ estritamente crescente e função de densidade de probabilidade $f_Y (y) > 0$

  Para um quantil fixado $p in (0,1)$, seja a função de perca de quantil $Q_p (q,Y)$ definida em @pinball-loss, a esperança do risco associado
  $
    cal(L) = EE[Q_p (q,Y)]
  $
  atinge seu mínimo global estrito se e somente se o candidato $q$ for o $p$-quantil verdadeiro da distribuição de $Y$
  $
    q^* = F_Y^(-1) (p)
  $
]<pinball-loss-minimizer>
#proof[
  $
    cal(L)(q) = integral_(-infinity)^(infinity) Q_p (q,y) f_Y (y) dif y
  $
  Dividindo a integral no ponto de corte $q$
  $
    cal(L)(q) = integral_(-infinity)^q 2 (1-p) (q - y) f_Y (y) dif y + integral_(q)^infinity 2 p (y - q) f_Y (y) dif y
  $
  $
    cal(L)(q) = underbrace(2 (1-p) integral_(-infinity)^q (q - y) f_Y (y) dif y, "f") + underbrace(2 p integral_(q)^infinity (y - q) f_Y (y) dif y, "g")
  $
  Aplicando a regra de leibniz para derivadas de integrais, temos que
  $
    dif / (dif q) cal(L)(q) = dif f / (dif q) + dif g / (dif q)
  $
  $
    (dif f) / (dif q) = 2 (1-p)[
      (q-q) f_Y (q) + integral_(-infinity)^q partial / (partial q) (q - y) f_Y (y) dif y
    ] = 2 (1-p) F_Y (q)
  $
  $
    (dif g) / (dif q) = 2 p[
      -(q-q) f_Y (q) + integral_(q)^infinity partial / (partial q) (y - q) f_Y (y) dif y
    ] = -2 p (1 - F_Y (q))
  $
  Logo, para achar o ponto de mínimo:
  $
    0 = 2 (1-p) F_Y (q) - 2 p (1 - F_Y (q))   \

    0 = (1-p) F_Y (q) - p + p F_Y (q)   \

    p = (1 - p + p) F_Y (q)   \

    F_Y (q) = p   \

    q^* = F_Y^(-1) (p)
  $
  A existência de $F_Y^(-1) (p)$ é garantida pois $F_Y$ é estritamente crescente. Derivando novamente em relação a $q$
  $
    (dif^2 cal(L))/(dif q^2) = (dif)/(dif q)[2(F_Y (q) - p)] = 2 f_Y (q)
  $
  como $f_Y (q) > 0$ no suporte de $Y$, temos que a segunda derivada é estritamente positiva, garantindo que $q^* = F_Y^(-1) (p)$ seja o *único mínimo global estrito*
]

#figure(
  image("images/A1/pinball-error-in-function-of-quantile.png"),
  caption: "Gráfico de comparação entre a média do pinball error com relação ao valor cadidato do quantil"
)

=== Score de Winkler
Avalia a precisão de um intervalo de previsão $hat(I) = [l_(alpha,t), u_(alpha,t)]$ de nível de confiança $1-alpha$ para a distribuição preditiva $F$ de $Y$

#definition("Score de Winkler")[
  $
    W_(alpha) (l, u, y_t) = cases(
      (u-l) + 2/alpha (l - y_t) wide &y_t < l,
      u-l wide &l<=y_t<=u,
      (u-l) + 2/alpha (y_t - u) wide &y_t>u
    )
  $
  onde $l$ e $u$ são os limites inferior e superior do intervalo de previsão, respectivamente, e $y_t$ é o valor observado.
]

Existe uma conexão entre o score de Winkler e a Pinball Loss

#theorem("Decomposição do Score de Winkler")[
  O score de winkler se decompõe como a soma escalada das Pinball Losses nos quantis $p_1 = alpha/2$ e $p_2 = 1-alpha/2$
  $
    W_alpha (l,u,y_t) = 1/alpha [Q_(alpha/2) (l,y) + Q_(1-alpha/2) (u,y)]
  $
]<winkler-score-decomposition>


#theorem("Mínimo global do Score de Winkler")[
  A esperança do Score de Winkler $EE[W_alpha (l, u, y_t)]$ atinge seu mínimo global estrito se, e somente se, os limites $l^*$ e $u^*$ forem os quantis teóricos verdadeiros de $y$
  $
    l^* &= F_Y^(-1) (alpha/2)   \
    u^* &= F_Y^(-1) (1-alpha/2)
  $
]
#proof[
  Aplicando a linearidade da esperança e utilizando do @winkler-score-decomposition, temos que
  $
    EE[W_alpha (l, u, y_t)] = 1/alpha [EE[Q_(alpha/2) (l,y)] + EE[Q_(1-alpha/2) (u,y)]]
  $
  como o limite inferior $l$ aparece apenas no primeiro termo e o limite superior $u$ no segundo, então a minimização conjunta de $EE[W_alpha (l, u, y_t)]$ se divide em duas otimizações diferentes
  $
    min_l EE[Q_(alpha/2)(l, y_t)] wide min_l EE[Q_(1- alpha/2)(u, y_t)]
  $
  Pelo @pinball-loss-minimizer, sabemos que o mínimo global de cada termo é atingido quando $l$ e $u$ são os quantis verdadeiros da distribuição de $y$, ou seja
  $
    l^* &= F_Y^(-1) (alpha/2)   \
    u^* &= F_Y^(-1) (1-alpha/2)
  $
]

A lógica desse score ´ que, se o valor observado $y_t$ estiver dentro do intervalo de previsão, o score é apenas o tamanho do intervalo, de forma que intervalos mais curtos são preferíveis. Se o valor observado estiver fora do intervalo, o score penaliza a distância do valor observado para o limite mais próximo do intervalo, de forma que intervalos que *não cobrem* o valor observado são penalizados.

#figure(
  image("images/A1/winkler-score.png", width: 85%),
  caption: "Dois intervalos. Se o curto cobre o valor observado, ele é preferível. Se o curto não cobre, ele pode ser penalizado e o maior ganhar"
)

=== Continuous Ranked Probability Score
Avalia a CDF preditiva inteira $F(x)$ contra a função degrau empírica da realização real $II(x>=y_t)$

#definition("Continuous Ranked Probability Score")[
  $
    "CRPS"(F, y_t) = integral_(-infinity)^(infinity) (F(x) - II(x>=y_t))^2 dif x
  $
]

Ela mede a área entre a CDF prevista e o degrau unitário empírico em $y_t$ (quanto menor a área, melhor). Existem dois teoremas interessantes que conectam o CRPS com a métrica de avaliação da pinball

#theorem("Equivalência da CRPS")[
  Seja $Y$ uma variável contínua aleatória com CDF $F_Y$ estritamente crescente, o CRPS de $F_Y$ com relação a uma realização $y$ é equivalente à integral da Pinball Loss sobre todos os quantis, ou seja:
  $
    integral_(-infinity)^infinity (F_Y (x) - II(x>=y))^2 dif x = integral_0^1 Q_p (F_Y^(-1)(p), y) dif p
  $
]

Ou seja, enquanto o erro de quantil avalia apenas uma fatia $p$ e o wrinkler avalia um intervalo fixo $(alpha/2, 1-alpha/2)$, o CRPS avalia a perda de todos os quantis do espaço amostral continuamente

#theorem("Representação do CRPS por variáveis aleatórias latentes")[
  Sejam $X$ e $X'$ duas variáveis aleatórias independentes com a mesma distribuição $F$, então, o CRPS pode ser representado como
  $
    "CRPS"(F, y) = EE_F |X - y| - 1/2 EE_F |X - X'|
  $
]

Mas por que essa representação me é útil? Primeiro que ela é uma *decomposição*, onde $EE_F |X - y|$ é a acurácia/calibração, medindo o erro absoluto médio esperado entre as simulações do modelo e o valor real observado e $EE_F |X - X'|$ é a nitidez/dispersão, medindo a variabilidade/espalhamento interno da própria distribuição do modelo. Como entra com sinal negativo na perda, *recompensa distribuições mais concentradas (nítidas)* e pune incerteza desnecessária. Outro ponto positivo é que, em algoritmos de séries temporais que geram $M$ trajetórias simuladas no futuro via *Bootstrap* ${x^((1)), x^((2)), ..., x^((M))}$, não precisamos calcular nenhuma integral numérica da CDF $F(x)$. O CRPS empírico é calculado diretamente por somatório discreto:
$
  "CRPS" = 1/M sum_(m=1)^M |x^((m)) - y| - 1/(2 M^2) sum_(m=1)^M sum_(n=1)^M |x^((m)) - x^((n))|
$

#figure(
  image("images/A1/crps.png", width: 100%),
  caption: [Ilustração do CRPS. $F_1$ com média descolada e $F_2$ verdadeira]
)


#pagebreak()

#align(center + horizon)[
  = Transformações
]

#pagebreak()

Muitos modelos (e a ACF que já usamos) pedem algo próximo de *estacionariedade* fraca: média e variância estáveis no tempo, sem tendência óbvia. Só que isso óbviamente pode não ocorrer na vida real e para cada *falha* lidamos de uma forma diferente

- *Variância muda com o nível*: Transformação de potência
- *Nível muda com o tempo*: Diferenciação

*Primeiro estabiliza-se a variância (Box-Cox), depois aplica-se a diferenciação.* _Por quê?_ Diferenciar com o leque ainda aberto faz a série diferenciada misturar mudança de nível com mudança de escala ao mesmo tempo, destruindo o diagnóstico gráfico e da ACF

== Box-Cox

#definition("Transformação de Box-Cox")[
  Para séries estritamente positivas $y_t > 0$, a transformação de Box-Cox é definida como
  $
    w_t = cases(
      log(y_t) wide &lambda = 0,
      (y_t^lambda - 1)/lambda wide &lambda != 0
    )
  $
  onde $lambda$ é um híperparâmetro que controla a intensidade da transformação.
]

#figure(
  image("images/A1/box-cox.png", width: 100%),
  caption: "Ilustração da transformação de Box-Cox"
)

Perceba que na imagem original, a variância cresce conforme o tempo vai passando, já as transformações estabilizam essa variância. Em software, o correto é estimar o $lambda$ ótimo via *Maximum Likelihood* e aplicar a transformação, mas para fins didáticos, testamos apenas alguns valores de $lambda$ e ver qual estabiliza melhor a variância. O gráfico serve também para ver se o $lambda$ faz sentido.

Depois que modelamos o $w$, precisamos que a previsão volte para a escala de $y$, afinal, se eu quero prever *litros de água*, não posso entregar *logaritmo de litros de água*.

Para intervalos de confiança, aplicamos a inversa da transformação nos extremos do intervalo
$
  PP(w_1 <= W <= w_2) = 1-alpha => PP(g^(-1)(w_1) <= Y <= g^(-1)(w_2)) = 1-alpha
$
onde a inversa é definida como
$
  g^(-1)(w) = cases(
    exp(w) wide &lambda = 0,
    (lambda w + 1)^(1/lambda) wide &lambda != 0
  )
$

Porém, temos que tomar cuidado. Por conta da *desigualdade de Jensen*, eu *não posso* estimar a média de $W$ e aplicar $g^(-1)$ nela para tentar estimar a média de $Y$.

== Operador de Defasagem (Backshift)
Compacta a álgebra do atraso temporal
$
  B^k y_t = y_(t-k) wide k in ZZ
$
- Primeira diferença: $(1-B)y_t = y_t - y_(t-1)$
- Diferença de ordem $d$: $(1-B)^d y_t$
- Diferença sazonal de período $m$: $(1-B^m) y_t = y_t - y_(t-m)$

== Diferenciação
=== Diferenciação de Primeira Ordem
$
  y'_t = (1-B)y_t = y_t - y_(t-1)
$
Quando a média é aproximadamente linear, a diferenciação a estabiliza, removendo a tendência. Dois casos limites úteis:

- Se $y'_t = epsilon_t$ (ruído branco): $y_t$ é um Passeio Aleatório Puro ($y_t = y_(t-1) + epsilon_t$).

- Se $y'_t = c + epsilon_t$: $y_t$ é um Passeio Aleatório com Drift ($y_t = c + y_(t-1) + epsilon_t$, tendência estocástica com inclinação constante $c$)

=== Diferenciação de Segunda Ordem
$
  y''_t = (1-B)^2 y_t = (1-B)y'_t = y'_t - y'_(t-1) = y_t - 2y_(t-1) + y_(t-2)
$

Empregada quando a primeira diferença ainda apresenta tendência (tendência quadrática). Porém, devemos tomar cuidado ao diferenciar demais ($d >= 2$ injustificado) insere autocorrelação negativa artificial nos resíduos e destrói a informação do nível da série

Com tendência e sazonalidade juntas, a ordem usual é: sazonal primeiro, depois 1ª ordem se o nível ainda vagar:
$
  (1-B)(1-B^m)y_t = y_t - y_(t-1) - y_(t-m) + y_(t-m-1)
$


#pagebreak()

#align(center + horizon)[
  = Modelo AR e PACF
]

#pagebreak()

== Modelos Autoregressivos ($"AR"$)
Um $"AR"(p)$ descreve a variável objetivo $y_t$ como uma regressão linear nos próprios lags da série temporal
$
  y_t = C + phi_1 y_(t-1) + phi_2 y_(t-2) + ... + phi_p y_(t-p) + epsilon_t wide epsilon_t ~ "WN"(0, sigma^2)
$

Aqui, como os preditores são os próprios valores anteriores da série, a dependência temporal entra de forma explícita no modelo.

=== Caso especial $"AR"(1)$
$
  y_t = C + phi_1 y_(t-1) + epsilon_t wide epsilon_t ~ "WN"(0, sigma^2)
$
Este é o modelo mais simples de um processo autoregressivo, onde a variável objetivo depende apenas do seu valor anterior.

- $phi_1 = 0, C = 0$: $y_t = epsilon_t$ (Ruído Branco).
- $phi_1 = 1, C = 0$: $y_t = y_(t-1) + epsilon_t$ (Passeio Aleatório — não-estacionário, variância cresce linearmente com $t$).
- $phi_1 = 1, C != 0$: $y_t = C + y_(t-1) + epsilon_t$ (Passeio Aleatório com Deriva/Drift).
- $phi_1 < 0$: A série oscila em torno da média trocando de sinal a cada passo (um valor alto em $y_{t-1}$ empurra $y_t$ para baixo e vice-versa).
- Estacionariedade no $"AR"(1)$: Exige $|phi_1| < 1$. Se $|phi_1| > 1$, o processo é explosivo (os valores disparam sem limite).

#figure(
  image("images/A1/ar1-negative-phi.png", width: 100%),
  caption: [Exemplo de modelo $"AR"(1)$ com $phi_1 < 0$ mostrando oscilações em torno da média.]
)

#theorem([ACF teórica do $"AR"(1)$ estacionário])[
  Se $|phi_1| < 1$, a Função de Autocorrelação (ACF) teórica no lag $h >= 0$ para o modelo $"AR"(1)$ é dada por:
  $
    rho(h) = phi_1^h
  $
]

Ou seja, a função decai exponencialmente para zero à medida que $h -> infinity$. Se $phi_1 > 0$, o decaimento é monótono positivo. Se $phi_1 < 0$, o decaimento oscila alternando sinais.

=== Estacionariedade do $"AR"(p)$
Usando o operador de defasagem (Backshift $B$), escrevemos o $"AR"(p)$ como:
$
  (1 - phi_1 B - phi_2 B^2 - ... - phi_p B^p) y_t = C + epsilon_t <=> phi(B) y_t = C + epsilon_t
$
onde $phi(z) = 1 - phi_1 z - phi_2 z^2 - ... - phi_p z^p$ é o Polinômio Característico (ou de Defasagem) associado ao processo.

#definition("Polinômio Característico")[
  Dado um processo $"AR"(p)$, o polinômio característico $phi(z)$ é definido como
  $
    phi(z) = 1 - phi_1 z - phi_2 z^2 - ... - phi_p z^p
  $
]

#theorem([Condição de Estacionariedade do $"AR"(p)$])[
  O processo $"AR"(p)$ é (fracamente) estacionário se e somente se todas as $p$ raízes do polinômio característico $phi(z) = 0$ estiverem ESTRITAMENTE FORA do círculo unitário no plano complexo:
  $
    phi(z_j) = 0 => |z_j| > 1 wide forall j in {1, ..., p}
  $
]

#example([Revisitando $"AR"(1)$])[
  No caso de $p=1$, temos que o polinômio característico será
  $
    phi(z) = 1 - phi_1 z = 0    \

    => z = 1/phi_1
  $
  logo, para ser estacionaria fraca, será
  $
    |z| > 1/phi_1 <=> |phi_1| < z
  $
]

#example([O triângulo de estacionariedade do $"AR"(2)$])[
  No caso de $p=2$, temos o polinômio
  $
    phi(z) = 1 - phi_1 z - phi_2 z^2 = 0
  $
  exigir que as raízes estejam fora do círculo unitário reduz isso à um *triângulo de estacionariedade* no plano $(phi_1, phi_2)$, definido pelas seguintes condições:
  $
    cases(
      -1 < phi_2 < 1,
      phi_1 + phi_2 < 1,
      phi_2 - phi_1 < 1
    )
  $

  #figure(
    image("images/A1/ar2-stationarity-triangle.png", width: 60%),
    caption: "Triângulo de estacionariedade do modelo AR(2)"
  )
]

== Função de Autocorrelação Parcial (PACF)
A ACF no lag $h$ mede a correlação entre $y_t$ e $y_(t-h)$, contudo, essa correlação pode ser contaminada por *caminhos indiretos* entre os lags intermediários. Se $y_t$ correlaciona fortemente com $y_(t-1)$ e $y_(t-1)$ com $y_(t-2)$, a ACF mostrará uma correlação espúria em $h = 2$, mesmo que não exista nenhuma ligação direta entre $y_t$ e $y_(t-2)$.

#definition("Função de Autocorrelação Parcial")[
  A Autocorrelação Parcial no lag $k$, denotada por $alpha_k$ ou $phi_(k k)$, é a correlação entre $y_t$ e $y_(t-k)$ após remover o efeito linear de todos os lags intermediários $y_(t-1), y_(t-2), ..., y_(t-k+1)$ (residualização). Matematicamente, $phi_(k k)$ é o último coeficiente da regressão autorregressiva de ordem $k$:
  $
    y_t = phi_(k 1) y_(t-1) + phi_(k 2) y_(t-2) + ... + phi_(k k) y_(t-k) + e_t
  $
]

#figure(
  image("images/A1/pacf.png", width: 100%),
  caption: "Ilustração da PACF"
)

Nesse exemplo, a primeira imagem mostra a série temporal modelada com $"AR"(1)$ e $phi = 0.8$. A segunda imagem mostra a ACF, que vai decaindo aos poucos, mostrando que quanto mais distante, menos memória vai permanecendo. Já na PACF, a memória decai no instante $p=1$, justamente por conta que o modelo depende exclusivamente do valor anterior.

#theorem([Corte abrupto da PACF no modelo $"AR"(p)$])[
  Se $y_t$ segue um processo $"AR"(p)$ verdadeiro, então a PACF satisfaz
  $
    phi_(k k) = cases(
      C > 0 wide &k<=p,
      0 wide &k>p
    )
  $
]


#pagebreak()

#align(center + horizon)[
  = Modelos MA e Invertibilidade
]

#pagebreak()

== Modelo de Média Móvel ($"MA"$)
Ao contrário do $"AR"(p)$, que usa valores passados de $y$, o modelo $"MA"(q)$ escreve $y_t$ como uma combinação linear dos erros passados $epsilon_t$

#definition("Média Móvel")[
  Ao modelarmos $y_t = "MA"(q)$, dizemos que:
  $
    y_t = C + epsilon_t + theta_1 epsilon_(t-1) + ... + theta_q epsilon_(t-q) wide epsilon_t ~ "WN"(0, sigma^2)
  $
]

a propriedade fundamental desse modelo é que ele possui *memória finita*, onde após $q$ períodos, o erro $epsilon_t$ não exerce mais influência

#theorem([Memória do $"MA"(q)$])[
  A Função de Autocorrelação (ACF) teórica de um modelo $"MA"(q)$ corta exatamente após o lag $q$:
  $
    rho(h) = 0 wide forall h > q
  $
]

== $"AR"(1)$ como $"MA"(infinity)$
Todo processo $"AR"(p)$ estacionário pode ser reescrito como um processo $"MA"(infinity)$ de choques passados acumulados:

#theorem()[
  Se $|phi_1| < 1$, o modelo $y_t = phi_1 y_(t-1) + epsilon_t$ admite a representação:
  $
    y_t = sum_(j=0)^(infinity) phi_1^j epsilon_(t-j)
  $
]
#proof[
  Substituindo a equação de $y_(t-1)$ recursivamente em $y_t$:
  $
    y_t = phi_1(phi_1 y_(t-2) + epsilon_(t-1)) + epsilon_t = epsilon_t + phi_1 epsilon_(t-1) + phi_1^2 y_(t-2)
  $
  Após $N$ substituições:
  $
    y_t = sum_(j=0)^(N) phi_1^j epsilon_(t-j) + phi_1^(N+1) y_(t-N-1)
  $
  Tomando o limite $N -> infinity$, como $|phi_1| < 1$, o termo de memória inicial $phi_1^(N+1) y_(t-N-1) -> 0$, resultando em $y_t = sum_(j=0)^(infinity) phi_1^j epsilon_(t-j)$
]

== Invertibilidade e Representação $"AR"(infinity)$ de um $"MA"(q)$

Podemos fazer o caminho inverso: expressar o erro $epsilon_t$ em função dos valores observados passados de $y$.

Para o $"MA"(1)$: $y_t = (1 + theta_1 B)epsilon_t => epsilon_t = (1 + theta_1 B)^(-1) y_t$.

Aplicando a expansão em série de Neumann $(1 + x)^(-1) = sum_(j=0)^infinity (-x)^j$:
$
  epsilon_t = sum_(j=0)^infinity (-theta_1)^j B^j y_t = y_t - theta_1 y_(t-1) + theta_1^2 y_(t-2) - theta_1^3 y_(t-3) + ...
$

Isolando $y_t$ para obter a representação $"AR"(infinity)$:
$
  y_t = sum_(j=1)^infinity -(-theta_1)^j y_(t-j) + epsilon_t
$

#theorem("Invertibilidade")[
  Para que os pesos da recuperação do erro $(-theta_1)^j$ decaiam para zero à medida que nos afastamos no passado (garantindo que observações recentes pesem mais do que o passado remoto), exige-se a condição de Invertibilidade:
  $
    "se" z_j "tal que" theta(z_j) = 0 and theta(z) = 1+theta_1 z + dots + theta_q z^q => |z_j| > 1
  $
]

== Armadilha Matemática da Não-Identificabilidade do $"MA"(1)$ não invertível

#theorem[
  Os modelos $"MA"(1)$ com parâmetro $theta_1 = theta$ e com parâmetro $theta_1 = 1/theta$ geram exatamente a mesma Função de Autocorrelação (ACF).
]
#proof[
  Seja $rho_theta (1)$ a ACF no lag $1$ do modelo com parâmetro $theta$:
  $
    rho_theta (1) = theta/(1 + theta^2)
  $
  Substituindo $theta$ por $tilde(theta) = 1/theta$:
  $
   rho_(tilde(theta)) (1) = (1/theta) / (1 + (1/theta)^2) = (1/theta)/((theta^2 + 1)/(theta^2)) = 1/theta dot theta^2/(theta^2 + 1) = (theta)/(1 + theta^2) = rho_theta (1)
  $
]

Mas por que isso seria um problema? A amostra de dados não consegue distinguir um $"MA"(1)$ com $theta=0.5$ de um com $theta=2$ pois ambos geram a mesma ACF. Se o modelo tivesse $theta = 2$ (não-invertível), a recuperação do erro usaria pesos $(-2)^j$ que explodem no passado remoto. Para garantir identificabilidade única e uma expansão $"AR"(infinity)$ estável, todos os algoritmos de estimação impõem estritamente a restrição de invertibilidade $|theta| < 1$

== PACF e ACF do $"MA"(q)$

#theorem([Corte abrupto da ACF do $"MA"(q)$])[
  Seja $Y_t$ um processo de Média Móvel de ordem $q$, $"MA"(q)$, definido por:
  $
    Y_t = C + epsilon_t + theta_1 epsilon_(t-1) + theta_2 epsilon_(t-2) + ... + theta_q epsilon_(t-q), wide epsilon_t ~ "WN"(0, sigma^2)
  $
  onde $theta_q != 0$. A Função de Autocorrelação (ACF) teórica $rho(h)$ apresenta um corte abrupto exatamente após o lag $q$:
  $
    rho(h) = cases(
      1 wide & h = 0,
      (sum_(j=0)^(q-|h|) theta_j theta_(j+|h|))/(sum_{j=0}^(q) theta_j^2) wide & 1 <= |h| <= q "assumindo" theta_0 = 1,
      0 wide & |h| > q
    )
  $
]

Aqui vemos a relação inversa com PACF e ACF que o $"MA"(q)$ possui em relação ao "AR(p)". Enquanto o $"AR"(p)$ possui corte abrupto na PACF e decaimento exponencial na ACF, o $"MA"(q)$ possui corte abrupto na ACF e decaimento exponencial na PACF.

#pagebreak()

#align(center+horizon)[
  = Modelo ARIMA
]

#pagebreak()

O modelo $"ARIMA"(p,d,q)$ unifica tudo que vimos de modelagem de séries temprais até o momento

+ $"I"(d)$ (Integração/Diferenciação): Remove a *tendência estocástica* e ajusta o nível da série original $y_t$ através de $d$ diferenças para torná-la estacionária: $y^*_t = (1-B)^d y_t$
+ $"AR"(p)$ (Autoregressivo): Modela a dependência temporal (*memória*) da série diferenciada $y^*_t$ através de $p$ lags passados: $y^*_t = phi_1 y^*_(t-1) + ... + phi_p y^*_(t-p) + epsilon_t$
+ $"MA"(q)$ (Média Móvel): Modela a dependência temporal nos erros passados $epsilon_t$ através de $q$ lags passados: $y^*_t = epsilon_t + theta_1 epsilon_(t-1) + ... + theta_q epsilon_(t-q)$

== Formulação Geral
Aplicando $d$ diferenças na série original $y_t$, temos a série diferenciada $y^*_t = (1-B)^d y_t$, então $y^*_t$ segue um modelo $"ARMA"(p,q)$:
$
  y^*_t = C + phi_1 y^*_(t-1) + ... + phi_p y^*_(t-p) + epsilon_t + theta_1 epsilon_(t-1) + ... + theta_q epsilon_(t-q) wide epsilon_t ~ "WN"(0, sigma^2)
$

Lembrando que $B^k y_t = y_(t-k)$, conseguimos simplificar a equação acima usando o operador de defasagem $B$:
$
  y^*_t = C + (phi_1 B + phi_2 B^2 + ... + phi_p B^p) y^*_t + (1 + theta_1 B + theta_2 B^2 + ... + theta_q B^q) epsilon_t
$
colocando os $y^*_t$ em evidência e usando a definição $y^*_t = (1-B)^d y_t$, conseguimos o modelo simplificado do $"ARIMA"(p,d,q)$:
$
  underbrace((1 - phi_1 B - phi_2 B^2 - ... - phi_p B^p), "AR") underbrace((1-B)^d y_t, "I") = C + underbrace((1 + theta_1 B + theta_2 B^2 + ... + theta_q B^q) epsilon_t, "MA")
$

== $C$ e $d$ em Previsões de Longo Prazo
O $C$ e $d$ tem um papel conjunto muito importante na previsão de longo prazo da série

=== $C=0$ e $d=0$
Previsão de longo prazo converge para a média da série original $y_t$.
$
  lim_(h->infinity) hat(Y)_(T+h|T) = mu = C/(1 - sum_(i=1)^p phi_i)
$

#figure(
  image("images/A1/arima-c0-d0.png", width: 100%),
  caption: "Previsão de longo prazo converge para a média da série"
)

=== $C=0$ e $d=1$
A previsão congela no último valor observado da série original $y_t$.
$
  lim_(h->infinity) hat(Y)_(T+h|T) = y_T
$

#figure(
  image("images/A1/arima-c0-d1.png", width: 100%),
  caption: "Previsão de longo prazo congela no último valor observado da série"
)

=== $C!=0$ e $d=1$
A constante $C$ se torna-se a *inclinação* de uma *tendêncial linear determinística* no nível original de $y$
$
  hat(Y)_(T+h|T) approx hat(Y)_(T|T) + h dot mu_(Delta y) \

  mu_(Delta y) = C / (1 - sum_(i=1)^p phi_i)
$

#figure(
  image("images/A1/arima-cdiff0-d1.png", width: 100%),
  caption: "Previsão de longo prazo com $C!=0$ e $d=1$ gera tendência linear determinística no nível original"
)

=== $d=2$
Gera uma previsão com curvatura quadrática

#figure(
  image("images/A1/arima-cdiff0-d2.png", width: 95.8%),
  caption: "Previsão de longo prazo com $d=2$ gera tendência quadrática determinística no nível original"
)

== Por que $"ARMA"$ e não só $"AR"$ ou $"MA"$?
Acontece que os modelos $"AR"$ e $"MA"$ modelam dois extremos diferentes, um cobre dependência temporal dentro das observações passadas (AR) e o outro cobre dependência temporal dentro dos erros passados (MA). A combinação de ambos permite capturar padrões mais complexos de memória temporal, tornando o modelo mais flexível e capaz de se ajustar melhor a uma variedade maior de séries temporais com menos parâmetros do que um modelo puramente AR ou MA.

Além disso, como vimos, teóricamente, todo modelo $"AR"(p)$ estacionário pode ser representado como um modelo $"MA"(infinity)$ e vice-versa, então para aproximar cada um, eu necessitaria de *muitos* parâmetros no outro, gerando risco de *overfitting* e perda de interpretabilidade.

Aqui utilizamos do princípio da parcimônia: *prefira o modelo mais simples que se ajuste bem aos dados*. Se um modelo $"AR"(p)$ com poucos parâmetros consegue capturar a memória temporal de uma série, não há necessidade de adicionar mais parâmetros de média móvel. O mesmo vale para o contrário.


