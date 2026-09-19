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
Baseada em redes neurais convolucionais que redefiniu o problema de detecção como uma única tarefa de regressão e classificação em uma só passada (*single-shot*).

Ao contrário das abordagens tradicionais baseadas em *sliding window* (janela deslizante), que executavam classificadores repetidamente sobre centenas de retalhos da imagem gerando um custo computacional altíssimo, o YOLO avalia a imagem inteira de uma só vez

=== Fundamentos do YOLO
Um modelo YOLO (You Only Look Once) divide a imagem em uma grade de células, ele também recebe obrigatoriamente uma imagem quadrada, de lados $n times n$. Cada célula da grade fica resposável por prever objetos cujo *ponto central* (mid point) caia dentro dos limites dessa célula. Como uma única passada na CNN processa todas as células simultaneamente, o YOLO é extremamente rápido e eficiente, tornando-o adequado para aplicações em tempo real.

=== Parametrização do vetor de saída
Para cada célula da grade, o YOLO prevê um vetor de saída que contém informações sobre os objetos detectados. Esse vetor inclui:
$
  y = [p_"obj", b_x, b_y, b_h, b_w, c_1, c_2, ..., c_C]
$

- *$p_"obj"$*: Probabilidade de que a célula contenha um objeto
- *$(b_x,b_y,b_h,b_w)$*: Coordenadas da caixa delimitadora (x, y, largura, altura). $b_x,b_y in [0,1]$, representando a posição relativa do centro da caixa em relação à célula. Por exemplo, se $b_x=0.5$ e $b_y=0.5$, então a caixa de âncora está exatamente no centro da célular.$b_h$ e $b_w$ representam a altura e largura relativas à caixa, mas podem ser maiores que $1$ (a caixa pode ser maior que a célula).
  #figure(
    image("images/A1/yolo-box.png", width: 100%),
    caption: "Exemplo de caixa delimitadora prevista pelo YOLO"
  )
- *$(c_1,c_2,...,c_C)$*: Probabilidades de cada classe

=== Caixas de Ancoragem (Anchor Boxes)
Para resolver o problema de múltiplos objetos cujos centros caiam na mesma célula ou objetos de proporções muito distintas (como uma pessoa alta e um carro largo), o YOLO utiliza *Anchor Boxes*. Cada célula da grade prevê múltiplos *bounding boxes* associados a modelos geométricos _pré-definidos_ (*anchors*). Em vez de prever o formato absoluto da caixa do zero, a rede aprende deslocamentos (*offsets*) para ajustar a posição e a dimensão das *anchor boxes pré-definidas*

#figure(
  image("images/A1/yolo-anchor-boxes.png", width: 100%),
  caption: "Exemplo de caixas de ancoragem previstas pelo YOLO"
)

Então nessa nova formulação, o vetor de saída para cada célula da grade se torna:
$
  y = mat(
    [p_"obj", b_x, b_y, b_h, b_w, c_1, c_2, ..., c_C]_("anchor 1");
    [p_"obj", b_x, b_y, b_h, b_w, c_1, c_2, ..., c_C]_("anchor 2");
    dots.v;
    [p_"obj", b_x, b_y, b_h, b_w, c_1, c_2, ..., c_C]_("anchor A")
  )
$

Vale ressaltar que eu escrevi em forma de matriz, no entanto o mais comum é um vetor contínuo e separamos as anchor boxes pelo padrão da saída, que seria a cada $5+C$ valores, onde $C$ é o número de classes. Por exemplo, se temos $3$ anchor boxes e $20$ classes, o vetor de saída para cada célula da grade terá tamanho $3 times (5 + 20) = 75$.

=== Supressão Não-Máxima (Non-Maximum Suppression - NMS)
Na prática, é bem fácil perceber que vai acontecer de várias caixas serem selecionadas para o mesmo objeto, e isso é um problema. Para resolver isso, utilizamos a técnica para escolher a caixa que melhor representa o objeto, descartando as demais. A técnica é chamada de *Non-Maximum Suppression (NMS)*, e funciona da seguinte forma:
+ *Filtragem por confiança*: Descartamos todas as caixas cuja probabilidade de conter um objeto seja menor que um limiar pré-definido (ex: 0.5)
+ *Seleção da melhor caixa*: Entre as caixas restantes, selecionamos a caixa com a maior probabilidade de conter um objeto (maior pontuação de confiança $p_"obj"$)
+ *Eliminação de duplicatas*: Elimina as outras caixas da mesma classe que possuem uma sobreposição $"IoU">=0.5$ com a caixa selecionada
+ Repete o processo iterativamente para as caixas restantes de cada classe

#figure(
  image("images/A1/nms.png", width: 100%),
  caption: "Exemplo de supressão não-máxima"
)

Vale ressaltar que esse *pós-processamento* é feito com *todas* as caixas de ancoragem previstas, tanto as que foram atribuidas dentro de uma mesma célula (uma única célula atribui diferentes anchor boxes pro mesmo objeto) quanto as geradas por células vizinhas (várias células podem prever o mesmo objeto). O objetivo é garantir que cada objeto seja representado por uma única caixa delimitadora final.

=== Evolução Arquitetural
==== YOLOv1 & YOLO9000
Arquiteturas iniciais, foi na YOLO9000 onde as anchor boxes foram introduzidas e, em vez de prever diretamente prosição e tamanho das caixas, a rede aprende a prever *offsets* para ajustar as *anchor boxes* pré-definidas.

==== YOLOv3
Aumento da profundidade da rede, de $53$ camadas para $106$ camadas. Adição de skip connections para melhorar a propagação do gradiente e permitir que a rede aprenda representações mais complexas. Introdução de *multi-scale predictions*, onde a rede prevê caixas em três escalas diferentes, permitindo detectar objetos de tamanhos variados.

#figure(
  image("images/A1/yolov3.png", width: 100%),
  caption: "Arquitetura da YOLOv3"
)

=== Loss Function
Não podemos falar de um modelo de rede sem discutir a loss por ela utilizada. A loss do YOLO é composta por três partes principais: a *loss de localização*, a *loss de confiança* e a *loss de classificação*. A *loss de localização* mede o quão bem a rede prevê as coordenadas da caixa delimitadora em relação à caixa real. A *loss de confiança* avalia a precisão da rede em prever se uma caixa contém um objeto ou não. A *loss de classificação* mede a precisão da rede em classificar corretamente o objeto dentro da caixa.

Vamos rapidamente definir que a *predição do modelo* é dada, para a célula $i in {1,...,S^2}$ e anchor box $j in {1,...,B}$:
$
  y_(i j) = [p^((i j))_"obj", b^((i j))_x, b^((i j))_y, b^((i j))_h, b^((i j))_w, c^((i j))_1, c^((i j))_2, ..., c^((i j))_C]
$
e vamos considerar o vetor *ground truth* como
$
  t_(i j) = [t^((i j))_0, t^((i j))_x, t^((i j))_y, t^((i j))_h, t^((i j))_w, s^((i j))_1, s^((i j))_2, ..., s^((i j))_C]
$
então a loss da YOLO é dada por
$
  cal(L)_"YOLO" &= lambda_"coord" underbrace(sum_(i=0)^S^2 sum_(j=0)^B t_0^((i j)) ((t^((i j))_x - b^((i j))_x)^2 + (t^((i j))_y - b^((i j))_y)^2 + (t^((i j))_h - b^((i j))_h)^2 + (t^((i j))_w - b^((i j))_w)^2), "Loss de localização")   \ \
  
  &+lambda_"noobj" underbrace(sum_(i=0)^S^2 sum_(j=0)^B (1 - t_0^((i j)))(-log(1-p^((i j))_"obj")), "Loss de confiança") \

  &+ underbrace(sum_(i=0)^S^2 sum_(j=0)^B t_0^((i j)) [-log(p^((i j))_"obj") + sum_(k=1)^C "BCE"(c^((i j))_k, s^((i j))_k)], "Loss de classificação")
$

Onde $S$ é a proporção que dividimos os grids da imagem, $B$ é o número de *anchor boxes* por célula, $C$ é o número de classes, $lambda_"nobj"$ e $lambda_"coord"$ são hiperparâmetros que controlam a importância relativa das diferentes partes da loss.

Vejamos como a loss se comporta. Se uma anchor box *não possui objeto*, então apenas a parte da *loss de confiança* é computada. Quando a probabilidade de que a caixa contenha um objeto é $0$, então a $log(1 - 0) = 0$, não penalizando a rede, no entanto, se a rede classificou como existindo um objeto, então a loss será alta e irá penalizar a rede. Se uma anchor box *possui objeto*, então apenas as partes da *Loss de Localização* e *Loss de Classificação* são computadas. A *Loss de Localização* mede o quão bem a rede prevê as coordenadas da caixa delimitadora em relação à caixa real, e a *Loss de Classificação* mede a precisão da rede em classificar corretamente o objeto dentro da caixa.


== Redes de Dois Estágios e Segmentação de Instâncias: Mask R-CNN
As redes Mask R-CNN são uma extensão das redes Faster R-CNN, projetadas para realizar não apenas a detecção de objetos, mas também a segmentação de instâncias. A Mask R-CNN adiciona um ramo adicional à arquitetura Faster R-CNN para prever máscaras binárias para cada objeto detectado, permitindo que a rede identifique não apenas a localização e a classe do objeto, mas também sua forma precisa.

=== Geração de propostas com a RPN (Region Proposal Network)
Antes de mais nada, a *imagem é redimensionada* para caber na rede backbone. Essa rede backbone recebe a imagem e gera um *feature map* que representa as características da imagem. Esse *feature map* é então passado para a *Region Proposal Network (RPN)*, que é responsável por gerar propostas de regiões onde objetos podem estar localizados. A RPN utiliza um conjunto de $k$ *anchor boxes* de diferentes tamanhos e proporções para cobrir uma variedade de objetos possíveis na imagem.

A RPN fica responsável por aprender principalmente duas coisas: A probabilidade de a anchor box conter ou não um objeto e estimar o tamanho/formato da caixa delimitadora do objeto. Primeiro, uma convolução $3 times 3$ com $512$ filtros é aplicada ao *feature map* da backbone, gerando um *feature map* intermediário.

Em seguida, duas convoluções $1 times 1$ são aplicadas: uma para prever a probabilidade de cada *anchor box* conter um objeto (*objectness score*), contento um total de $36$ filtros e outra para prever os ajustes necessários para refinar as coordenadas da caixa delimitadora (*bounding box regression*) com $18$ filtros.

#figure(
  image("images/A1/mask-rcnn-backbone.png", width: 100%),
  caption: "Arquitetura da Mask R-CNN"
)

Logo após isso, para escolher as melhores propostas de regiões, a RPN aplica a técnica de *Non-Maximum Suppression (NMS)* para eliminar propostas redundantes e manter apenas as mais promissoras. As propostas selecionadas são então passadas para a próxima etapa da Mask R-CNN, onde cada proposta é processada individualmente para prever a classe do objeto, refinar a caixa delimitadora e gerar a máscara binária correspondente.


=== Alinhamento de Características com RoIAlign
Temos um problema, o próximo passo (a rede geradora de máscara) espera um *feature map* de tamanho fixo, mas as propostas de regiões geradas pela RPN podem ter tamanhos variados. Para resolver isso, a Mask R-CNN utiliza o *RoIAlign*, que é uma técnica que extrai características de regiões de interesse (RoIs) do *feature map* da backbone, garantindo que cada RoI seja representada por um *feature map* de tamanho fixo.

A primeira abordagem utilizada era a *RoIPooling*, que dividia a região de interesse em uma grade de células e aplicava *max pooling* em cada célula para obter um valor representativo. No exemplo da @roi-pooling-example-1, temos uma imagem de tamanho $8 times 8$ e a região vermelha destacada é a região de interesse com tamanho $6 times 4$, no entanto a rede geradora de máscara espera uma *feature map* de tamanho $2 times 2$, então dividimos a região de interesse em uma grade de $2 times 2$ células, e aplicamos *max pooling* em cada célula para obter um valor representativo. O problema é que a divisão da região de interesse em células pode não ser exata, resultando em perda de informações e desajustes na localização das características.

Veja por exemplo a @roi-pooling-example-2. Nesse caso, a região de interesse (borda vermelha) não cai exatamente na divisão dos pixeis, na verdade ela para na metade de um, e isso *pode acontecer* como já discutimos anteriormente. Nesses casos, o *RoIPooling* arredonda os valores para o inteiro mais próximo (borda azul), resultando em perda de informações e desajustes na localização das características. Para resolver esse problema, a Mask R-CNN utiliza o *RoIAlign*, que utiliza interpolação bilinear para calcular os valores das células da grade, garantindo que as características sejam alinhadas corretamente com a região de interesse.

#figure(
  image("images/A1/roi-pooling.png", width: 90%),
  caption: "Exemplo de RoIPooling com região de interesse alinhada com a grade de células"
)<roi-pooling-example-1>

#figure(
  image("images/A1/roi-pooling-2.png", width: 90%),
  caption: "Exemplo de RoIPooling com região de interesse desalinhada com a grade de células"
)<roi-pooling-example-2>

#figure(
  image("images/A1/roi-align.png", width: 90%),
  caption: "Exemplo de RoIAlign com região de interesse alinhada com a grade de células"
)

=== Predições em Paralelo (R-CNN + FCN)
Depois que o *RoIAlign* é aplicado, cada proposta de região é representada por um *feature map* de tamanho fixo. Esse *feature map* é então passado para dois ramos *paralelos* da Mask R-CNN:

#figure(
  image("images/A1/rcnn.png", width: 100%),
  caption: "Arquitetura da Mask R-CNN com predições em paralelo"
)

- *R-CNN*: Responsável por prever a classe do objeto e refinar a caixa delimitadora. Ele utiliza uma série de camadas totalmente conectadas para processar o *feature map* da proposta de região e gerar as predições de classe e caixa.
- *FCN*: Responsável por gerar a máscara binária do objeto. Ele utiliza uma série de camadas convolucionais para processar o *feature map* da proposta de região e gerar a máscara binária correspondente. A saída do FCN é uma máscara de tamanho fixo (por exemplo, $28 times 28$ pixels) que representa a forma do objeto dentro da caixa delimitadora. Essa máscara é então redimensionada para se ajustar à caixa delimitadora refinada, permitindo que a Mask R-CNN produza uma segmentação precisa da instância do objeto.

#figure(
  image("images/A1/models-comparision.png", width: 100%),
  caption: "Arquitetura da Mask R-CNN com predições em paralelo"
)


#pagebreak()

#align(center + horizon)[
  = Recurrent Neural Networks (RNNs)
]

#pagebreak()

== Introdução e Modelagem de Dados Sequenciais
As RNNs são redes neurais projetadas para lidar com dados sequenciais, onde os dados possuem um tipo de relação sequencial, seja por tempo, posição ou qualquer outra forma de dependência entre os elementos da sequência. Diferente das redes feedforward tradicionais, as RNNs possuem conexões recorrentes que permitem que informações de etapas anteriores da sequência influenciem a saída atual, tornando-as ideais para tarefas como processamento de linguagem natural, reconhecimento de fala, séries temporais e processamento de vídeos.

== Simple RNN (Vanilla RNN)
É o modelo mais básico de RNN, onde cada célula da rede recebe a entrada atual e o estado oculto da etapa anterior, processando essas informações para gerar uma saída e atualizar o estado oculto para a próxima etapa da sequência.

Antes de partir para a estrutura matemática em si, vamos ver esse simples exemplo: Imagine uma cafeteria, e a @rnn-example representa a sequência de pratos principais que um cliente pode pedir ao longo de uma semana. Cada dia da semana representa uma etapa da sequência. A RNN é capaz de capturar essa dependência sequencial, permitindo que a rede aprenda padrões de pedidos ao longo do tempo.

#figure(
  image("images/A1/rnn-example.png", width: 100%),
  caption: "Exemplo de RNN em uma cafeteria"
)<rnn-example>

Podemos interpretar cada um dos pratos principais como vetores *one-hot*
$
  "Lasanha" = [1,0,0] wide "Salsicha" = [0,1,0] wide "Frango" = [0,0,1]
$

E perceba que a seguinte relação é apresentada
$
  "Lasanha" -> "Salsicha" -> "Frango" -> "Lasanha" -> "Salsicha" -> "Frango" -> "Lasanha"
$

Conseguimos facilmente representar essa rotatividade utilizando de uma matriz de transição:
$
  X =mat(0,0,1; 1,0,0; 0,1,0)   \

  X "Lasanha" = "Salsicha" wide X "Salsicha" = "Frango" wide X "Frango" = "Lasanha"
$

Considere agora a influência de uma variável externa na decisão do restaurante com relação ao prato do dia, digamos o *clima*. Agora além dos vetores de pratos principais, temos também vetores *one-hot* representando o clima:
$
  "Sol" = [1,0] wide "Chuva" = [0,1]
$

Agora a rede depende tanto das informações de *histórico* (pratos anteriores) quanto das informações de *contexto* (clima atual). A rede agora aprende a prever isso através de *duas* matrizes
- $W_(h h)$: Matriz que aprende as regras da sequência do cardápio, ela responde a pergunta "Se ontem foi servido Frango, qual seria a mesma comida e qual será a próxima?"

#figure(
  image("images/A1/rnn-example-2.png", width: 100%),
  caption: "Exemplo de RNN em uma cafeteria com influência do clima"
)

- $W_(x h)$: Matriz que aprende a influência do clima na decisão do cardápio, ela responde a pergunta "Se hoje está chovendo, devo manter a escolha de comida ou mudar para a  próxima da sequência?"

Mas como a rede toma a decisão? A cada passo temporal (dia $t$), a rede utiliza a seguinte fusão: *Consulta a memória* pegando a comida do dia anterior $h_(t-1)$ e multiplica por $W_(h h)$ para entender a tendência do cardápio, *lê o presente* pegando o clima atual $x_t$ e multiplica pela matriz $W_(x h)$, depois *soma e aplica ativação* e *gera a saída*, o novo estado oculto $h_t$ que passa por uma matriz final $W_(h o)$ que decide qual será a comida do dia $t$.

Definindo de forma mais formal, a RNN pode ser definida pela seguinte estrutura
$
  h_t = f_(theta) (h_(t-1), x_t) = tanh(W_(h h) h_(t-1) + W_(x h) x_t + b_h)   \
$

e a saída no instante $t$ é dada por
$
  o_t = W_(h o) h_t + b_o
$

Podemos representar toda essa estruturação em bloco da seguinte forma
$
  h_t = "NL"([W_(h h)|W_(x h)|b_(h)]mat(h_(t-1); x_t; 1))   \

  o_t = [W_(h o)|b_(o)]mat(h_t; 1)
$

#figure(
  image("images/A1/rnn-block.png", width: 70%),
  caption: "Bloco de uma RNN"
)

=== Arquitetura
Podemos estruturar uma arquitetura visual fixa para cada um dos passos temporais que a rede recorrente faz

#figure(
  image("images/A1/rnn-architecture.png", width: 80%),
  caption: "Arquitetura de uma RNN"
)

Podemos utilizar uma fórmula *recursiva* para representar a RNN, onde o estado oculto $h_t$ é atualizado a cada passo temporal com base no estado oculto anterior $h_(t-1)$ e na entrada atual $x_t$.
$
  underbrace(h_t, "Estado Oculto") = f_(theta) (underbrace(h_(t-1), "Estado Anterior"), underbrace(x_t, "Entrada Atual"))   \
$

e vale ressaltar que o *mesmo conjunto de parâmetros $theta$* é utilizado em *todos os passos temporais*, diferente de uma rede neural padrão onde *cada camada possui um conjunto de parâmetros diferente*. Isso permite que a RNN generalize melhor para sequências de diferentes comprimentos e capture padrões temporais de forma mais eficiente.

Tomemos a simples RNN $h_t = tanh(W_(h h) h_(t-1) + W_(x h) x_t)$ e vamos ver como a recursividade se comporta com $T=3$
$
  h_3 &= tanh(W_(h h) h_2 + W_(x h) x_3)   \
  h_3 &= tanh(W_(h h) (tanh(W_(h h) h_1 + W_(x h) x_2)) + W_(x h) x_2)   \
  h_3 &= tanh(W_(h h) (tanh(W_(h h) (tanh(W_(h h) h_0 + W_(x h) x_1)) + W_(x h) x_2)) + W_(x h) x_3)
$

=== RNN Unroling
Baseado na arquitetura mostrada, podemos escolher que o output da rede seja o *output* de cada passo temporal, ou apenas o *output* do último passo temporal. A primeira abordagem é útil quando queremos prever uma sequência de saídas, enquanto a segunda abordagem é útil quando queremos prever uma única saída baseada em toda a sequência de entradas.

Baseado nisso, conseguimos desenvelopar o parâmetro de tempo da RNN, mostrando como a rede processa cada elemento da sequência ao longo do tempo. Esse processo é conhecido como *unrolling* da RNN, e nos permite visualizar claramente como as informações fluem através da rede em cada passo temporal.

#figure(
  image("images/A1/rnn-unrolling.png", width: 100%),
  caption: "Desenrolando uma RNN"
)

=== Tipos de mapeamento sequencial
- *Many-to-many*: Existem duas variações, a primeira é quando a entrada e a saída são sequências de comprimentos iguais. Por exemplo, os momentos de um vídeo e a categoria que aquele momento se encaixa (drama, terror, etc.)
  #figure(
    image("images/A1/rnn-many-to-many-1.png", width: 100%),
    caption: "Exemplo de mapeamento many-to-many"
  )
  A segunda variação é quando a entrada e a saída são sequências de comprimentos diferentes. Por exemplo, uma frase em inglês e sua tradução em português.
  #figure(
    image("images/A1/rnn-many-to-many-2.png", width: 100%),
    caption: "Exemplo de mapeamento many-to-many"
  )

- *One-to-many*: Quando o modelo recebe uma única entrada e gera uma sequência de saídas. Por exemplo, uma imagem e a legenda que descreve a imagem.
  #figure(
    image("images/A1/rnn-one-to-many.png", width: 100%),
    caption: "Exemplo de mapeamento one-to-many"
  )
- *Many-to-one*: Quando o modelo recebe uma sequência de entradas e gera uma única saída. Por exemplo, uma sequência de palavras e a classificação da sentença.
  #figure(
    image("images/A1/rnn-many-to-one.png", width: 100%),
    caption: "Exemplo de mapeamento many-to-one"
  )


== Treinamento e Problemas de Gradiente na RNN
Como comentamos, os mesmos parâmetros $theta$ são utilizados em *todas as camadas* da rede neural, por conta disso, não podemos usar o *backpropagation* tradicional, e sim o *backpropagation through time (BPTT)*, que é uma extensão do algoritmo de retropropagação para redes recorrentes.

=== Backpropagation Through Time (BPTT)
Como cada célula da RNN é uma camada da rede neural, o processo de unrolling da RNN ao longo do tempo cria uma rede profunda, onde cada passo temporal é tratado como uma camada separada com o diferencial que os mesmos parâmetros são usados em todos os passos.

Em uma tarefa com saída de múltiplos passos temporais (many-to-many), o erro global $E$ é acumulado e calculado a cada instante temporal $t$
$
  E = sum_(t=1)^T E_t
$

Para atualizar a matriz de pesos compartilhada $W_(h h)$ precisamos calcular a derivada parcial de $E$ em relação a $W_(h h)$. Pela regra da cadeia, o erro $E_t$ em um determinado instante $t$ depende não apenas da célula no instante $t$, mas de toda a história de estados ocultos anteriores $h_k space (k<=t)$
$
  (partial E) / (partial W_(h h)) = sum_(k=1)^T (partial E_t) / (partial h_t) (partial h_t) / (partial h_k) (partial h_k) / (partial W_(h h))
$

As derivadas da esquerda ($(partial E_t) / (partial h_t)$) e direita ($(partial h_k) / (partial W_(h h))$) são fáceis de visualizar pela relação direta que a função derivada tem com o termo da derivação, no entanto, o termo do meio é um pouco mais complexo, mas ele representa *o fluxo do gradiente retropropagado do passo $t$ até o passo $k$*
$
  (partial h_t) / (partial h_k) = product_(j=k+1)^t (partial h_j) / (partial h_(j-1))
$

#figure(
  image("images/A1/rnn-backpropagation.png", width: 100%),
  caption: "Fluxo do gradiente retropropagado do passo $t$ até o passo $k$"
)

=== A matemática dos gradientes explosivos ou desvanecentes
No entanto, essa estrutura pode gerar um grande problema quando a diferença $t-k$ é muito grande. Tomando como base a equação base da RNN $h_t = tanh(W_(h h) h_(t-1) + W_(x h) x_t)$, podemos calcular a derivada do estado oculto $h_j$ em relação ao estado oculto anterior $h_(j-1)$
$
  (partial h_j) / (partial h_(j-1)) = "diag"(1 - tanh^2(dot)) W_(h h)^T
$

então a propagação do gradiente de $h_0$ até $h_t$ envolve a multiplicação repetida de $t-k$ termos $W_(h h)^T$ e da derivada de $tanh$

Podemos chegar nesse mesmo resultado de uma forma mais matemática fazendo uma análise por SVD. Considere a decomposição SVD da matriz de transição $W_(h h) = U Sigma V^T$ e seja a parcial derivada do estado oculto $h_j$ em relação ao estado oculto anterior $h_(j-1)$ escrita como
$
  (partial h_j) / (partial h_(j-1)) = D_j W_(h h)^T
$

então sabemos que a derivada de $h_t$ com relação a um estado oculto anterior $h_k$ é dada por
$
  (partial h_t) / (partial h_k) = product_(j=k+1)^t D_j W_(h h)^T
$

vamos então medir a norma $L_2$ desse gradiente para entender como ele se comporta
$
  lr(||(partial h_t) / (partial h_k)||)_2 = lr(||product_(j=k+1)^t D_j W_(h h)^T||)_2
$

Pela propriedade submultiplicativa das normas matriciais $||A B||_2 <= ||A||_2 ||B||_2$, temos que:
$
  lr(||(partial h_t) / (partial h_k)||)_2 <= product_(j=k+1)^t ||D_j||_2 ||W_(h h)^T||_2
$

No entanto, temos que $||D_j||_2 = sigma_"max" (D_j) = max_(i) |1 - tanh^2(z_(j i))| <= 1$ e $||W_(h h)^T||_2 = sigma_"max" (W_(h h)^T)$, então
$
  &lr(||(partial h_t) / (partial h_k)||)_2 <= product_(j=k+1)^t 1 dot sigma_"max" (W_(h h)^T)      \

  => &lr(||(partial h_t) / (partial h_k)||)_2 <= (sigma_"max" (W_(h h)^T))^(t-k)
$

A conclusão que temos dessa análise é que, se o maior valor singular é menor que 1, então o gradiente vai decair exponencialmente com o aumento da diferença $t-k$, levando ao problema de *vanishing gradient*. Por outro lado, se o maior valor singular é maior que 1, então o gradiente vai crescer exponencialmente com o aumento da diferença $t-k$, levando ao problema de *exploding gradient*.

=== Métodos de mitigação
Para mitigar o problema de *exploding gradients* e *vanishing gradients*. A principal técnica utilizada é uma variação do BPTT.

*Truncated BPTT*: No BPTT original, para atualizar o pesos, eu faço o forward pass por TODOS os $T$ passos temporais e retropropago por eles novamente. Nessa versão simplificada, existem dois hiperparâmetros $k_1$ e $k_2$. Na parte do forward, a rede propaga por apenas $k_1$ passos temporais, e na parte do backward, a rede retropropaga por apenas $k_2$ passos temporais (obrigatoriamente $k_2 < k_2$). Isso reduz a profundidade da rede e ajuda a evitar o problema de gradientes explosivos ou desvanecentes.

#figure(
  image("images/A1/rnn-truncated-bptt.png", width: 70%),
  caption: "Exemplo de Truncated BPTT com k1=3 e k2=2"
)

== Limitações da RNN

Em RNN simples, ela consegue capturar contexto relevante de curto prazo, mas tem dificuldade em capturar dependências de longo prazo. Isso ocorre porque, à medida que a sequência se torna mais longa, o gradiente pode se tornar muito pequeno (vanishing gradient) ou muito grande (exploding gradient), dificultando o aprendizado de padrões de longo prazo. Por exemplo, na frace _"I grew up in france, [...] I speak fluent french"_ as palavras _france_ e _french_ estão separadas por várias palavras, e a RNN simples pode ter dificuldade em capturar essa relação de longo prazo.

Não só isso, como a RNN também pode ter dificuldade, mesmo em dependências de curto prazo, de selecionar a informação que é de fato relevante para aquele contexto

#figure(
  image("images/A1/rnn-limitation.png", width: 100%),
  caption: "Exemplo de limitação da RNN simples"
)

== Long-short Term Memory (LSTM)
Veio para corrigir as limitações presentes na RNN simples, introduzindo uma arquitetura de célula mais complexa que permite que a rede aprenda a manter ou esquecer informações ao longo do tempo.

Enquanto a RNN simples possui apenas um estado oculto $h_t$, a LSTM possui dois estados,um estado oculto $h_t$ e um estado de célula $c_t$ que atua como uma "esteira rolante" (*conveyor belt*) que carrega a informação relevante ao longo da sequência temporal com alterações mínimas.

#figure(
  image("images/A1/lstm.png", width: 74.9%),
  caption: "Arquitetura de uma célula LSTM"
)

Podemos estruturar a seguinte comparação: Na RNN Simples, tinhamos que $h_t$ era dado por
$
  h_t = tanh(W mat(h_(t-1);x_t))
$
enquanto na LSTM, temos que:
$
  mat(f;i;s;tilde(c)_t) = mat(sigma;sigma;sigma;tanh) W^T mat(h_(t-1);x_t)   \

  W = mat(W_f;W_i;W_s;W_c)   \

  c_t = f dot.o c_(t-1) + i dot.o tilde(c)_t   \

  h_t = s dot.o tanh(c_t)
$

Mas o que são esse bando de informação extra que a gente adicionou? Para controlar aquilo que entra, permanece e sai do estado celular $c_t$, a LSTM utiliza de três portas (*gates*), onde cada porta consiste em uma camada de *rede neural* com *ativação sigmoide* combinada com uma operação de multiplicação ponto a ponto (*pointwise*). As portas e componentes são dividos em

- *Porta de esquecimento (forget gate $f_t$)*: Quantidade de informação a apagar do estado celular passado
- *Porta do input ($i_t$)*: Quantidade de nova informação a adicionar ao estado celular
- *Valores candidatos ($tilde(c)_t$)*: Valores propostos para serem adicionados ao estado celular
- *Porta de saída/seleção ($s_t$)*: Quantidade do estado celular a revelar como saída no estado oculto


#pagebreak()

#align(center + horizon)[
  = Generative Adversarial Networks (GANs)
]

#pagebreak()
