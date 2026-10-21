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
