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
    Revisão para A2
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
  = Autoencoders
]

#pagebreak()

== Introdução
No mundo real, os dados que recebemos são frequentemente incompletos, ruidosos ou de alta dimensionalidade. Então existe a necessidade de construir conhecimento a partir de dados imperfeitos. Um dos principais exemplos é a *falta de dados rotulados*. A maioria dos algoritmos de machine learning básicos necessitam que, pelo menos uma parte dos dados, possua rótulos e, a partir do padrão apresentado entre os dados rotulados, o modelo consegue *aprender*.

No âmbito específico de *modelos generativos*, como já comentamos na aula de GANs, partimos do pressuposto de uma *distribuição de probabilidade*, que gera os dados da vida real. No entanto, essa distribuição é desconhecida, complexa e de alta dimensionalidade. Para contornar esse problema, assumimos uma distribuição mais simples, chamada *distribuição latente*, que é mapeada para a distribuição de probabilidade dos dados reais com o intuito de aproximá-la. Então os modelos generativos tentam responder à pergunta:

#align(center)[
  _Como podemos aprender uma $p_"model"$ similar à $p_"dados"$_
]

Uma grande vantagem dessa abordagem é que, como temos o conceito de distribuição, podemos ensinar o modelo *a partir dos outliers*. Mas por que isso seria interessante? A lógica vem de que, como outliers são casos muito raros e de difícil identificação, se o modelo consegue entender bem essas situações, os casos mais comuns são identificados com extrema facilidade. Em um conjunto de imagens de trânsito, a maioria das imagens seriam em climas ensolarados, um trânsito calmo e tranquilo, no entanto, alguns edge cases como esses:

#figure(
  image("images/A2/edge-cases.png"),
  caption: [Edge case de imagens de trânsito]
)

== Autoencoders
Um Autoencoder é uma rede neural feed-forward projetada para redução da dimensionalidade dos dados e, a partir das features aprendidas na dimensionalidade reduzida, reconstruir os dados originais.

#figure(
  image("images/A2/autoencoder.png", width: 46%),
  caption: [Desenho de esqueleto de Autoencoder]
)

Antes de entrarmos nos conceitos mais modernos de Autoencoders, vamos ver alguns autoencoders que eram utilizados antes

=== PCA (Principal Component Analysis)
Não vamos entrar nos detalhes matemáticos do PCA, estes já foram abordados no _#link("https://github.com/Holy-Emapian-Scripture/holy-emapian-scripture/blob/main/5%20semestre/Machine%20Learning/Recaps/A3.pdf", "Resumo de Machine Learning A")_. Mas intuitivamente, ele reduz a dimensionalidade dos dados através dos seus valores singulares, pegando as features *mais informativas*. Ou seja, ele faz uma *projeção linear* dos dados.

#figure(
  image("images/A2/pca.png", width: 70%),
  caption: [Exemplo de PCA em 2D para redução de dimensionalidade para 1D]
)

=== AE (Autoencoder)
Já os autoencoders, tentam pegar as não-linearidades dos dados a partir das funções não-lineares das suas camadas, de forma que a loss que eles tentam otimizar foca em diminuir o quão distante os dados originais são dos gerados.
$
  cal(L)(W) = 1/N sum_(i) ||x_i - x'_i||^2 + lambda R(W)
$

A real é que não estamos interessados necessariamente nos dados gerados no output, mas sim no *bottleneck*, que é a camada de menor dimensionalidade no interior do autoencoder. Essa camada é a que contém as features mais informativas dos dados, e é a partir dela que podemos fazer *downstream tasks* como classificação, regressão, etc.

== Autoencoders Convolucionais
Esses possuem um foco em imagens, onde as features são reduzidas através de camdas convolucionais. Onde são reduzidas e geradas novamente para se aproximar da imagem original.

#figure(
  image("images/A2/convolutional-autoencoder.png"),
  caption: [Exemplo de Autoencoder Convolucional]
)

== Denoising Autoencoders
Os denoising autoencoders são uma variação de autoencoders onde as imagens inseridas no input são *corrompidas* com algum tipo de ruído. A ideia por trás disso vem de que, se o modelo consegue aprender a reconstruir imagens ruidosas, imagens mais limpas são reconstruídas com mais facilidade. Não só isso, mas o encoder fica robusto à ruídos, o que é interessante para *downstream tasks* como classificação, onde imagens ruidosas podem ser classificadas com mais facilidade.

#figure(
  image("images/A2/denoising-autoencoder.png"),
  caption: [Exemplo de Denoising Autoencoder]
)

Aqui, a loss é utilizada igual anteriormente, o ruído é aplicado apenas na entrada, assim o modelo não entende que o ruído é parte da imagem, mas sim que ele deve ser removido.

=== Speckel suppression in SAR Images
Os satélites de radar (SAR — *Synthetic Aperture Radar*) enviam pulsos de micro-ondas para a Terra e medem o sinal refletido. Devido ao fenômeno de interferência de ondas ao baterem no solo, a imagem gerada vem naturalmente com um ruído granulado chamado *speckle* (parece um "sal e pimenta" cobrindo a imagem).

#figure(
  image("images/A2/speckle-suppression.png", width: 100%),
  caption: [Exemplo de supressão de speckle em imagens SAR]
)

No entanto, como falamos antes, o denoising autoencoder *ainda necessita de imagens limpas* para a sua loss, no entanto, com imagens de satélite, não temos imagens limpas. O que fazer então? Nós partimos de um pressuposto, se uma imagem foi tirada em um dia específico do ano, a imagem do mesmo local $1$ dia depois (ou um período de tempo fixo determinado pelos cientistas) é *quase* a mesma imagem. Com essa premissa, assumimos que o ruído gerado em ambas as imagens é *aleatório* e *independente*, de tal forma que fazemos nossa rede receber a primeira imagem e tentar gerar a segunda. Isso remove o ruído justamente pela independência, fazendo com que a rede *não consiga aprender o padrão do ruído*, mas sim o padrão da imagem.

== Variational Autoencoders
Se relembrarmos do que vimos em GANs, com os geradores, conseguimos gerar imagens a partir de uma distribuição latente.

#figure(
  image("images/A2/gan-skeleton.png", width: 28%),
  caption: [Exemplo de esqueleto de GAN]
)

Nós temos a função $G: Z->X$ que gera as minhas imagens. No entanto, não possuímos $G^(-1): X->Z$. E porque essa função poderia ser interessante? Se tivéssemos essa função, poderíamos modificar $z$ para obter variações em características específicas da imagem/objeto desejado sujeitas à nossa vontade, por exemplo, mudar especificamente a cor dos olhos de uma pessoa.

#figure(
  image("images/A2/images-variations.png", width: 100%),
  caption: [Exemplo de variações de imagens geradas a partir de uma distribuição latente]
)

Vamos assumir por um momento que a distribuição das imagens $x$ advém de uma distribuição de uma variável latente $z$ que *não conseguimos observar*. Em um esquema rápido, ficaria estruturado da seguinte forma:

#figure(
  image("images/A2/vae-graph.png", width: 40%),
  caption: [Exemplo de esqueleto de VAE]
)

Nessa estrutura, algums métodos permitem estimar $p_theta (x|z)$, no entanto, estimar $p_theta (z|x)$ é *intratável*. A alternativa para isso, é utilizarmos uma distribuição *tratável* e *conhecida* $q_phi (z|x)$ e tentarmos, de alguma forma, aproximar $p_theta (z|x)$ com $q_phi (z|x)$.

Na arquitetura dos Variational Autoencoders, em vez de tentar determinar features do espaço latente, tentamos associar cada entrada da distribuição com os parâmetros da distribuição conhecida $q_phi (z|x)$. De forma que depois do ajuste de $phi$, geramos novos valores para a variável latente $z$ e, a partir da região do decoder (que representa $p_theta (x|z)$), conseguimos gerar novas imagens.

#figure(
  image("images/A2/vae-skeleton.png", width: 100%),
  caption: [Exemplo de esqueleto de VAE]
)

A loss dessa estrutura comprime dois termos principais
$
  cal(L)(theta, phi, x) = cal(L)_"rec" (theta, phi, x) + cal(L)_"reg" (phi)
$

o primeiro termo mede o quão bem o modelo consegue reconstruir a entrada, podemos usar, por exemplo:
$
  cal(L)_"rec" (theta, phi, x) = sum_(i) ||x_i - x'_i||^2
$

enquanto o termo de regularização mede o quão próximo a distribuição $q_phi (z|x)$ está da distribuição $p(z)$, que é a distribuição latente que assumimos. Para isso, podemos utilizar a divergência de Kullback-Leibler:
$
  cal(L)_"reg" (phi) = D_"KL" (q_phi (z|x) || p(z))
$
onde normalmente definimos $p(z)$ como uma distribuição normal multivariada padrão, ou seja, $p(z) = N(0, I)$. Essa regularização é importante pois o espaço latente deve ter duas características principais:
+ Continuidade: pequenas mudanças em $z$ devem resultar em pequenas mudanças em $x$.
+ Completude: qualquer ponto no espaço latente deve gerar uma amostra válida e com significado.

$
  D_"KL" (q_phi (z|x) || p(z)) = 1/2 sum_(j=1)^J (1 + log(sigma_j^2) - mu_j^2 - sigma_j^2)
$

Utilizar a distribuição normal encoraja o encoder a distribuir os pontos no centro do espaço latente e penaliza pontos que se formam em clusters longe do centro.

=== Treinamento
Agora o ponto principal, como fazemos para treinar um VAE? De início parece fácil. Temos nossa loss, basta fazer um backpropagation pelas suas camadas. No entanto, quando chegamos na camada de amostragem, temos um problema.

#figure(
  image("images/A2/vae-training.png"),
  caption: [Ilustração do problema de backpropagation em VAE]
)

O problema é que, como dito antes, nós precisamos amostrar da distribuição $q_phi (z|x)$, mas a amostragem não é diferenciável, então não conseguimos fazer backpropagation. A solução para isso é o *reparametrization trick*, onde ao invés de amostrar diretamente de $q_phi (z|x)$, nós amostramos de uma distribuição normal padrão e depois aplicamos uma transformação linear para obtermos a amostra desejada.

#figure(
  image("images/A2/reparametrization-trick.png"),
  caption: [Exemplo de reparametrization trick]
)

Acontece que, se amostrarmos $epsilon ~ N(0, 1)$, a variável latente $z$ pode ser reparametrizada como:
$
  z = mu + "diag"(Sigma) dot epsilon
$
de forma que isso é igual a amostrar $z$ diretamente de uma $N(mu, Sigma)$ com a vantagem de podermos diferenciar com relação aos parâmetros.

=== Geradores de Clima
Uma aplicação interessante de VAE é a geração de imagens de clima. Queremos gerar *Weather Fields*, que é uma representação multidimensional (espaço + tempo) de variáveis meteorológicas, como vento, temperatura, pressão, etc. sobre uma região.

#figure(
  image("images/A2/weather-fields.png", width: 60%),
  caption: [Exemplo de Weather Fields]
)

Meu objetivo é, de alguma forma, ter um controle sobre o tipo de clima que eu gostaria de gerar em uma região. É aí que entra a sacada. Com os VAE, já que eu forço a distribuição latente a ser uma distribuição normal multivariada, o VAE consegue concentrar os climas comuns no centro do espaço latente e os climas extremos (e raros) nas caudas da distribuição.

#figure(
  image("images/A2/weather-fields-latent-space.png", width: 75%),
  caption: [Exemplo de distribuição de climas no espaço latente]
)

Dessa forma, se eu quiser simular eventos comuns naquela região, eu posso amostrar do centro da distribuição, enquanto se eu quiser simular eventos extremos, eu posso amostrar das caudas da distribuição. Isso é bom também pois não precisamos definir exatamente o que significa ser raro, o próprio VAE aprende isso a partir da distribuição latente.

Utilizando de gráficos QQ, os cientistas conseguiram mostrar que as imagens geradas pelo VAE dos eventos extremos se aproximavam muito com os dados reais observados.

=== Realismo
Para melhorar o realismo das imagens, conseguimos fazer uma mistura de conceitos que já vimos, usando GANs em conjunto com VAE. A ideia é que o GERADOR do GAN é o DECODER do VAE e o DISCRIMINADOR do GAN é um classificador que tenta diferenciar imagens reais de imagens geradas pelo DECODER. Dessa forma, o DECODER é forçado a gerar imagens mais realistas para enganar o DISCRIMINADOR.

#figure(
  image("images/A2/vae-gan.png", width: 100%),
  caption: [Exemplo de VAE-GAN]
)


#pagebreak()

#align(center+horizon)[
  = Aprendizado de Similaridade
]

#pagebreak()

== Limitações de Classificadores
Tipicamente, quando a classificação envolve fitar o modelo em um conjunto de dados. No entanto, o modelo costuma pegar os padrões estruturais presentes naqueles dados. Por exemplo, se ele identifica imagens de animais, ele pode aprender que animais possuem olhos, patas, cauda, etc. No entanto, se ele for apresentado uma imagem do mesmo animal em posições diferentes, ele pode ter dificuldades de classificar corretamente.

#figure(
  image("images/A2/limitacao-classificadores.png", width:100%),
  caption: [Exemplo de limitação de classificadores]
)

Outra limitação que podemos citar é o retreino desnecessário. Se temos um banco de dados e queremos adicionar novas imagens ou uma nova classe para enriquecer meu modelo, será necessário *treiná-lo do zero* novamente.

== One-Shot Learning
Esse ramo de classificação tenta resolver o problema anterior. Nele, você tenta comparar duas imagens nunca vistas antes e determinar se elas são da mesma classe ou não. Ou seja, você não precisa fitar o modelo em um conjunto de dados, mas sim aprender a *comparar imagens*. Uma aplicação bem comum desse tipo de aprendizado é em Biometrias, como reconhecimento facial, onde você quer comparar a imagem de uma pessoa com a imagem que você tem no banco de dados para determinar se é a mesma pessoa ou não.

Uma forma mais simplificada utilizada em tarefas de visão computacional é tentar criar bijeções entre as imagens a partir de pontos específicos. A imagem a seguir exemplifica esse processo

#figure(
  image("images/A2/one-shot-learning.png", width: 65%),
  caption: [Exemplo de One-Shot Learning]
)

Em diante, vamos utilizar o problema de *reconhecimento facial* como exemplo para explicar os conceitos do resto desse capítulo

== Similarity Learning
Para contornar o problema da verificação, podemos trocar a estrutura do classificador! Podemos criar uma DNN que recebe duas imagens e retorna um valor entre 0 e 1, onde 0 significa que as imagens são diferentes e 1 significa que as imagens são iguais e utilizamos a loss da *Binary Cross Entropy* para treinar o modelo.

#figure(
  image("images/A2/similarity-learning.png", width: 100%),
  caption: [Exemplo de Similarity Learning]
)

Mas essa abordagem não faz com que a rede aprenda a *medir o quão parecidas as imagens são*. Para esse objetivo, entramos em dois pontos que esses modelos de similaridade devem atingir:

+ *Aprender Métrica de Distância*: Dependendo do problema, precisamos de uma métrica de distância diferente. Por exemplo, para reconhecimento facial, a distância euclidiana é suficiente, mas para reconhecimento de imagens médicas, a distância de Mahalanobis pode ser mais interessante. Esse é um tópico de pesquisa ativo, onde o objetivo é aprender a métrica de distância mais adequada para o problema. O ponto é que precisamos de uma função que assinale pontuações altas/baixas para imagens parecidas/diferentes.
+ *Aprender Representações*: A rede precisa aprender a extrair features das imagens que sejam importantes e se encaixem nas características da métrica abordada. Isso é, atualmente, razoavelmente fácil de se fazer com redes profundas, pois elas próprias conseguem aprender as features importantes de acordo com a tarefa.

Podemos resumir o aprendizado de similaridade em uma frase: *Aprender um espaço de embeddings $RR^k$ onde imagens de pessoas parecidas estão próximas e imagens de pessoas diferentes estão distantes*.

#figure(
  image("images/A2/embedding-space.png", width: 100%),
  caption: [Exemplo de espaço de embeddings]
)

Com isso em mente, podemos separar o processo de aprendizado em alguns passos

+ Precisamos encontrar um mapeamento $f: RR^n -> RR^k$ que mapeia as imagens de entrada do $RR^n$ para o espaço de embeddings $RR^k$. Precisamos aprender um mapeamento que satisfaça a característica de agrupamento citada anteriormente.
  #figure(
    image("images/A2/embedding-mapping.png", width: 100%),
    caption: [Exemplo de mapeamento para o espaço de embeddings]
  )

+ Agora é necessário escolher uma função de distância $d: RR^k x RR^k -> RR$ que mede a distância entre os embeddings. Essa função precisa ser escolhida de acordo com o problema, como citado anteriormente.
  #figure(
    image("images/A2/embedding-distance.png", width: 90%),
    caption: [Exemplo de função de distância no espaço de embeddings]
  )

+ Agora precisamos definir um *threshold* $tau$ que determina se duas imagens são da mesma classe ou não. Ou seja, se a distância entre os embeddings for menor que o threshold, as imagens são da mesma classe, caso contrário, são de classes diferentes.
  #figure(
    image("images/A2/embedding-threshold.png", width: 100%),
    caption: [Exemplo de threshold no espaço de embeddings]
  )

== Redes Siamesas
Redes siamesas é uma arquitetura de rede neural composta de duas redes *idênticas* que compartilham os mesmos pesos e parâmetros. O objetivo é que ambas as redes recebam uma imagem/entrada cada e realizem o mapeamento de $RR^n -> RR^k$. Depois que ambas fazem o mapeamento, tentamos medir o quão similares são os embeddings gerados. A ideia é que, se as imagens forem da mesma classe, os embeddings devem estar próximos, caso contrário, devem estar distantes.

#figure(
  image("images/A2/siamese-network.png", width: 100%),
  caption: [Exemplo de Rede Siamês]
)

Cada imagem vai gerar um gradiente diferente nos parâmetros da rede. Para que ambas fiquem idênticas. Nós calculamos ambos os gradientes separadamente e depois fazemos uma média deles para atualizar os pesos da rede. Dessa forma, ambas as redes ficam idênticas.

=== Constrastive Loss
A loss utilizada para treinar redes siamesas é a *Contrastive Loss*. Vamos construí-la aos poucos.

Se $A$ e $B$ forem a mesma pessoa, gostaríamos que a loss gerasse um valor baixo, ou seja, que a distância entre os embeddings fosse pequena.

#figure(
  image("images/A2/contrastive-loss-same.png", width: 100%),
  caption: [Exemplo de Contrastive Loss para imagens da mesma classe]
)

Se $A$ e $B$ forem pessoas diferentes, gostaríamos que a loss gerasse um valor alto, ou seja, que a distância entre os embeddings fosse grande. No entanto, não é interessante que a loss seja muito grande, pois isso faria com que o modelo tentasse aprender a identificar características muito distintas. Intuitivamente, é como se ambas as imagens fossem tão diferentes, que não faz sentido o modelo tentar aprender todas as diferenças, não contribuem para o aprendizado. Então definimos um *margin* $m$ que determina o quão distante os embeddings devem estar. Ou seja, se a distância entre os embeddings for maior que o margin, a loss não precisa aumentar mais.

#figure(
  image("images/A2/contrastive-loss-different.png", width: 100%),
  caption: [Exemplo de Contrastive Loss para imagens de classes diferentes]
)

Então dado que $t$ é uma variável indicadora que vale $1$ se as imagens forem da mesma classe e $0$ caso contrário, a loss final é definida como:
$
  cal(L) = t dot d^2 + (1 - t) dot max(0, m^2 - d)^2
$
onde $d$ é a distância entre os embeddings e $m$ é o margin. No problema de reconhecimento facial, $d$ costuma ser a distância euclidiana.

=== Weighted Double Margin Contrastive (WDMC) Loss
Muito parecida com a contrastive loss. No entanto, adicionamos a lógica anterior de pares diferentes em pares iguais também. A lógica é que, se as duas imagens forem *muito* parecidas, não faz sentido fazer com que o modelo perca tempo aprendendo diferenças mínimas. Então definimos duas margens, $m$ e $M$, uma para pares diferentes e outra para pares iguais.

#figure(
  image("images/A2/wdmc-loss-same.png", width: 100%),
  caption: [Exemplo de WDMC Loss]
)

Dessa forma, a loss final é definida, para um batch ${x_i^((1)), x_i^((2))}_(i=1)^N$, como:
$
  cal(L) = sum_(i) w_1 t_i max(0, d(x_i^((1)), x_i^((2))) - m^2) + w_2 (1 - t_i) max(0, M^2 - d(x_i^((1)), x_i^((2))))
$

=== Loss Tripla
Em vez de treinarmos em pares de imagens, podemos treinar em *trios* de imagens. Temos uma imagem de referência (Anchor $A$), uma imagem da mesma classe (Positive $P$) e uma imagem de classe diferente (Negative $N$). A ideia é que a distância entre o Anchor e o Positive seja menor que a distância entre o Anchor e o Negative. Ou seja, queremos que:
$
  d(A, P) < d(A, N)
$
logo, deixando mais restrito para uma margem $m$, queremos
$
  d(A,P) - d(A,N) < -m
$
então temos que
$
  cal(L) = max(0, d(A,P) - d(A,N) + m)
$

Para um batch ${A_i, P_i, N_i}_(i=1)^N$, a loss final é definida como:
$
  cal(L) = sum_(i) max(0, d(A_i,P_i) - d(A_i,N_i) + m)
$

A arquitetura vira um conjunto de 3 redes siamesas, uma para cada imagem, que compartilham os mesmos pesos e parâmetros. A loss é calculada a partir das distâncias entre os embeddings gerados pelas redes.

#figure(
  image("images/A2/triplet-loss.png", width: 100%),
  caption: [Exemplo de arquitetura para a Triplet Loss]
)

E para a fase de *testes*, utilizamos a estrutura com apenas duas redes siamesas, uma para a imagem de referência e outra para a imagem a ser comparada.

#figure(
  image("images/A2/triplet-loss-test.png", width: 80%),
  caption: [Exemplo de arquitetura para a Triplet Loss na fase de teste]
)

== Improving Similarity Learning

