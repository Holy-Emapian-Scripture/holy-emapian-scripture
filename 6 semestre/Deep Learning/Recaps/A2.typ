#import "@preview/ctheorems:1.1.3": *
#import "@preview/lovelace:0.3.1": *
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
Existem alguma forma de melhorar o aprendizado por similaridade. Alguns pontos que vamos abordar são:
+ *Melhorar a Loss*
+ *Melhorar a Amostragem*
+ *Ensenble Methods*

A parte de melhoria da loss nós já comentamos com as abordagens de diferentes loss anteriormente (mesmo que ainda existem falhas que vão ser apontadas)! Então vamos focar nos outros pontos.

=== Melhorar a Amostragem
Vamos nesse momento, dar um pouco de foco na forma de abordagem usando *triplas* de imagens. O problema de trabalhar com triplas, é que o número total de combinações possíveis em um conjunto com $n$ dados é da ordem de $n^3$. Ou seja, tanto você sintetizar todos esses trios, quanto você *treinar* com eles vai demorar bastante. Ainda existe o fato que, utilizando da triplet loss, *nem todos eles são úteis para o aprendizado*. Lembrando que para uma tripla específica:
$
  cal(L)(A,P,N) = max(0, d(A,P) - d(A,N) + m)
$
então o gradiente dessa função fica
$
  (dif max)/(dif x) = cases(
    0 &quad x <= 0,
    1 &quad x > 0
  )
$

ou seja, para triplas onde a seguinte condição é verdade:
$
  d(A,P) - d(A,N) + m <= 0
$
não vão contribuir para o aprendizado, pois o gradiente é zero!

#figure(
  image("images/A2/triplet-loss-gradient.png", width: 100%),
  caption: [Exemplo de gradiente da Triplet Loss]
)

Pela ilustração da imagem, queremos pegar exemplos *difíceis* ou *semi-difíceis*, pois eles geram os gradientes mais fortes para as losses. Um exemplo ingênuo de seleção de triplas, seria algo como:

#figure(
  kind: "algorithm",
  supplement: "Algoritmo",
  pseudocode-list[
    + selecionar triplas iniciais ${A_i, P_i, N_i}$
    + *enquanto* $"condição de parada" = "false"$ {
      + Treina por algumas épocas
      + Escolhe triplas difíceis ${A_j, P_j, N_j}$
    + }
  ]
)

As triplas podem ser selecionadas de forma offline (manualmente) ou online (automaticamente). Vamos tentar pensar em algum método pra seleção de triplas online.

A ideia é termos uma *árvore* de classes. Essa árvore vai servir como um *GPS* do dataset, agrupando as imagens por similaridade visual. Em vez de testar tudo contra tudo, a rede vai consultar essa árvore pra responder duas perguntas:
+ _Como garanto que o batch tenha classes variadas e não fique viciado em poucas classes repetidas?_
+ _Para cada imagem de *âncora*, onde estão os negativos que são difíceis de verdade, mas sem pegar ruído?_

#figure(
  image("images/A2/tree.png"),
  caption: [Exemplo de árvore de classes para seleção de triplas]
)

Vamos definir o processo de escolha na árvore antes de estabelecermos como ela deve ser construída. O algoritmo consiste em $3$ passos. O básico de conhecimento prévio que necessitamos é que, para cada *folha* da árvore, elas representam uma *classe*; e para cada *nó* da árvore, ele representa um *grupo de classes*.

#figure(
  pseudocode-list[
    + *function* select_triplets(tree, batch_size) {
      + seleciona $l'$ classes aleatórias da árvore (folhas)
      + *for each* âncora $A$ {
        + pego o positivo *mais longe* do âncora $A$ (dentro da mesma classe)
        + utilizo a árvore para achar as $k$ classes vizinhas mais próximas da classe do âncora $A$ e sorteio $t$ negativos
      + }
      + *return* batch montado $B in RR^(l' times k times t)$
    + }
  ],

  kind: "algorithm",
  supplement: "Algoritmo",
  caption: [Exemplo de algoritmo para seleção de triplas na árvore]
)

Agora que entendemos como e o porquê utilizamos a árvore, podemos compreender sua construção.

O primeiro passo para a construção da árvore, é a definição dos nó folha, onde cada um consiste em uma classe diferente do dataset. Depois, temos que definir a *between class distance*, que é a distância entre duas classes. Podemos utilizar, por exemplo:
$
  d(p,q) = 1/(n_p n_q) sum_(i in p) sum_(j in q) ||r_i - r_j||^2
$
onde $r_k$ é o embedding da imagem $k$ gerada pela rede neural.

Perfeito, agora precisamos definir uma medida de distância entre as imagens dentro da *mesma classe*, que chamaremos de *within class distance*. Podemos utilizar, por exemplo:
$
  d_0 = 1/C sum_(c=1)^C (1/(n_c^2 - n_c) sum_(i,j in c) ||r_i - r_j||^2)
$
onde $C$ é o número de classes e $n_c$ é o número de imagens da classe $c$.

Agora, vamos fazer, recursivamente do nível $l=0$ até $l=L$, uma *fusão* dos nós, de forma que os nós que satisfazerem um critério específico, vão ser unidos. Mas qual critério utilizamos?
$
  d_l = (l(4-d_0))/L + d_0
$
utilizamos dessa distância e, se duas classes possuem suas distâncias menores que $d_l$, elas são unidas. Esse processo se repete até o nível $l=L$.

=== Melhorar a Loss
Relembrando a nossa loss tripla, temos que:
$
  cal(L) = sum_(i) max(0, d(A_i,P_i) - d(A_i,N_i) + m)
$

O problema que temos nessa loss é que, por conta que a margem é fixa, muitas vezes, o modelo ignora triplas que podem ser de alguma forma úteis, seja por que a diferença da margem seja mínima, seja para exemplos mais difíceis mas que poderiam ajudar o modelo a compreender diferentes graus de parentesco entre as imagens ou variabilidade interna

#figure(
  image("images/A2/margin.png", width: 80%),
  caption: [Exemplo da margem excluindo triplas úteis]
)

A ideia é modificar a loss para que a margem fique dependente da distância entre a âncora e os exemplos negativos calculados na árvore hierárquica. Dessa forma, a loss final fica:
$
  cal(L) = sum_(i) max(0, d(A_i,P_i) - d(A_i,N_i) + m_i)
$

As distâncias mudam conforme o treino progride, logo, a árvore deve ser recalibrada a cada $k$ épocas.

=== Ensemble Methods (Divide and Conquer)
Estamos trabalhando com um problema de redes neurais gerarem funções de um espaço $RR^n$ para um latente $RR^d$, de forma que, no espaço latente, os objetos parecidos fiquem próximos e os diferentes fiquem distantes. No entanto, a noção de parecido e diferente é *multifacetada*. Considere o caso dos rostos humanos, por exemplo, temos *cor de pele*, *formato do rosto*, *cor dos olhos*, *formato do nariz*, *formato da boca*, etc. Fazer com que *um único modelo* aprenda todas essas características pode sobrecarregar ele e atrapalhar seu aprendizado. A ideia do *dividir e conquistar* é que, em vez de uma única rede, combinamos múltiplos *learners* que juntam suas soluções em um espaço latente unificado.

#figure(
  image("images/A2/ensemble-multiple-learners.png", width: 100%),
  caption: [Exemplo de Multiple Learners]
)

A primeira coisa que é feita é passar a imagem de entrada em uma CNN backbone *comum à todos os learners* (mesmos parâmetros em todos) que extrai as features brutas da imagem para que cada learner possa processar separadamente. Dos meus $K$ learners, cada um tem sua própria camada linear que projeta a saída dessa backbone em um subespaço latente de dimensão $d\/K$.

O algoritmo é dividido em duas fases, a *divisão* e a *conquista*. Na fase de divisão, temos $4$ passos principais:

+ *Agrupamento (K-means)*: tilizando o espaço de embedding atual, as amostras do dataset são divididas em $K$ clusters por meio do algoritmo $K$-Means. Cada cluster agrupa dados que compartilham noções de similaridade mais homogêneas (por exemplo, um cluster para picapes, outro para sedans, outro para SUVs)

+ *Definição dos $K$ Learners*: Criam-se $K$ learners, onde cada learner $k$ é composto pela CNN compartilhada $phi$ seguida pela sua projeção $f_k$ para dimensão $d/K$

+ *Treinamento Alternado*: Os aprendizes são treinados alternadamente:
  - O aprendiz $k$ é alimentado apenas com amostras do seu respectivo $k$-ésimo cluster.
  - Em cada retropropagação (backward pass), o gradiente atualiza os pesos da CNN compartilhada $phi$ e os pesos da camada linear local $f_k$.

+ *Reagrupamento Periódico*: Como a representação de $phi$ evolui com o treinamento, a cada $T$ épocas todos os dados são re-clusterizados no espaço de embedding global atualizado

Já na fase de *conquista*, temos $2$ passos principais:

+ *Fusão dos Aprendizes*: Após a convergência dos $K$ aprendizes, as representações parciais (de dimensão $d/K$) são unidas/concatenadas para recompor o espaço de embedding completo de dimensão $d$

+ *Ajuste Fino Global (Fine-Tuning)*: Realiza-se um *fine-tuning* da camada de embedding em todo o conjunto de dados para garantir a *consistência mútua* entre as representações geradas individualmente por cada aprendiz


#pagebreak()

#align(center+horizon)[
  = Aprendendo em Dados Não-Rotulados
]

#pagebreak()

== Motivação
Infelizmente, o mundo real é um lugar cruel. O acesso a dados rotulados é muito limitado e, a não ser que você utilize de um trabalho manual humano massivo, ter um dataset com *muitas amostras* e *todas rotuladas* é praticamente impossível. O mundo real é cheio de dados não rotulados, então precisamos nos adaptar a isso.

#figure(
  image("images/A2/espectro-de-supervisao.png"),
  caption: [Espectro de Supervisão]
)

== Deep Clustering
A ideia do Deep Clustering é transformar os meus dados em uma representação mais simples (latente) e aplicar algoritmos de clustering para agrupar os dados. Para isso, utilizamos de uma arquitetura com *encoder* e *decoder*, de forma que fazemos um aprendizado inicial para que essa rede possa gerar uma representação latente dos dados. Depois, aplicamos um algoritmo de clustering (K-Means, por exemplo) para agrupar os dados.

#figure(
  image("images/A2/deep-clustering-architecture.png"),
  caption: [Arquitetura do Deep Clustering]
)

=== Deep Embedding Clustering (DEC)
Essa abordagem é interessante, no entanto, existem algumas limitações. A principal delas, é o *hard assignment* do K-Means, que força os dados a serem agrupados em um cluster específico. Isso faz com que o modelo aprenda a gerar representações latentes que se encaixem nesse cluster, mesmo que ele não seja o mais adequado. O ideal é que a rede também aprenda a melhorar o espaço latente de acordo com os agrupamentos, e para isso ambas as etapas devem ser feitas *ao mesmo tempo*, utilizando da retropropagação. Queremos isso pois não queremos que a rede coloque viezes no espaço latente. Por exemplo, o modelo pode aprender que, todas as imagens com um *deserto* no fundo são de *camelos*, mas isso *não é verdade*, pois existem outros animais que vivem em desertos. O ideal é que a rede aprenda a gerar representações latentes que separem os camelos de outros animais, mesmo que eles estejam no mesmo ambiente.

Só que o *hard assignment* do K-Means não é diferenciável, então não conseguimos fazer retropropagação. A solução para isso é utilizar de um *soft assignment*, onde cada ponto tem uma probabilidade de pertencer a cada cluster, e essa probabilidade é diferenciável. Seja $z_i$ um ponto no espaço latente e $mu_j$ o centro do cluster $j$, a probabilidade de $z_i$ pertencer ao cluster $j$ é dada por:
$
  q_(i j) = (1 + ||z_i - mu_j||^2\/alpha)^(-(alpha+1)/2) / (sum_(j') (1 + ||z_i - mu_(j')||^2\/alpha)^(-(alpha+1)/2))
$

Perfeito! Pela lógica, se estamos estimando uma distribuição, precisamos de uma *distribuição alvo* para comparar com a distribuição estimada. No entanto, lembre-se que estamos mexendo em dados *não-rotulados*, então não temos uma distribuição alvo. E agora? O que fazemos?

A ideia é que *nós vamos criar nossa própria distribuição alvo*. A distribuição alvo é criada a *partir da distribuição estimada*, de forma que ela *reforce* os pontos que estão com alta probabilidade de pertencer a um cluster específico e *suaviza* os pontos que estão com baixa probabilidade. A distribuição alvo é definida como:
$
  p_(i j) = (q_(i j)^2 \/ f_j) / (sum_(j') q_(i j')^2 \/ f_(j'))    \

  f_j = sum_(i) q_(i j)
$

Elevar as probabilidades ao quadrado faz com que os pontos com alta probabilidade fiquem ainda mais altos, enquanto os pontos com baixa probabilidade fiquem ainda mais baixos. A divisão por $f_j$ faz com que a distribuição alvo seja *balanceada*, ou seja, que cada cluster tenha aproximadamente o mesmo número de pontos e evite que clusters muito grandes dominem a distribuição alvo. Dessa forma, a rede aprende a gerar representações latentes que se encaixem melhor nos clusters, enquanto os clusters são ajustados de acordo com as representações latentes.

Agora, com o *pseudo-gabarito* criado, podemos definir a loss como a divergência de Kullback-Leibler entre a distribuição estimada e a distribuição alvo:
$
  D_"KL" (P || Q) = sum_(i) sum_(j) p_(i j) log(p_(i j) / q_(i j))
$

#figure(
  image("images/A2/dce-architecture.png", width: 80%),
  caption: [Arquitetura do Deep Embedding Clustering]
)

O DCE pode então ser descrito em duas fases distintas:
+ *Pré-Treinamento*: Treina-se a rede para gerar representações latentes dos dados, utilizando de uma loss de reconstrução (por exemplo, MSE) para que o encoder possa gerar as representações úteis dos dados.
+ *Otimização*: Processo iterativo entre calcular a distribuição alvo $P$ e a distribuição estimada $Q$, e atualizar os pesos da rede para minimizar a divergência entre as duas distribuições.

=== Deep K-Means
No K-Means tradicional, tentamos minimizar a distância entre os pontos $z_i$ e seu centroide $C_j$. Seja $mu_j$ o centroide do cluster $C_j$, no K-Means, minimizamos a seguinte função de erro:
$
  cal(L) = sum_(k) II[z_k in C_j] dot ||z_k - mu_j||^2
$
o problema aqui é a variável indicadora $II[z_k in C_j]$, que não é diferenciável. Para solucionar isso, o Deep K-Means substitui a variável indicadora por uma *escala de temperatura softmax* $alpha$, de forma que quanto mais próximo o ponto $z_k$ estiver do centroide $mu_j$, maior será a probabilidade de pertencer ao cluster $C_j$. Essa função é dada por:
$
  G_j (z_k;alpha) = exp(-alpha ||z_k - mu_j||^2) / (sum_(j') exp(-alpha ||z_k - mu_(j')||^2))
$
Essa função é *diferenciável*. Definindo $f_theta: RR^N -> RR^D$ como o encoder, $g_theta: RR^D -> RR^N$ como o decoder, o Deep K-Means tenta minimizar a seguinte função de erro:
$
  L = sum_x L_"rec" (x) + lambda L_"clust" (x)    \

  L_"rec" (x) = ||x - g_theta (f_theta (x))||^2 wide L_"clust" (x) = sum_(k=1)^K G_k (f_theta (x);alpha) ||f_theta (x) - mu_k||^2
$

Dependendo do valor de $alpha$, a função de distância dos clusterings pode se comportar de forma diferente

- $alpha -> 0$: A função de distância se aproxima de uma distribuição uniforme, ou seja, todos os pontos têm a mesma probabilidade de pertencer a qualquer cluster.
- $alpha -> 1$: A função de distância se aproxima de um soft assignment cru, ou seja, a probabilidade de pertencer a um cluster é proporcional à distância do ponto ao centroide.
- $alpha -> infinity$: A função de distância se aproxima de um hard assignment, ou seja, cada ponto pertence a um único cluster.

O parâmetro é ajustado durante o treinamento (anneling), de forma que vai aumentando conforme o treino vai passando, fazendo com que as representações latentes posteriores se tornem mais certas de estarem próximas dos centróides corretos.

#figure(
  pseudocode-list(
    booktabs: true,
    title: [Deep K-Means Algorithm]
  )[
    + *function* DeepKMeans(data $cal(X)$, cluster's number $K$, balancing parameter $lambda$, scheme for $alpha$ epochs $T$, minibatches $N$, learning rate $eta$) {
      + *for* $alpha = m_alpha$ *to* $M_alpha$ *do* {
        + *for* $t = 1$ *to* $T$ *do* {
          + *for* $n=1$ *to* $N$ *do* {
            + Draw a minibatch $cal(X)_n subset cal(X)$
            + Update $(theta, cal(R))$ using SGD
          + }
        + }
      + }
    + }
  ],

  kind: "algorithm",
  supplement: "Algoritmo"
)

== Self-Supervised Learning
É uma forma de aprendizado onde os dados em si fornecem informações para a supervisão do aprendizado. Existe um panorama de aplicações e agrupamento pelos métodos que elas utilizam.

#figure(
  image("images/A2/self-supervised-learning-spectrum.png", width: 80%),
  caption: [Espectro de métodos de Self-Supervised Learning]
)

No entanto, essa abordagem encontra *muitos problemas* e *desafios* tanto práticos quanto teóricos dependendo da abordagem que está sendo implementada. Essas limitações são em grande parte superada nos próximos capítulos, mas vamos citar algumas delas:

- *Colapso de Representação (Representation / Dimensional Collapse)*: Sem rótulos externos para guiar o espaço latente, a rede pode encontrar "soluções triviais", mapeando todas as imagens para um vetor constante idêntico ou colapsando a representação em um subespaço de baixíssima dimensão.
- *Aprendizado de Atalhos (Shortcut Learning)*: O modelo pode aprender a resolver a tarefa pretexto explorando atalhos superficiais (como ruído de alta frequência, continuidade de bordas ou artefatos de textura) em vez de capturar conceitos semânticos abstratos reais.
- *Problema dos Falsos Negativos (False Negative Penalty)*: Em aprendizado contrastivo por pares (como o SimCLR), amostras distintas do mesmo batch são tratadas como pares negativos por padrão. Se duas imagens do batch pertencerem à mesma classe real (ex.: dois cachorros diferentes), o modelo é forçado incorretamente a afastar suas representações.
- *Custo Computacional e Batches Gigantescos*: Para garantir uma amostragem rica de negativos e estabilizar o treino, modelos contrastivos exigem mini-batches massivos (de 256 até 8192 amostras), demandando infraestruturas robustas de GPUs/TPUs e otimizadores específicos (como LARS).
- *Desconexão entre a Tarefa Pretexto e a Tarefa Final (Downstream Task Mismatch)*: As camadas finais adaptam-se fortemente ao objetivo pretexto (ex.: prever rotação ou pareamento), o que costuma exigir o descarte da camada de projeção (*projection head*) para aproveitar apenas as representações intermediárias.

== Constrative Learning
A ideia do aprendizado contrastivo é utilizar de data augmentation para aproximar as representações de imagens que são *semânticamente* semelhantes e afastar as representações de imagens que são *semânticamente* diferentes. Para isso, pegamos uma imagem (original), uma versão dela aumentada (positiva) e uma versão de outra imagem (negativa). A rede neural recebe a imagem original e a versão aumentada e tenta gerar representações latentes próximas, enquanto que a representação da imagem negativa deve ser distante.

#figure(
  image("images/A2/contrastive-learning-illustration.png", width: 70%),
  caption: [Ilustração do Aprendizado Contrastivo]
)

A rede é então trainada para maximizar a concordância (agreement) entre as representações de imagens *positivas* e repelir (repel) as representações de imagens *negativas*.

=== Simple Framework for Contrastive Learning of Visual Representations (SimCLR)
Esse framework se baseia em $4$ componentes sequenciais. Dada uma imagem $x$, aplicamos duas transformações (uma em cada) de uma família $cal(T)$ e gero duas versões transformadas $tilde(x)_i$ e $tilde(x)_j$. Depois, passamos essas imagens em uma CNN $f(dot)$ para gerar as representações latentes $h_i = f(tilde(x)_i)$ e $h_j = f(tilde(x)_j)$. Em seguida, passamos essas representações em uma *projection head* $g(dot)$, uma pequena rede MLP com uma camada oculta e ativação não-linear ReLU que projeta $h_i$ no espaço onde a *loss contrastiva* é calculada.
$
  z_i = g(h_i) = W^((2)) sigma(W^((1)) h_i)
$

É intuitivo pensarmos o porquê temos que adicionar essa *projection head*. Por que não fazer a loss já dentro do espaço latente $h_i$? A ideia é que, na nossa loss, vamos *forçar* com que as representações com transformações aplicadas sejam idênticas às originais, e para isso, utilizamos justamente a projection head para que a rede aprenda a perder informações irrelevantes para a tarefa de classificação. No entanto, posteriormente, podemos *descartar* a projection head e utilizar apenas o espaço latente $h_i$ para as tarefas downstream.

#figure(
  image("images/A2/simclr-architecture.png", width: 70%),
  caption: [Arquitetura do SimCLR]
)

#figure(
  image("images/A2/simclr-cycle.png", width: 60%),
  caption: [Ciclo do SimCLR]
)

A transformação inicial $cal(T)$ é composta por três augmentations simples sequenciais:
+ *Random Crop*: recorta aleatoriamente uma região da imagem e redimensiona para o tamanho original.
+ *Random Color Distortion*: aplica distorções de cor aleatórias, como ajuste de brilho, contraste, saturação e matiz.
+ *Random Gaussian Blur*: aplica um desfoque gaussiano aleatório à imagem, simulando variações de foco.

Nesse cenário, utilizamos a *Normalized Temperature-Scaled Cross Entropy Loss (NT-Xent)*, que é uma loss contrastiva baseada na entropia cruzada. Para um mini-batch de tamanho $N$, temos $2N$ amostras (cada imagem original gera duas amostras transformadas). As outras $2(N-1)$ amostras são tratadas como *negativas*. A loss para uma amostra positiva $(i,j)$ é definida como:
$
  cal(l)_(i j) = -log (exp("sim"(z_i, z_j) / tau) / (sum_(k=1)^(2N) II_[k != i] exp("sim"(z_i, z_k) / tau)))
$
onde $"sim"$ representa a similaridade entre os vetores $z_i$ e $z_j$, tipicamente calculada como a similaridade cosseno, e $tau$ é um hiperparâmetro de temperatura que controla a suavidade da distribuição de probabilidade. A loss final é a média sobre todos os pares positivos no mini-batch:
$
  L = 1/(2N) sum_(k=1)^N [cal(l)_(2k-1, 2k) + cal(l)_(2k, 2k-1)]
$

A lógica nessa loss, é que ao minimizar a loss, estamos maximizando a *similaridade* entre *representações positivas* e, por consequência, o *denominador* da loss, que representa a soma das similaridades entre a amostra positiva e todas as amostras negativas, é minimizado. Ou seja, estamos maximizando a *discrepância* entre *representações negativas*.

#figure(
  pseudocode-list(
    booktabs: true,
    title: [SimCLR Algorithm]
  )[
    + *function* SimCLR(data $cal(X)$, batch size $N$, constant $tau$, structure of $f$,$g$ e $cal(T)$) {
      + *for* ${x_k}_(k=1)^N subset cal(X)$ {
        + *for all* $k=1$ *to* $N$ {
          + draw two augmentation functions $t, t' ~ cal(T)$
          + First Agumentation:
          + $tilde(x)_(2k-1) = t(x_k)$
          + $h_(2k-1) = f(tilde(x)_(2k-1))$
          + Second Agumentation:
          + $z_(2k-1) = g(h_(2k-1))$
          + $tilde(x)_(2k) = t'(x_k)$
          + $h_(2k) = f(tilde(x)_(2k))$
          + $z_(2k) = g(h_(2k))$
        + }
        + *for all* $i=1$ *and* $j=1$ *to* $2 N$ {
          + $s_(i j) = z_i^T z_j \/ (||z_i|| ||z_j||)$
        + }
        + *define* $cal(l)(i, j)$ *as* $-log (exp(s_(i j) \/ tau) \/ (sum_(k=1)^(2N) II_[k != i] exp(s_(i k) \/ tau)))$
        + *define* $cal(L)$ *as* $1/(2N) sum_(k=1)^N [cal(l)(2k-1, 2k) + cal(l)(2k, 2k-1)]$
        + *update* $f$ *and* $g$ *to minimize* $cal(L)$
      + }
      + *throw away* $g$
      + *return* $f$
    + }
  ],

  kind: "algorithm",
  supplement: "Algoritmo"
)

=== Aprendizado por Protótipos e Proporção de Rótulos (LLP)
Agora vamos pensar no cenário onde não temos os valores de rótulos das imagens, mas sabemos a proporção de cada classe dentro de um conjunto de imagens. Por exemplo, temos um conjunto de imagens com $1000$ imagens, e sabemos que $30%$ são cachorros, $50%$ são gatos e $20%$ são pássaros. A ideia é que, mesmo sem saber quais imagens são de qual classe, podemos utilizar essa informação para guiar o aprendizado da rede neural.

A ideia inicial já vimos, utilizar de *contrastive learning* para aprender boas representações latentes das imagens. No entanto, o SimCLR necessita de batches enormes e não cria grupos, só afasta ou aproxima as representações. É aí que entra a nova abordagem do SwAV.

#figure(
  image("images/A2/swav-illustration.png"),
  caption: [Ilustração do Aprendizado por Protótipos e Proporção de Rótulos (SwAV)]
)

Em vez de apenas as features, o SwAV utiliza de *protótipos*. Utilizamos $K$ protótipos $C = {c_1,...,c_K}$. O modelo aprende que as duas versões da mesma imagem devem cair no mesmo protótipo.

#figure(
  image("images/A2/simclr-vs-swav.png"),
  caption: [SimCLR v.s SwAV]
)

O modelo SwAV consiste em um algoritmo de 5 passos:

#figure(
  image("images/A2/data-augmentation.png", width: 50%),
  caption: [Highlight da parte de Data Augmentation do SwAV]
)

- *Data Augmentation*: Para cada imagem $x$, aplicamos duas transformações aleatórias $tilde(x)_1$ e $tilde(x)_2$ da família de augmentations $cal(T)$, gerando duas versões aumentadas da mesma imagem.

#figure(
  image("images/A2/projections.png", width: 50%),
  caption: [Hightlight da parte de Projeções do SwAV]
)

- *Extração de Features*: Extraímos as features das imagens aumentadas utilizando uma CNN $f(dot)$, resultando em representações latentes $h_1 = f(tilde(x)_1)$ e $h_2 = f(tilde(x)_2)$. Como comportamente desejável, também tentamos limitar os valores das features pra ficarem dentro da esfera unitária.

#figure(
  image("images/A2/prototypes.png", width: 50%),
  caption: [Hightlight da parte de Prototypes do SwAV]
)

- *Formação de Protótipos*: Utilizamos as representações latentes para formar protótipos usando de *transporte ótimo*. Dadas $B$ amostras $z_1, z_2, ..., z_B$, e os $K$ protótipos $c_1,...,c_K$, defina a matriz $Z$ onde a $j$-ésima coluna é a representação latente $z_j$ e a matriz $C$ onde a $k$-ésima coluna é o protótipo $c_k$, então $C^T Z in RR^(K times B)$ guarda as *similaridades cosseno*. Com isso definido, precisamos de uma matriz $Q in RR^(K times B)$ que responda a seguinte pergunta: _Qual protótipo é o mais próximo de cada amostra?_ Para isso, definimos a seguinte otimização:
  $
    Q^* = "argmax"_(Q in cal(Q)) "Tr"(Q^T C^T Z) + epsilon H(Q)
  $
  o traço faz com que pesos maiores sejam assinalados para similaridades maiores, e a entropia faz com que a distribuição de pesos seja mais uniforme. Também limitamos os valores que $Q$ pode assumir:
  $
    cal(Q) = {Q in RR^(K times B) | Q 1_B = 1/K 1_K, Q^T 1_K = 1/B 1_B}
  $
  ela obriga as amostras a se dividirem igualmente entre os protótipos. Sem ela, a solução trivial seria todo mundo no mesmo cluster. $epsilon$ controla o quanto a entropia vai suavizar a distribuição de pesos. A otimização é feita utilizando o algoritmo *Sinkhorn-Knopp* e da uma solução *aproximada fechada* para a matriz $Q$
  $
    Q^* = "diag"(u) exp(C^T Z / epsilon) "diag"(v)    \

    "diag"(u) = Q 1_B wide "diag"(v) = Q^T 1_K
  $
  É nessa etapa que utilizamos das *proporções dos rótulos* para contribuir no aprendizado. Implementamos isso *modificando a restrição de equipartição*. Definimos o vetor $w$ que tem as proporções de cada classe e modificamos a restrição de equipartição para:
  $
    cal(C) = {Q in RR^(K times B) | Q 1_B = w, Q^T 1_K = 1/B 1_B}   \

    w = (w_1, w_2, ..., w_K)^T wide sum_(k=1)^K w_k = 1
  $
  a ideia é que os clusters gerados vão ser proporcionais aos rótulos que temos e podemos associar cada cluster a uma classe específica com base na proporção.

#figure(
  image("images/A2/loss-swav.png", width: 50%),
  caption: [Hightlight da parte de Loss do SwAV]
)

- *Swapped Prediction*: Cada view que geramos vai tentar prever o code da outra. A ideia é que, se $z_t$ e $z_s$ são duas views da mesma imagem, então a distribuição de protótipos $q_t$ e $q_s$ devem ser semelhantes. Definimos então a probabilidade de que a view $z_t$ pertença ao protótipo $c_k$ como:
  $
    p_(t k) = PP(z_t in c_k) = exp(z_(t)^T c_k \/ tau) / (sum_(k') exp(z_(t)^T c_k' \/ tau))
  $
  e a swapped loss como
  $
    cal(l) (z_t, q_s) = - sum_(k=1)^K q_(s k) log p_(t k)   \

    L = 1/B sum_(b=1)^B [cal(l) (z_t, q_s) + cal(l) (z_s, q_t)]
  $

- *Otimização*: O último passo é otimizar a loss final $L$

#figure(
  pseudocode-list(
    booktabs: true,
    title: [SwAV Algorithm]
  )[
    + *function* SwAV(data $cal(X)$, classes proportion $w$, epochs $T$, $epsilon > 0$) {
      + *for* $t = 1$ *to* $T$ {
        + *for each* $x_i$ *in* $cal(X)$ {
          + Generate two random views $X_(i)^(t, s)$
          + Obtain the feature vectors $Z_(i)^(t, s)$
          + Compute the prototype scores $C^T Z_(i)^(t, s)$
          + Compute the codes $Q_i^(t, s)$ through Sinkhorn constrained to $w$
          + Convert prototype scores to probabilities $P_i^(t, s)$
          + Compute the swapped loss $L_i^(t, s) = -(Q_i^t log(P_i^s) + Q_i^s log(P_i^t))$
          + Update $theta$ and $C$ with a gradient step to minimize $L_i^(t, s)$
          + Normalize prototypes $C$
        + }
      + }
    + }
  ],

  kind: "algorithm",
  supplement: "Algoritmo"
)

== Aprendizado com Rótulos Ruidosos
Não bastando a dificuldade de anotar rótulos em dados reais, ainda existe o fator mais comum em tudo que fazemos nas nossas vidas, o *erro humano*. Em aplicações reais, pode acontecer comumente de que os rótulos anotados por humanos *esteja incorreto*.

=== SELFIE
No nosso dataset, cada amostra $x$ tem um *rótulo verdadeiro* $y$ (que não conhecemos) e um *rótulo anotado* $tilde(y)$ (que é o que temos). O rótulo $tilde(y)$ é *ruidoso* quando $y != tilde(y)$. Definimos também a taxa de ruído $eta$ como a *probabilidade de um rótulo ser incorreto* $tau = PP(tilde(y) != y)$. Um modelo padrão possui o seguinte passo de atualização dos parâmetros em um minibatch:
$
  theta_(t+1) = theta_t - alpha nabla_theta 1/(|B|) sum_(x in B)^B cal(L)(f_theta (x), tilde(y), theta_t)
$
No entanto, dentro do SELFIE, fazemos a seguinte otimização:
$
  theta_(t+1) = theta_t - alpha nabla (1/(|cal(R) union cal(C)|) (sum_(x in cal(R)) cal(L)(x, y^"refurb"; theta_t) + sum_(x in cal(C) inter cal(R)^(-1)) cal(L)(x, tilde(y); theta_t))
$

Aqui, a ideia é dividir o dataset em três grupos, as amostras confiáveis ($cal(C)$), as que dá para consertar ($cal(R)$) e as que não da pra confiar (são descartadas). Então utilizamos apenas as amostras confiáveis e as que foram consertadas e atribuídas com um novo rótulo $y^"refurb"$. No entanto, precisamos responder ainda três perguntas:

*Como escolher $cal(C)$?:* Utilizamos do *Lowest loss-based separation method*, onde selecionamos as $tau dot 100%$ amostras com menor loss. A ideia é que, quando a loss é alta, significa que o modelo não está entendendo que aquele dado pertence naquela classe, então provavelmente o rótulo está incorreto. O $tau$ é empírico ou estimado por validação cruzada.

#figure(
  pseudocode-list(
    booktabs: true,
    title: [SELFIE Algorithm],
  )[
    + *function* SELFIE(data $cal(D)$, epochs $T$, $gamma$ warm-up, noise rate $tau$, uncertainity threshold $epsilon$, history length $q$, how many times the model will restart $r$) {
      + $cal(R)^"tot" <- emptyset$
      + *for* $r=1$ *to* $r$ {
        + $p <- 1$
        + Initialize $theta_p$
        + *for* $t=1$ *to* $T$ {
          + *for* $j=1$ *to* $|cal(D)|\/|cal(M)|$ {
            + Draw minibatch $M subset D$
            + Warm-up periods:
            + *if* $i <= gamma$ {
              + $theta_(p+1) = theta_p - alpha nabla(1/(|cal(M)|) sum_(x in cal(M)) cal(L)(x,tilde(y);theta_p))$
            + } *else* {
              + $cal(C) <- (1-tau) dot 100%$ of low loss samples in $cal(M)$
              + $cal(R) <- emptyset$
              + *for each* $x$ *in* $cal(M)$ {
                + *if* $F(x,q) <= epsilon$ *or* $x in cal(R)^"tot"$ {
                  + $cal(R) <- cal(R) union (x, y^"refurb")$
                + }
              + }
              + $cal(R)^"tot" <- cal(R)^"tot" union cal(R)$
              + $theta_(p+1) = theta_p - alpha nabla(
                1/(|cal(R) union cal(C)|) (
                  sum_(x in cal(R)) cal(L) (x, y^"refurb";theta_p) + sum_(x in cal(C) inter cal(R)^(-1)) cal(L)(x, tilde(y);theta_p)
                )
              )$
            + }
          + }
        + }
        + $p <- p+1$
      + }
      + *return* $theta_p$, $cal(R)^"tot"$
    + }
  ],

  kind: "algorithm",
  supplement: "Algoritmo"
)

*Como escolher $cal(R)$?:* Para cada amostra do modelo, guardamos o histórico $H_x (q)$ das últimas $q$ previsões do modelo. Definimos então a *probabilidade* de que o rótulo correto seja $j$ dado que minha amostra é $x$ e que eu fiz $q$ predições como:
$
  PP(j | x, q) = (sum_(tilde(y) in H_x (q)) II[tilde(y) = j]) / (|H_x (q)|)
$
ou seja, a proporção de vezes que o modelo previu a classe $j$ para a amostra $x$. Definimos então a *incerteza* dessa previsão como a *entropia normalizada* dessa distribuição que acabamos de definiir:
$
  F(x;q) = (1/delta) "entropy"(PP(y | x, q))    \

  "entropy"(PP(y | x, q)) = - sum_(j=1)^C PP(j | x, q) log PP(j | x, q)   \

  delta = - sum_(j=1)^C (1/C) log (1/C)
$
onde o $delta$ serve para normalizar e a incerteza ficar entre $0$ e $1$. Com essas definições, finalmente podemos criar a definição de *o que é uma amostra consertável*. Definimos uma amostra como *refurbishable* quando a incerteza preditiva ($F$) é tal que:
$
  F(x;q) < epsilon quad (0 < epsilon < 1)
$

*Como corrigir as amostras consertáveis?:* Para as amostras com rótulos erados, vamos assinalar os rótulos *que o modelo mais previu dentro do histórico de $q$ predições*.
$
  y^"refurb" = "argmax"_(1<=j<=C) PP(j | x, q)
$

== Aprendizado Fracamente Supervisionado
Vamos supor que temos um conjunto de dados com $N$ amostras. Vamos supor também que nos foi dada a tarefa de aplicar um modelo de *segmentação semântica* no meu conjunto. Parece uma tarefa tranquila! Mas quando você vai olhar os dados, eles não tem máscaras que indicam a posição real dos objetos, mas sim, pontos onde os objetos ficam... E agora? Será que existe uma forma de ainda fazer um modelo que aprende o formato dos objetos mesmo que meu ground truth seja só o ponto do centro do objeto e mais nada? É aí que entra o aprendizado fraco supervisionado.

#figure(
  image("images/A2/weakly-supervised-comparison.png", width: 67.1%),
  caption: [Gráfico comparativo da saída do teste em função da complexidade do rótulo fornecido]
)

O ponto do aprendizado fracamente supervisionado é você utilizar rótulos *menos informativos* do que a tarefa que você vai resolver exige.

=== Class Activation Mapping (CAM)
Como exemplo de modelo que utiliza dessa abordagem, o CAM se destaca bastante. Ele utiliza apenas de labels anotadas e como saída gera um *bouding box* que indica a posição do objeto na imagem.

A técnica utilizada é treinar uma rede de classificação e, dentro dos seus feature maps, localizar *onde* ela olhou para gerar o rótulo de classificação.

#figure(
  image("images/A2/cam-architecture.png", width: 90%),
  caption: [Arquitetura do CAM]
)

Vamos definir $w_k^c$ como o peso que liga o mapa $k$ à classe $c$ na camada de classificação. Ou seja, ele dita o quão importante aquela *feature* específica influencia na decisão de classificar a imagem como pertencente à classe $c$. Definimos também $f_k (i, j)$ como o valor do feature map $k$ na posição $(i, j)$ *antes* do *global average pooling* (GAP). Defina também $F_k = sum_(i, j) f_k (i, j)$, de forma que o score da classe $C$ na sa´ida softmax é dada por
$
  S_c = sum_k w_k^c F_k = sum_k w_k^c sum_(i, j) f_k (i, j) = sum_(i, j) sum_k w_k^c f_k (i, j)
$
Se pegarmos a parte interna da soma e chamarmos de $M_c (i, j) = sum_k w_k^c f_k (i, j)$, então $M_c (i, j)$ representa a importância da feature na posição $(i, j)$ para a classe $c$, então posições com $M_c$ alto puxam a probabilidade da classe $c$ para cima.

Para selecionar a bouding box, pegamos a região $M_c (i, j)$ maior que $20$% do valor máximo de $M_c (i, j)$ e escolhemos a componente conexa maior. Essa região é a nossa bouding box. Fazemos isso para as $5$ classes mais prováveis.

== Aprendizado Semi-Supervisionado
Imagine agora que nós temos um conjunto com várias imagens e precisamos fazer uma detecção de objetos (aplicar bouding boxes e ver onde estão os objetos). Começamos com os dados sem rótulo nenhum, mas isso não é problema! Você tirou algum tempo e criou as bouding boxes reais de algumas imagens, mas são muitas... Será que da pra aproveitar o pouco que você fez e ainda sim conseguir prever do resto que você ainda não tem rótulo? É aí que entra o aprendizado semi-supervisionado.

#figure(
  image("images/A2/semi-supervised-learning.png", width: 90%),
  caption: [Tipos de aprendizado]
)

=== FixMatch
O artigo do FixMatch diz que ele é simplesmente a unificação de dois conceitos já bastante aplicados:
+ *Regularização por consistência:* o modelo deve dar predições parecidas para versões perturbadas da mesma imagem;
+ *Pseudo-rotulagem:* o próprio modelo gera rótulos artificiais para os dados sem rótulo, e depois treina com eles.

Ela gera duas versões, uma com augmentation fraca (por exemplo flip e pequenos deslocamentos) e outra com augmentation forte (distorções agressivas de cor e forma). A versão fraca passa pelo modelo e produz uma predição. Se essa predição for confiante, vira um pseudo-rótulo. A versão forte passa pelo mesmo modelo, e a cross-entropy $H(p,q)$ força a predição da versão forte a coincidir com o pseudo-rótulo.

#figure(
  image("images/A2/fixmatch-architecture.png", width: 90%),
  caption: [Arquitetura do FixMatch]
)

A intuição é que a versão fraca é mais fácil, então a predição dela é mais confiável. Ela ensina a versão forte, que é difícil de classificar. Assim o modelo aprende a ser invariante a perturbações pesadas.

A loss geral é a soma de duas
$
  L = cal(l)_s + lambda cal(l)_u
$
$cal(l)_s$ é a loss sobre os meus dados rotulados com augmentation fraca, e $cal(l)_u$ é a loss sobre os meus dados não rotulados com augmentation forte. Em questão de notação, considere $alpha$ como a função de augmentation fraca e $cal(A)$ como a função de augmentation forte.
$
  cal(l)_s = 1/B sum_(b=1)^B H(p_b, p_m (y|alpha(x_b);theta))    \

  cal(l)_u = 1/(mu B) sum_(b=1)^(mu B) II[max(p_m (y|alpha(u_b);theta))] >= tau] H(hat(p_b), p_m (y|cal(A)(u_b);theta))
$

#figure(
  pseudocode-list(
    booktabs: true,
    title: [FixMatch Algorithm]
  )[
    + *function* FixMatch(labeled batch $cal(X) = {(x_b, p_b): b = 1, ..., B}$, unlabeled batch $cal(U) = {(u_b): b = 1, ..., mu B}$, confidence threshold $eta$, unlabeled data ratio $mu$, unlabeled loss weight $lambda_b$) {
      + $cal(l)_s = 1/B sum_(b=1)^B H(p_b, p_m (y|alpha(x_b);theta))$
      + *for* $b=1$ *to* $mu B$ {
        + Strong augmentation in $u_b$:
        + $tilde(u)_b = cal(A)(u_b)$
        + $q_b = p_m (y|alpha(u_b);theta)$
      + }
      + $cal(l)_u = 1/(mu B) sum_(b=1)^(mu B) II[max(q_b) >= tau] H("argmax"(q_b), tilde(u)_b)$
      + *return* $cal(l)_s + lambda_b cal(l)_u$
    + }
  ],

  kind: "algorithm",
  supplement: "Algoritmo"
)


#pagebreak()

#align(center+horizon)[
  = Self-Attention
]

#pagebreak()

== Introdução
Um conceito amplamente estudado pela psicologia é a capacidade que o ser humano tem de *prestar atenção apenas naquilo que lhe interessa*. Um belo exemplo já documentado é o *Efeito Coquitel* (cocktail effect), onde em uma festa com muito barulho, conseguimos prestar atenção em uma conversa específica e ignorar o resto.

Com base nesse conceito de atenção, será que conseguimos fazer com que redes neurais consigam prestar atenção apenas em informações relevantes para uma determinada tarefa? A resposta é sim, e é aí que entra o conceito de *Self-Attention*. Resumidamente, podemos definir a atenção como *um conjunto de pesos que diz o quanto cada parte da entrada importa*.

No entanto, a atenção vai muito além, por conta do que chamamos de *contexto*. Dependendo de *o que está no input* e *como está organizado*, os pesos associados para cada parte da entrada pode mudar. Vamos tomar como exemplo a frase _"I swam across the river to get to the other side of the bank"_. A nossa tarefa é classificar qual é o significado da palavra _bank_ na frase. A palavra _bank_ pode significar _banco_ ou _margem do rio_, e para descobrir qual é o significado correto, precisamos olhar para o contexto da frase.

#figure(
  image("images/A2/self-attention-illustration.png", width: 90%),
  caption: [Ilustração do Self-Attention]
)

Nesse caso, podemos ver como as palavras _swam_ e _river_ são mais importantes para determinar o significado da palavra _bank_, enquanto que as palavras _get_ e _other_ são menos importantes. Ou seja, a atenção é *contextual*, e depende de *o que está no input* e *como está organizado*.

Outro bom exemplo é a utilização de mecanismos de atenção em *séries temporais*. Dada uma série temporal ruidosa $x = [x_1, x_2, ..., x_n]$, $w=[w_j]$ é um vetor de pesos e queremos utilizar do mecanismo de atenção para *remover a influência dos ruídos*. Para isso, podemos modificar nossos pesos de forma que, quanto mais distante esteja o valor da série do meu $i$ atual, menor sua influência

#figure(
  image("images/A2/self-attention-time-series.png", width: 100%),
  caption: [Ilustração do Self-Attention em séries temporais]
)

== Self Attention para Processamento de Linguagem Natural
A ideia aqui é de transformar nossas palavras em uma representação vetorial, que permite realizar operações e comparações. Por um exemplo, nessa forma vetorial, poderiamos fazer algo do tipo:
$
  "King" - "Man" + "Woman" = "Queen"
$
Melhor ainda, utilizando dessas representações vetoriais, podemos aplicar operações para contribuir com *mais contexto* para minha palavra. Vamos tomar por exemplo as seguintes frases:
- _A manga da minha camisa sujou_
- _Tirei uma manga do pé ontem e comi na salada de frutas_

Aqui, se transformássemos manga em uma representação vetorial, ela seria a mesma para as duas frases. No entanto, o contexto da frase é diferente, e a palavra _manga_ tem significados diferentes. Então utilizando de pesos e operações entre as representações vetoriais de cada uma das palavras, seria possível obter uma representação vetorial diferente para cada uma das palavras _manga_ dependendo do contexto da frase. Nesse cenário, por exemplo, o peso que liga _manga_ com _camisa_ sera *muito forte*, pois a palavra manga contribui para indicar o significado da palavra _manga_ na frase.

Dentro dos nossos mecanismos, precisamos de uma ferramenta para medir a similaridade entre o embedding de duas palavras. Para isso, vamos utilizar do produto escalar (dot product) entre os embeddings das palavras. A intuição aqui é que o *tamanho* do vetor indica a força semântica dele, enquanto a direção indica o significado. Se dois vetores são grandes e estão próximos, o seu produto interno vai ser grande, e o contrário se eles forem muito diferentes.

=== Mecanismo Inicial
Vamos imaginar um mecanismo bem básico dado tudo que falamos. Vamos pensar numa frase com $4$ palavras (podem ser $n$). Eu quero saber o peso de importância para o significado da *palavra $3$* na frase (que foi transformada no vetor $v_3$), ela é a chamada *query*. Eu faço então o produto interno com cada uma das outras palavras da frase (que foram transformadas nos vetores $v_1$, $v_2$, $v_3$ e $v_4$), que são as chamadas *keys*. O resultado do produto interno é um vetor de pesos não normalizados $s = [s_1,...,s_4]$. Eu então normalizo esses pesos (com a normalização $"softmax"$) para que fiquem entre $0$ e $1$ e somem $1$.

#figure(
  image("images/A2/self-attention-mechanism.png", width: 60%),
  caption: [Ilustração do mecanismo inicial de Self-Attention]
)

Então fazemos uma multiplicação entre pesos normalizados e os vetores das palavras (que são as chamadas *values*), e somamos o resultado. O resultado final é um vetor que representa a palavra $3$ com mais contexto, pois ele leva em consideração o significado das outras palavras da frase.

Resumidamente e de forma mais matemática e genérica, podemos resumir dessa forma:
+ Conjunto de embeddings de palavras: $V={v_1,...,v_n}$
+ Palavra de interesse: $v_i$
+ Fazemos o produto interno de $v_i$ com cada um dos embeddings (inclusive o próprio embedding da query) de palavras:
  $
    S_i = (s_(i 1),...,s_(i n): s_(i j) = v_i^T v_j)
  $
+ Pegamos os pesos gerados e normalizamos:
  $
    W_i = (w_(i 1),...,w_(i n): w_(i j) = exp(s_(i j)) / (sum_(k=1)^n exp(s_(i k))))
  $
+ Geramos os novos embeddings contextualizados a partir dos pesos
  $
    y_i = sum_(j=1)^n w_(i j) v_j
  $

Algo interessante de fazermos nesse momento é formalizar isso tudo em notações matriciais! Isso vai ajudar a gente a entender todos os conceitos mais complexos e notações matemáticas posteriores.

Se nosso conjunto de embeddings de palavras é $V={v_1,...,v_n}$, podemos organizar esses vetores em uma matriz $V in RR^(n times d)$, onde cada linha é um embedding de palavra. Com essa notação, podemos obter uma matriz $S$ tal que:
$
  S = V V^T =

  mat(
    -,v_1^T,-;
    ,dots.v,-;
    -,v_n^T,-
  )

  mat(
    |,,|;
    v_1,...,v_n;
    |,,|
  )

  =

  mat(
    v_1^T v_1,...,v_1^T v_n;
    dots.v,dots.down,dots.v;
    v_n^T v_1,...,v_n^T v_n
  )

  =

  mat(
    s_(1 1),...,s_(1 n);
    dots.v,dots.down,dots.v;
    s_(n 1),...,s_(n n)
  )
$

Dessa forma, a matriz $S$ é uma matriz de similaridade entre os embeddings das palavras. Cada elemento $s_(i j)$ representa a similaridade entre a palavra $i$ e a palavra $j$ e a linha $k$ da matriz $S$ representa a similaridade da palavra $k$ com todas as palavras da frase (com ela mesma inclusa). Depois aplicamos $"softmax"$ na matriz $S$ para obter a matriz de pesos $W$ (linha a linha).
$
  W = mat(
    w_(1 1),...,w_(1 n);
    dots.v,dots.down,dots.v;
    w_(n 1),...,w_(n n)
  )
$
Por fim, obtemos as novas representações enriquecidas com contexto multiplicando a matriz de pesos $W$ pela matriz de embeddings $V$:
$
  Y = W V
$
onde a linha $i$ de $Y$ é $y_i^T = sum_(j=1)^n w_(i j) v_j^T$

Perceba, no entanto, o problema desse mecanismo inicial. Ele não possui *pesos aprendíveis*, ou seja, não permite que minha máquina aprenda!

=== Mecanismo Aprendível
Perceba que nesse nosso mecanismo, tanto os *values*, quanto os *keys* e as *queries* são os mesmos embeddings das palavras. Mas seria interessante que a máquina conseguisse modificar todos esses valores de acordo com o que ela aprendeu. Para isso, vamos criar três matrizes de pesos aprendíveis $M_Q in RR^(d times d)$, $M_K in RR^(d times d)$ e $M_V in RR^(d times d)$, além de renomear a nossa matriz de embeddings $V$ para $X$. Dessa forma, podemos definir as matrizes das seguintes formas:
- *Queries*: $Q = X M_Q$
- *Keys*: $K = X M_K$
- *Values*: $V = X M_V$
Aplicando essas matrizes de peso, conseguimos fazer com que nosso modelo possa aprender o que é mais importante para o contexto da palavra, e não apenas utilizar do embedding da palavra como estava sendo feito anteriormente. A partir disso, podemos reescrever a equação de atenção como:
$
  S = Q K^T = X M_Q M_K^T X^T   \

  W = "softmax"(S / sqrt(d))   \

  Y = W V = "softmax"(S / sqrt(d)) X M_V
$
Aqui, o fator $1/sqrt(d)$ é utilizado para evitar que os valores do produto interno fiquem muito grandes, o que poderia prejudicar a normalização com $"softmax"$ e o gradiente na hora de treinar o modelo.

#figure(
  image("images/A2/self-attention-learnable.png", width: 60%),
  caption: [Ilustração do mecanismo de Self-Attention Aprendível]
)

A ideia de duas matrizes de pesos diferentes, é que a matriz de *keys* e a matriz de *queries* podem aprender diferentes representações da mesma palavra, dependendo do contexto. Por exemplo, em uma frase, podemos ter a palavra _ferramenta_ e a palavra _martelo_. A palavra _martelo_ está *fortemente* ligada com a palavra ferramenta, mas a palavra _ferramenta_ pode não está tão fortemente ligada, pois existem *vários tipos de ferramenta*. Ou seja, não temos uma relação de pesos *simétrica*, e é por isso que precisamos de duas matrizes de pesos *diferentes*, de forma que $S$ não seja simétrica.

=== Multihead Self Attention
Quando estamos tratando de *linguagem natural*, é muito normal que, dentro de uma frase, a mesma palavra esteja associada de *formas diferentes* com a *mesma palavra*. Vamos pegar por exemplo a frase _"She had already eaten the apple"_. Para se ter uma boa representação de *eaten*, temos que prestar atenção em *duas coisas*:
- A relação gramatical ligada ao tempo verbal _had_ (junto com _eaten_, indica passado perfeito, uma ação que aconteceu antes de outra ação no passado);
- A relação semântica ligada ao objeto _apple_ (o que foi comido);

Só que isso são dois padrões distintos que dão pesos diferentes à palavras diferentes. O que fazer então? Se lembra que em redes convolucionais, utilizávamos vários filtros para características diferentes? Um para narizes, outro para bocas, e assim vai? Aqui é a mesma ideia, vamos utilizar *mútiplas* "cabeças" de atenção, cada uma com seus próprios pesos aprendíveis. Suponha que tenhamos $H$ cabeças de atenção indexadas de $h=1,...,H$ da seguinte forma:
$
  H_h = "Attention"(Q_h, K_h, V_h) = "Softmax"((Q_h K_h^T) / sqrt(d)) V_h   \
$

Aqui porém, nós geramos uma única matriz concatenada de todas as nossas cabeças de atenção, e aplicamos uma matriz de pesos aprendível $M_O$ para gerar a saída final:
$
  Y = "Concat"(H_1,...,H_H) M_O
$
onde temos que $"Concat"(H_1,...,H_H) in RR^(N times H dot d)$, $M_O in RR^(H dot d times d)$, logo, $Y in RR^(N times d)$

#figure(
  image("images/A2/multihead-self-attention.png", width: 50%),
  caption: [Concatenação para obter $Y$]
)

== Transformers
Introduzidos no famoso paper do Google _"Attention is All You Need"_, traz uma arquitetura de modelo desenvolvido para *tradução de textos*. A arquitetura é composta de dois blocos principais, o *encoder* e o *decoder*. O encoder é responsável por gerar uma representação vetorial do texto de entrada, enquanto o decoder é responsável por gerar a tradução do texto de entrada para o texto de saída. Na @transformer-architecture, o bloco da esquerda é o *encoder* e o da direita é o *decoder*. Em ambos os blocos é utilizada das camadas de *multihead attention*. Dando um focono encoder, podemos ver algumas branches residuais, que, como já discutimos anteriormente, ajudam a evitar o problema de *vanishing gradient*. Algo interessante de se notar é que ao receber os embeddings do input, aplicamos nele o chamado *positional encoding*, que é uma forma de adicionar informação de posição para o modelo, pois, como já discutimos, a atenção é *contextual*, e a posição das palavras na frase é importante para o significado da frase. Fazemos algo como:
$
  v'_i = v_i + p_i
$
onde $v_i$ é o embedding da palavra $i$ e $p_i$ é o encoding de posição da palavra $i$. Existem várias formas de se definir $p_i$, pode ser uma função fixa, pode ser aprendido, ou até *ignorado*.

#figure(
  image("images/A2/transformer-architecture.png", width: 60%),
  caption: [Arquitetura do Transformer]
)<transformer-architecture>

Já o decoder segue a mesma linha, no entanto, ele recebe os outputs anteriores e, no final, retorna as probabilidade de qual será a próxima palavra a ser adicionada na frase. Ele também utiliza de *multihead attention*, mas com uma diferença, ele utiliza de *masked attention*, que é uma forma de impedir que o modelo olhe para as palavras futuras na hora de gerar a próxima palavra. Isso é feito para evitar *vazamento de informação*.

== Transformers vão substituir RNNs?
Podemos citar logo de cara algumas limitações que as RNNs possuem e que os Transformers não possuem:
- *Paralelização*: RNNs são sequenciais, ou seja, para processar a palavra $i$, precisamos processar todas as palavras anteriores. Já os Transformers podem processar todas as palavras de uma vez, o que permite uma paralelização muito maior.
- *Longo Alcance*: RNNs possuem dificuldade em capturar dependências de longo alcance, ou seja, quando a palavra $i$ depende de uma palavra muito distante na frase. Já os transformers, dado poder computacional suficiente, teoricamente, tem uma janela de captura de dependência *infinita*, ou seja, a palavra $i$ pode depender de qualquer palavra na frase, independente da distância.

Ainda podemos utilizar de RNNs em tarefas menores, mas para tarefas maiores e mais complexas, os Transformers trazem muitas vantagens em cima das RNNs.

== Stand-Alone Self Attention
Introduzido no paper _"Stand-Alone Self-Attention in Vision Models"_, o Stand-Alone Self Attention (SASA) é um novo tipo de camada desenvolvida para *visão computacional*. Vimos em CNNs que, para capturar dependências espaciais que estão, de certa forma, distantes, utilizamos algumas gambiarras, como as atrous convolutions, que aumentam o tamanho do campo receptivo sem aumentar o número de parâmetros. No entanto, isso não é suficiente para capturar dependências espaciais mais complexas. O SASA utiliza de *multihead self attention* para capturar dependências espaciais de forma mais eficiente.

Vamos dar uma revisada rapidinho em como funciona a convolução em si. Dado um input (imagem) $V in RR^(H times W times d_"in")$ e um filtro $W in RR^(k times k times d_"in")$, o output $y_(i j) in RR$ é dado por
$
  y_(i j) = sum_(|a-i| <= floor(k/2), |b-j| <= floor(k/2)) W_(i - a, j-b)^T V_(a b)
$

#figure(
  image("images/A2/convolution.png", width: 80%),
  caption: [Ilustração da convolução]
)

A convolução faz isso para todo $i$ e $j$.

#figure(
  image("images/A2/convolution-2.png", width: 80%),
  caption: [Ilustração da convolução]
)

Em texto, todas as palavras podem se relacionar com as outras, mas aqui, nós vamos selecionar apenas uma região $k times k$ para cada pixel $v_(i j) in RR^(d_"in")$. Chamamos essa região de *bloco de memória* e denotamos como $cal(N)_k (i,j)$. Definimos então a saída $y_(i j) in RR^(d_"out")$ como:
$
  y_(i j) = sum_((a, b) in cal(N)_k (i,j)) "softmax"(Q_(i j)^T K_(a b)) V_(a b)    \

  Q_(i j) = W_Q^T v_(i j)    \

  K_(a b) = W_K^T v_(a b)    \

  V_(a b) = W_V^T v_(a b)
$

onde $W_Q, W_K, W_V in RR^(d_"in" times d_"out")$.

No entanto, na fórmula acima, a soma sobre a janela não sabe onde cada vizinho está. Se você embaralhar os pixels da janela, *o resultado é o mesmo*. Uma convolução não tem esse problema, porque cada posição da janela tem o seu próprio peso. Por isso é preciso informar a posição de alguma forma. A solução é então adicionar um termo $p_(a-i,b-j)$ que depende da posição relativa do pixel vizinho $(a,b)$ em relação ao pixel central $(i,j)$. A equação final fica então:
$
  y_(i j) = sum_((a,b) in cal(N)_k (i,j)) "softmax"[Q_(i j)^T (K_(a b) + p_(a-i,b-j))] V_(a b)
$


#pagebreak()

#align(center+horizon)[
  = Visual Foundation Models (Visual FM)
]

#pagebreak()


