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
    Aprendizado Profundo
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
  = Segmentação Semântica 
]

#pagebreak()

== Introdução e Métricas

A segmentação semântica é uma tarefa de visão computacional que consiste em classificar cada pixel de uma imagem em uma categoria específica. Essa tarefa é fundamental para diversas aplicações, como direção autônoma, análise médica e realidade aumentada.

#figure(
  image("images/A1/computer-vision-areas.png", width: 100%),
  caption: "Áreas de visão computacional"
)

Dentro do contexto de segmentação, vale diferenciar entre segmentação semântica e segmentação de instâncias. A segmentação semântica atribui uma classe a cada pixel, enquanto a segmentação de instâncias não apenas classifica os pixels, mas também distingue entre diferentes objetos da mesma classe.

#figure(
  image("images/A1/instance-vs-semantic.png", width: 100%),
  caption: "Diferença entre segmentação semântica e segmentação de instâncias"
)

=== Métricas de Avaliação
Podemos utilizar algumas métricas para avaliar a performance de um modelo de segmentação semântica. As métricas mais comuns incluem:

#definition("Intersection over Union (IoU)")[
  $
    "IoU" = "TP" / ("TP" + "FP" + "FN")
  $
]<iou>

#definition("Precision")[
  $
    "Precision" = "TP" / ("TP" + "FP")
  $
]<precision>

#definition("Average Precision")[
  Dado que na minha imagem eu tenho mapeado $K$ classes, a métrica de Average Precision (AP) é definida como a média das precisões de cada classe:
  $
    "AP" = (1/K) * sum_(k=1)^(K) "Precision"_k
  $
]<avg-precision>

=== Evolução das Abordagens
Vamos relembrar como é estruturada uma rede convolucional padrão para classificação de uma imagem.

#figure(
  image("images/A1/conv-network.png", width: 100%),
  caption: "Estrutura de uma rede convolucional padrão"
)

A imagem passa por uma série de canais de convolução, pooling e normalização, que extraem características relevantes. No final, temos uma camada totalmente conectada que produz a classificação final. Isso nos faz pensar em uma ideia, que tal termos uma janela que percorre a imagem e classifica cada pixel individualmente? Essa abordagem é conhecida como "sliding window" e é uma das primeiras tentativas de segmentação semântica.

#figure(
  image("images/A1/sliding-window.png", width: 100%),
  caption: "Abordagem de sliding window"
)

No entanto, essa abordagem é computacionalmente cara e não aproveita o contexto global da imagem. Para superar essas limitações, surgiram as Fully Convolutional Networks (FCNs), que substituem as camadas totalmente conectadas por camadas convolucionais, permitindo que a rede produza mapas de segmentação diretamente.

#figure(
  image("images/A1/fcn.png", width: 100%),
  caption: "Estrutura de uma Fully Convolutional Network (FCN)"
)

Essa abordagem é interessante, já que permite que a rede aprenda a segmentar a imagem de forma mais eficiente, utilizando o contexto global e local. Além disso, as FCNs podem ser treinadas de forma end-to-end, o que simplifica o processo de treinamento. No entanto , as FCNs são MUITO pesadas, e por isso surgiu a ideia do *downsampling* e *upsampling* dentro da rede, onde basicamente diminuimos os tamanhos das features internas e depois vamos reconstruindo até o tamanho original da imagem. Essa abordagem é conhecida como *encoder-decoder*.

#figure(
  image("images/A1/encoder-decoder.png", width: 100%),
  caption: "Estrutura de uma rede encoder-decoder"
)

== Ferramentas Fundamentais
Antes de irmos para as arquiteturas, precisamos relembrar algumas ferramentas fundamentais que são utilizadas em redes de segmentação semântica, vamos definir todas as ferramentas que iremos utilizar ao apresentar nossas arquiteturas, mas vale ressaltar que existem ferramentas que *caracterizam* algumas arquiteturas, como o *skip connection* na U-Net e os blocos residuais na ResUNet, mas isso não significa que essas ferramentas não podem ser utilizadas em outras arquiteturas, por exemplo, podemos utilizar blocos residuais na SegNet, mas isso não caracteriza a arquitetura como uma ResUNet.

=== Técnicas de Upsampling
O processo de upsampling é o processo de reconstrução da dimensão original das features internas da rede, que foram reduzidas pelo *downsampling*. Existem diversas técnicas para realizar o upsampling, como o *max unpooling* e a *transpose convolution*, que serão detalhadas a seguir.

==== Max Unpooling
Relembrando o que é o *pooling*, ele é uma operação que reduz a dimensionalidade das features internas da rede, geralmente utilizando operações como *max pooling* ou *average pooling*. O *unpooling* é o processo inverso, onde tentamos reconstruir a dimensão original das features a partir das features reduzidas. No entanto, o *unpooling* não é uma operação trivial, pois não temos informações suficientes para reconstruir a dimensão original de forma precisa.

O que acontece é que, *antes* de fazer o *pooling*, nós guardamos os índices dos valores máximos (no caso do *max pooling*), e depois utilizamos esses índices para reconstruir a dimensão original durante o *unpooling*. Essa abordagem é conhecida como *max unpooling*.

#figure(
  image("images/A1/max-unpooling.png", width: 100%),
  caption: "Exemplo de max unpooling"
)

==== Transpose Convolution
A desvantagem do *max unpooling* é que ele depende dos índices dos valores máximos, o que pode limitar a capacidade da rede de aprender representações mais complexas. Uma alternativa é utilizar a *transpose convolution*, também conhecida como *deconvolution*. Essa operação é semelhante à convolução, mas ao invés de reduzir a dimensionalidade das features, ela aumenta.

#figure(
  image("images/A1/transpose-convolution.png", width: 61%),
  caption: "Exemplo de transpose convolution"
)

Como vimos na disciplina de *machine learning*, podemos obter uma matriz de filtro chamada $K_"col"$ a partir da operação _im2col_, que transforma a imagem em uma matriz de colunas. A *transpose convolution* é basicamente a operação inversa, onde aplicamos a matriz de filtro $K_"col"$ na matriz obtida anteriormente

Se $X$ é a entrada da convolução e $K$ é o filtro tal que
$
  Y = X * K
$

Já sabemos que
$
  Y = K_"col" X_"col"
$

temos então que a transpose convolution é definida como
$
  X_"col" = K_"col"^T Y
$

de tal forma que os $X_"col"$ são reconstruídos a partir dos $Y$ e do filtro $K_"col"$ (não de forma perfeita pois há perca de informação na compressão do $X$ para o $Y$, mas o objetivo é que a rede aprenda a reconstruir o $X$ da melhor forma possível)

=== Mecanismos de Contexto e Campo Receptivo
Antes de irmos de fato para as arquiteturas, temos que definir um conceito usado em algumas delas, se não vamos interromper o raciocínio no meio do caminho. O conceito é o de *contexto global*, que basicamente é a ideia de que, para classificar um pixel, precisamos levar em consideração não apenas os pixels vizinhos, mas também os pixels mais distantes da imagem. Só que usar filtros maiores consome mais memória, tempo de processamento e não permite que a rede aprenda a extrair características mais complexas.

==== Atrous Convolution
Para resolver esse problema, surgiu a ideia de *atrous convolution*, que é uma técnica que permite aumentar o tamanho do filtro sem aumentar o número de parâmetros da rede nem redimensioná-la. A ideia é inserir "buracos" (ou *holes*) entre os pixels do filtro, permitindo que ele "veja" mais pixels da imagem sem aumentar o número de parâmetros.

#definition("Atrous Convolution")[
  Dado um filtro $K$ de tamanho $k x k$, e uma feature map $X$, a *atrous convolution* é definida como
  $
    Y(i, j) = sum_(m=0)^(k-1) sum_(n=0)^(k-1) X(i + r * m, j + r * n) K(m, n)
  $
  onde $r$ é o *rate* de atrous convolution, que determina o espaçamento entre os pixels do filtro.
]

#figure(
  image("images/A1/atrous-convolution.png", width: 70%),
  caption: "Exemplo de atrous convolution"
)

==== Image Pooling (Global Average Pooling)
Essa é uma abordagem que permite trazer contexto global da imagem para a rede. Pegamos um feature map e aplicamos um average pooling em toda a imagem, obtendo um vetor de características que representa a imagem como um todo. Esse vetor é então redimensionado através de upsampling e concatenado com o feature map original, permitindo que a rede utilize informações de contexto global para melhorar a segmentação.

#figure(
  image("images/A1/image-pooling.png", width: 100%),
  caption: "Exemplo de image pooling"
)


=== Convoluções Eficientes
Como já discutimos $n$ vezes, as convoluções são operações matemáticas bem caras, e por isso estamos sequer discutindo essas arquiteturas, pois elas são pensadas não somente para a melhor classificação da rede, mas para que possam ser eficientes!

==== Atrous Spatial Pyramid Pooling (ASPP)
Esse conceito é bem simples, vimos anteriormente sobre as Atrous Convolution, convoluções espaçadas para obtenção de contexto local da imagem. No entanto, esse passo pode ser tanto benéfico quanto maléfico! Imagine que a feature que queremos identificar é muito grande no conjunto das imagens, se a rate for muito pequena, isso pode prejudicar que os filtros consigam capturar essa feature, e o mesmo vale para features muito pequenas, se a rate for muito grande, isso pode prejudicar que os filtros a visualizem. A ideia do ASPP é justamente utilizar múltiplas rates de atrous convolution, para que possamos capturar features de diferentes tamanhos na imagem, de forma que elas rodem *paralelamente* e depois sejam concatenadas, permitindo que a rede utilize informações de diferentes escalas para melhorar a segmentação.

#figure(
  image("images/A1/aspp.png", width: 100%),
  caption: "Exemplo de atrous spatial pyramid pooling"
)

==== Convolução Normal V.S Separable Convolution & Atrous Separable Convolution
Em uma convolução normal, cada filtro é aplicado a todos os canais da imagem, o que resulta em um grande número de operações. Veja a imagem a seguir, por exemplo

#figure(
  image("images/A1/normal-convolution-with-3-channels.png", width: 100%),
  caption: "Exemplo de imagem com 3 canais"
)

perceba que, ao aplicar o filtro na imagem com 3 canais, toda a informação foi sumarizada em um único canal (assim, se quiséssemos várias feature maps, nós aplicariamos $C$ filtros diferentes para obter $C$ feature maps). Como nosso filtro é $5 times 5 times 3$, temos um total de $75$ parâmetros. Como a imagem é de tamanho $12 times 12$, o filtro vai percorrer a imagem $8 times 8$ vezes, resultando em um total de $75 * 64 = 4800$ operações. Agora imagine o cenário que falei de utilizarmos múltiplos filtros, vamos usar por exemplo $C=256$

#figure(
  image("images/A1/normal-convolution-with-3-channels-and-256-filters.png", width: 100%),
  caption: "Exemplo de imagem com 3 canais e 256 filtros"
)

Nesse exemplo, temos $256$ filtros de tamanho $5 times 5 times 3$, resultando em um total de $75 * 256 = 19200$ parâmetros. Como a imagem é de tamanho $12 times 12$, o filtro vai percorrer a imagem $8 times 8$ vezes, resultando em um total de $19200 dot 64 = 1.228.800$ operações. Isso é muito caro computacionalmente, e por isso surgiram as convoluções separáveis.

Agora vamos entender como funciona o processo da *SEPARABLE CONVOLUTION*, ela é divida em 2 etapas, a *depthwise convolution* e a *pointwise convolution*. Na *depthwise convolution*, cada filtro é aplicado a apenas um canal da imagem, resultando em múltiplos feature maps, um para cada canal

#figure(
  image("images/A1/depthwise-convolution-with-3-channels.png", width: 100%),
  caption: "Exemplo de depthwise convolution com 3 canais"
)

ainda existem os mesmos $75$ parâmetros, já que são $3$ filtros de tamanho $5 times 5$, mas agora temos $3$ feature maps, um para cada canal. Agora, na *pointwise convolution*, aplicamos um filtro $1 times 1$ em cada feature map, resultando em múltiplos feature maps, um para cada filtro (no mesmo estilo que o filtro antigo era aplicado na convolução normal)

#figure(
  image("images/A1/pointwise-convolution-with-3-channels.png", width: 100%),
  caption: "Exemplo de pointwise convolution com 3 canais"
)

Agora temos que nosso número de parâmetros, além dos $75$ do filtro anterior, temos mais esse filtro menor, nos resultando em $78$ parâmetros. O número de multiplicações, na primeira etapa, é $75 times 8 times 8 = 4.800$, adicionando com a segunda etapa, temos $4800 + (1 times 1 times 3) times 8 times 8 = 4.800 + 192 = 4992$. No entanto, para obtermos múltiplos feature maps, vamos utilizar $C=256$ filtros dos $1 times 1$ que comentamos, dessa forma:

#figure(
  image("images/A1/pointwise-convolution-with-3-channels-and-256-filters.png", width: 90%),
  caption: "Exemplo de pointwise convolution com 3 canais e 256 filtros"
)

Agora vamos ter que a quantidade de filtros é o filtro inicial mais os $256$ outros filtros, logo: $75 + (1 times 1 times 3) times 256 = 75 + 768 = 843$ parâmetros. E como aumentamos apenas os filtros $1 times 1$ para obter os nossos $256$ feature maps, o número de multiplicações passa a ser $4800 + (1 times 1 times 3) times (8 times 8) times 256 = 4800 + 49152 = 53952$.

Esse conceito pode ser expandido para as convoluções Atrous, de forma que as mudanças necessárias são mínimas, mantendo tracking do rate $r$ conseguimos aplicar o mesmo conceito de *depthwise* e *pointwise* para as convoluções Atrous, resultando em uma redução significativa no número de parâmetros e operações, mantendo a capacidade da rede de capturar informações de diferentes escalas.

=== Blocos Residuais
Normalmente, redes neurais são straight-to-the-point, nós temos a entrada $x$ e a partir disso a rede modela uma função complexa $F$ tal que
$
  y = F(x)
$

no entanto, pode existir casos em que $y$ é MUITO parecido com $x$ com leves ajustes, e isso, surpreendentemente, pode dificultar muito o aprendizado da rede. Para consertar isso, os chamados *blocos residuais* foram introduzidos, de forma que a rede não aprende a relação direta entre $x$ e $y$, mas sim a *diferença* entre eles (o quão diferente $y$ é de $x$), ou seja, a rede aprende uma função $F$ tal que
$
  y = F(x) + x
$

O principal motivo dessa abordagem é o *gradiente no backpropagation*. Em redes comuns de deep-learning, o gradiente pode se tornar muito pequeno (ou até mesmo zero) à medida que é propagado para trás, dificultando o aprendizado. Com os blocos residuais, o gradiente pode fluir diretamente através da conexão de atalho, permitindo que a rede aprenda mais facilmente.


== Arquiteturas
=== SegNet
A SegNet é uma arquitetura de rede neural convolucional projetada para segmentação semântica. Ela segue a arquitetura padrão que já demonstramos utilizando do método de max unpooling para realizar upscaling

#figure(
  image("images/A1/segnet.png", width: 100%),
  caption: "Arquitetura da SegNet"
)

=== U-Net
Já na U-Net, a arquitetura é um pouco diferente, ela utiliza *skip connections* para conectar as camadas de downsampling com as camadas de upsampling, permitindo que a rede utilize informações de diferentes níveis de abstração para melhorar a segmentação.

#figure(
  image("images/A1/unet.png", width: 80%),
  caption: "Arquitetura da U-Net"
)

Nas camadas de upsampling, a U-Net utiliza *transpose convolution* para aumentar a dimensionalidade das features unida com um *aumento* nos canais das features. Após o transpose convolution, a U-Net concatena as features da camada correspondente de downsampling, permitindo que a rede utilize informações de diferentes níveis de abstração para melhorar a segmentação, como se ela falasse: "depois de reconstruir a imagem, eu obtive o seguinte mapa de feature, mas lá atrás antes de eu ter feito o downsampling, eu tinha obtido o seguinte mapa de feature, então vou juntar os dois para melhorar a segmentação" (por exemplo, se eu tenho uma imagem 32x32 na escala de cinza, com apenas um canal de cor, na hora do último upsampling, a camada logo após a transpose convolution terá 2 canais "de cor", que seria o mapa obtido pela rede anteriormente e o mapa obtido na camada de upsampling).

=== ResUNet
Na ResUNet, a arquitetura é uma combinação da U-Net com blocos residuais, permitindo que a rede aprenda a diferença entre as features de downsampling e upsampling, melhorando ainda mais a segmentação.

#figure(
  image("images/A1/resunet-architecture.png", width: 50%),
  caption: "Arquitetura da ResUNet"
)

#figure(
  image("images/A1/resunet.png", width: 74%),
  caption: "(a) Bloco padrão da UNet. (b) Bloco residual da ResUNet"
)

=== DeepLab V1 & V2
A DeepLabV1 é uma arquitetura de rede neural convolucional projetada para segmentação semântica, que utiliza *atrous convolution* para aumentar o campo receptivo da rede sem aumentar o número de parâmetros. Ela também utiliza *image pooling* para trazer contexto global da imagem para a rede.

#figure(
  image("images/A1/deeplab.png", width: 100%),
  caption: "Arquitetura da DeepLabV1&V2"
)

Ambas seguem uma arquitetura muito semelhante, diferindo por um único conceito. Na DeepLab V1, passamos a imagem por uma Deep Convolutional Neural Network (DCNN) para extrair features utilizando camadas de Atrous Convolution. Depois, pegamos o score map obtido e aplicamos um processo de *interpolação bilinear* para aumentar a dimensionalidade do score map, e por fim aplicamos o um algoritmo de pós-processamento chamado *Conditional Random Field (CRF)* para refinar a segmentação. Já na DeepLab V2, o processo é o mesmo, mas ao invés de aplicarmos apenas uma Atrous Convolution, aplicamos múltiplas Atrous Convolutions com diferentes *rates* (ASPP).

=== PARSENet
Foi na ParseNet que surgiu a ideia do *image pooling*, gerando o contexto global da imagem para a rede, permitindo que ela utilize informações de diferentes níveis de abstração para melhorar a segmentação. Já vimos antes como esse conceito funciona, mas como ele é estruturado dentro da rede?

Primeiro a rede passa por uma rede convolucional padrão, depois o feature map gerado é passado por um *image pooling*, que gera um vetor de características que representa a imagem como um todo. Esse vetor é então redimensionado através de upsampling e concatenado com o feature map original, permitindo que a rede utilize informações de contexto global para melhorar a segmentação.

#figure(
  image("images/A1/parsenet.png", width: 100%),
  caption: "Arquitetura simplificada da PARSENet"
)

=== PSPNet
A PSPNet é uma arquitetura de rede neural convolucional projetada para segmentação semântica, que utiliza *pyramid pooling* para capturar informações de diferentes escalas da imagem. Ela também utiliza *atrous convolution* para aumentar o campo receptivo da rede sem aumentar o número de parâmetros.

Primeiro a imagem passa por um processamento em uma CNN, essa rede diminui a imagem original para $1\/8$ do seu tamanho original e entra no bloco PSP *único*. Assim como no ASPP a imagem passa por múltiplas convoluções paralelas, no bloco PSP, a imagem passa por múltiplos *average pooling* com diferentes tamanhos de agrupamento:

- *Nível Red ($1 times 1$)*: Realiza um Global Average Pooling sobre toda a extensão espacial. Gera um único vetor por canal que representa o contexto macro/global da cena inteira
- *Nível Orange ($2 times 2$)*: Divide o mapa em 4 quadrantes (grade $2 times 2$) e extrai a média de cada região (contexto regional amplo)
- *Nível Blue ($3 times 3$)*: Divide o mapa em 9 sub-regiões (grade $3 times 3$) para capturar um contexto regional médio
- *Nível Green ($6 times 6$)*: Divide o mapa em 36 sub-regiões (grade $6 times 6$) para capturar detalhes locais e regionais finos

#figure(
  image("images/A1/pspnet.png", width: 97%),
  caption: "Arquitetura da PSPNet"
)

então através do upsample, cada mapa de pooling é redimensionado para o tamanho original do feature map, e todos os mapas são concatenados, permitindo que a rede utilize informações de diferentes escalas para melhorar a segmentação.

=== Deeplab V3 & V3+
A DeepLabV3 foi teve algumas melhorias implementadas. O primeiro ponto foi a remoção do pós-processamento com CRF, que foi substituído por um *upsampling* simples, dessa forma a própria rede consegue aprender a mapear corretamente a segmentação. O segundo ponto foi a implementação do ASPP, que já havíamos comentado anteriormente. E o terceiro ponto foi a implementação, em paralelo com o ASPP, de um *image pooling* para pegar contexto global da rede

#figure(
  image("images/A1/deeplabv3.png", width: 100%),
  caption: "Arquitetura da DeepLabV3"
)

O *DeepLabv3+* foi projetado para resolver uma limitação fundamental do DeepLabv3: embora o DeepLabv3 capturasse um contexto multi-escala excelente através do ASPP, ele perdia detalhes finos e precisão nas bordas dos objetos devido à redução de resolução espacial (*striding* e *pooling*) no backbone. Para corrigir isso, o DeepLabv3+ combina o melhor de duas abordagens: a extração de contexto do *Spatial Pyramid Pooling (ASPP)* com a capacidade de recuperação de bordas da estrutura *Encoder-Decoder*.

#figure(
  image("images/A1/deeplabv3plus.png", width: 100%),
  caption: "Arquitetura da DeepLabV3+"
)

Em vez do upsampling bilinear direto que o V3 fazia, o V3+ agora tem um módulo decoder dedicado, onde ele faz upsampling das características e vai utilizando das features do encoder para refinar a segmentação, especialmente nas bordas dos objetos. Isso permite que o modelo mantenha a precisão espacial enquanto ainda aproveita o contexto global capturado pelo ASPP.

== Percas
Agora vamos visualizar as losses que utilizamos para informar o modelo como aprender! Mas antes, vamos recaptular alguns pontos e definições.

Primeiramente, dado uma imagem $H times W$, a saída dos nossos modelos deve ser uma matriz $H times W$ onde cada elemento da matriz representa a classe do pixel correspondente na imagem (também pode ser um vetor com $N = H dot W$ elementos). Vamos considerar a abordagem de um único vetor de $N$ elementos com a classe de cada pixel. Definiremos também $t_i$ sendo a *classe verdadeira* do pixel $i$ (ground truth). Definimos também $p_i$ sendo a probabilidade que o modelo atribui para que $i$ seja da sua *classe verdadeira* ($PP("classe"(i) = t_i)$). A partir disso, podemos definir as losses que utilizamos para treinar nossos modelos.

=== Cross Entropy Loss
A primeira que vamos ver é a mais padrão para problemas de classificação, a *cross entropy loss*. Ela é definida como
$
  "CE" = -1/N sum_(i=1)^(N) log(p_i)
$

se o modelo prevê alta probabilidade para a classe correta do pixel, o $log(p_i)$ será próximo de $0$, e a loss será pequena. Se o modelo prevê baixa probabilidade para a classe correta do pixel, o $log(p_i)$ será negativo e a loss será grande. O objetivo do treinamento é minimizar essa loss, ajustando os pesos da rede para que ela preveja corretamente as classes dos pixels.

No entanto, essa loss carrega um problema. Quando existe um desbalanceamento de classes dentro do meu dataset, pode acontecer de a rede aprender a prever apenas a classe majoritária, ignorando as classes minoritárias.

=== Balanced Cross Entropy Loss
Para resolver o problema citado, podemos utilizar a *balanced cross entropy loss*, que atribui pesos diferentes para cada classe, penalizando mais os erros nas classes minoritárias.
$
  "BCE" = -1/N sum_(i=1)^(N) omega_(t_i) log(p_i)
$

o peso $omega_(t_i)$ é pré-calculado de forma inversamente proporcional à frequência da classe $t_i$ no dataset, de forma que classes minoritárias tenham pesos maiores e classes majoritárias tenham pesos menores. Isso força a rede a prestar mais atenção às classes minoritárias durante o treinamento. Podemos ter uma formulação binária também
$
  "BCE" = -1/N ( sum_(i in "positivos") omega_"pos" log(p_i) + sum_(i in "negativos") omega_"neg" log(p_i) )
$

=== Focal Loss
Essa loss serve para resolver um problema sutíl. A loss anterior resolve o problema de desbalanceamento de classes, mas não resolve o problema de *hard examples*, ou seja, exemplos que são difíceis de classificar e quais são esses pixeis? São justamente os que estão cada vez mais próximos das bordas do elemento. No entanto, os pixeis fáceis costumam ser os mais presentes, e a soma do gradiente de sua contribuição pode atrapalhar no aprendizado dos pixeis mais difíceis. A *focal loss* resolve esse problema, diminuindo a contribuição dos pixeis fáceis para o gradiente, permitindo que a rede foque nos pixeis mais difíceis.
$
  "FL" = -1/N sum_(i=1)^(N) (1 - p_i)^gamma log(p_i)
$

- *Comportamento do pixel fácil*: Consideremos $p_i = 0.95$ e $gamma = 2$, então o fator de peso fica $0.0025$, a perda desse pixel é reduzida em $99.75%$, fazendo com que ele quase não afete o treinamento
- *Comportamento do pixel difícil*: Consideremos $p_i = 0.2$ e $gamma = 2$, então o fator de peso fica $0.64$, a perda desse pixel é mantida relevante

$gamma$ é o parâmetro focal, quanto maior ele é, mais severa é a penalidade aplicada aos pixels fáceis, e quanto menor ele é, mais leve é a penalidade aplicada aos pixels fáceis. O valor padrão de $gamma$ é $2$, mas ele pode ser ajustado dependendo do problema e do dataset.

=== Balanced Focal Loss
Combina as duas soluções, ponderando cada pixel de acordo com sua classe e aplicando penalidade em pixels fáceis, de forma que a rede foque nos pixels mais difíceis e nas classes minoritárias.
$
  "FL"_"bal" = -1/N sum_(i=1)^(N) omega_(t_i) (1 - p_i)^gamma log(p_i)
$

=== Loss Function for Regression
A saída por pixel pode não necessariamente ser um label de classe, mas um valor numérico. Por exemplo, se a rede estiver tentando estimar a profundidade aplicada àquela foto, então utilizamos as losses $L_1$ e $L_2$
$
  L_1 &= 1/N sum_(i=1)^(N) |y_i - t_i|   \

  L_2 &= 1/N sum_(i=1)^(N) (y_i - t_i)^2
$

onde $y_i$ é o valor predito pelo modelo e $t_i$ é o valor verdadeiro.

== Pontos Práticos
=== A necessidade de Patches (Tiles)
Em aplicações reais, as imagens originais frequentemente possuem resoluções massivas (ex: $(4000 times 4000$) pixels ou mais). Tentar passar uma imagem desse tamanho inteira por uma rede neural de uma só vez estoura o limite de memória VRAM da GPU.

Por isso, na prática, a imagem é fatiada em blocos menores (*patches* ou *tiles*) para serem processados individualmente durante o treinamento e a inferência, montando-se um *mosaico* com os resultados finais de cada bloco.

#figure(
  image("images/A1/patches.png", width: 100%),
  caption: "Exemplo de fatiamento de uma imagem em blocos menores"
)

=== O Problema do Contexto nas Bordas (Border Context Loss)
Dividir a imagem em blocos cria um desafio geométrico nas extremidades de cada bloco:

- *Perda de Contexto Espacial*: Os pixels situados nas bordas de um *patch* perdem a vizinhança e o contexto espacial da região vizinha que ficou no *patch* ao lado.
- *Artefatos no Mosaico*: Ao colar os *patches* de volta para reconstruir a imagem final, essa falta de contexto nas margens gera artefatos de corte visíveis, descontinuidades e erros de classificação ao longo das linhas de junção dos blocos.

Para mitigar a perda de contexto nas bordas dos blocos, podemos destacar a estratégia de _mosaico com sobreposição (*Overlapping Patches*)_:

+ *Sobreposição de Blocos*: Os *patches* são recortados com uma porcentagem de sobreposição em relação aos vizinhos, em vez de serem colados estritamente lado a lado.
+ *Considerar Apenas a Região Central (_Inner Part_)*: Descarta-se a borda externa do *patch* (onde o contexto foi prejudicado) e utiliza-se apenas a previsão da região central válida.
+ *Média das Predições (_Averaging Results_)*: Nas áreas onde os blocos se sobrepõem, calcula-se a média das probabilidades previstas por cada bloco para definir a classe final do pixel.

=== CNN Patch-wise Clássica vs. FCN Modela
- *CNN Clássica Por Patch (Sliding Window)*: Classificava isoladamente o pixel central de um *patch* deslocado. Isso gerava alta redundância de cálculos e resultava em um efeito de *suavização excessiva nas bordas dos objetos (_oversmoothing_)*.
- *FCN Moderna*: Classifica todos os pixels do *patch* simultaneamente em uma única passada (*dense prediction*), aprendendo estruturas e geometrias específicas diretamente contidas dentro de cada bloco.

#pagebreak()

#align(center + horizon)[
  = Object Detection
]

#pagebreak()

== Introdução
Dentro da área de visão computacional, podemos fazer algumas distinções de tarefas, veja o gráfico abaixo

#figure(
  image("images/A1/comp-vision-tasks.png"),
  caption: "Áreas de visão computacional"
)

Já vimos segmentação semântica, que é a tarefa de classificar cada pixel da imagem em uma categoria específica. A detecção de objetos, por outro lado, é a tarefa de identificar e localizar objetos específicos dentro de uma imagem, geralmente representados por *bounding boxes*. A detecção de objetos é muito baseada em *regiões* enquanto a segmentação semântica é baseada em *pixels*. A detecção de objetos é fundamental para diversas aplicações, como vigilância, direção autônoma e análise de imagens médicas.

== Métricas de Avaliação
Podemos utilizar métricas já vistas como @iou, @precision e @avg-precision, porém podemos também utilizar métricas como *Recall*

#definition("Recall")[
  $
    "Recall" = "TP" / ("TP" + "FN")
  $
]<recall>

A maioria das competições utiliza a *mean Average Precision (mAP)* como métrica principal, que é a média das precisões de cada classe, considerando diferentes limiares de confiança para as detecções. O mAP é derivado de valores _precision v.s recall_, fazendo uma variação do limiar de confiança para cada classe. O *limiar de confiança* é a probabilidade de que uma *caixa de âncora* contenha um objeto. Dado a @avg-precision de Average Precision, podemos definir melhor o mAP

#definition("mAP")[
  Dado que na minha imagem eu tenho mapeado $K$ classes, a métrica de mean Average Precision (mAP) é definida como a média das precisões de cada classe:
  $
    "mAP" = 1/K sum_(k=1)^(K) "AP"_k
  $
]

== Redes de Estágio Único (Single-Shot): A Família YOLO
A abordagem mais simples que podemos imaginar é aplicar uma rede convolucional para classificar a imagem inteira, mas isso não nos dá informações sobre a localização dos objetos

=== Fundamentos do YOLO


== Redes de Dois Estágios e Segmentação de Instâncias: Mask R-CNN


#pagebreak()

#align(center + horizon)[
  = Recurrent Neural Networks (RNNs)
]

#pagebreak()


#pagebreak()

#align(center + horizon)[
  = Generative Adversarial Networks (GANs)
]

#pagebreak()
