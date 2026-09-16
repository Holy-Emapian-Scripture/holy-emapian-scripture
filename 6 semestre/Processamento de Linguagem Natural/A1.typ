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
    Processamento de Linguagem Natural
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
  = Estudo formal da linguagem natural
]

#pagebreak()

== Introdução
A linguagem natural é a forma de comunicação utilizada pelos seres humanos, que evoluiu ao longo do tempo e é caracterizada por sua complexidade, ambiguidade e capacidade de expressar ideias abstratas. O estudo formal da linguagem natural envolve a aplicação de métodos matemáticos e computacionais para analisar, modelar e compreender a estrutura e o significado das línguas humanas.

Em geral, existem alguns níveis de representação da linguagem natural que são estudados formalmente:
1. *Fonologia*: Estuda os sons da fala e como eles se organizam em sistemas fonológicos. A fonologia analisa os fonemas, que são as unidades mínimas de som que podem diferenciar significados em uma língua.
2. *Morfologia*: Analisa a estrutura das palavras e como elas são formadas a partir de morfemas, que são as menores unidades de significado. A morfologia estuda processos como a derivação, a flexão e a composição de palavras.
3. *Sintaxe*: Examina a organização das palavras em frases e sentenças, estabelecendo regras que determinam a ordem e a hierarquia das palavras. A sintaxe busca compreender como as estruturas gramaticais são formadas e como elas contribuem para o significado das sentenças.
4. *Semântica*: Foca na interpretação do significado das palavras, frases e textos. A semântica estuda como os significados são construídos a partir das combinações de palavras e como o contexto influencia a compreensão do significado

Nessa matéria, não focamos em nada da fonologia e ignoramos a maior parte da morfologia, mas estudamos a sintaxe e a semântica de forma formal, utilizando ferramentas matemáticas e computacionais para analisar e modelar a linguagem natural. Vamos nos concentrar na forma linguística no nível dos sintagmas e das sentenças. Isso significa que começaremos pelas palavras como blocos de construção básicos. A tarefa principal será então desenvolver uma gramática que nos forneça noções de boa-formação sintática e de estrutura sintática, e que nos permita desenvolver a noção de significado para as estruturas bem formadas. Assim, nossas gramáticas

- devem ser capazes de construir exatamente aquelas expressões que são bem formadas na língua de nossa escolha;
- devem determinar os constituintes das expressões linguísticas complexas, bem como sua estrutura interna;
- e devem nos permitir atribuir significados apropriados às expressões sintaticamente bem formadas, com base em sua estrutura;

Em outras palavras, a noção de boa-formação sintática nos permite determinar se uma expressão particular é de fato uma expressão bem formada de uma dada categoria, e determinar sua estrutura interna. A estrutura, por sua vez, ajudará a relacionar as formas linguísticas com o mundo extralinguístico

== Sintáxe, semântica e pragmática
É a trindade básica do estudo formal da linguagem natural. A sintaxe é o estudo da estrutura das sentenças, a semântica é o estudo do significado das sentenças e a pragmática é o estudo do uso da linguagem em contextos específicos. Juntas, essas três áreas fornecem uma compreensão abrangente de como a linguagem funciona e como ela é usada para comunicar ideias e informações.

É matéria de estipulação o que se toma como "forma" na língua natural. A seguir vamos nos concentrar na língua escrita, mais especificamente em sentenças bem formadas. Assim, olharemos para as línguas como conjuntos de cadeias de símbolos tomados de algum alfabeto.

Essa escolha torna particularmente fácil transpor a distância entre linguagens formais e línguas naturais, pois as linguagens formais também podem ser vistas como conjuntos de *cadeias*. A diferença entre línguas *naturais* e linguagens *formais* está na maneira como os conjuntos de *cadeias* são dados. No caso das linguagens formais, a linguagem é dada por definição estipulativa: uma cadeia pertence à linguagem se é produzida por uma *gramática* dessa linguagem, ou reconhecida por um *algoritmo de análise sintática* dessa linguagem. Um algoritmo de análise para a linguagem C, por exemplo, pode estar errado no sentido de não estar em conformidade com o padrão internacional da linguagem de programação C, mas em última instância não há certo ou errado aqui: a maneira como as linguagens formais são dadas é matéria de definição.

No caso das línguas naturais, a situação é bem diferente. Um formalismo gramatical proposto para uma língua natural (ou para um fragmento de uma língua natural) pode estar errado no sentido de não concordar com as intuições dos falantes nativos da língua. Se uma dada cadeia é ou não uma sentença bem formada de alguma língua é questão a ser decidida com base nas intuições linguísticas dos falantes nativos dessa língua.

== Saber "que" e "como"
As explicações de significado caem em duas classes amplas: significado como saber como e significado como saber que. Se dizemos que Joãozinho não sabe o significado de uma boa surra, referimo-nos ao significado operacional. Se Helen Keller escreve que water significa a coisa maravilhosa e fresca que corria sobre a sua mão, então ela se refere ao significado como referência, ou significado denotacional.

O significado denotacional pode ser formalizado como conhecimento das condições de verdade em situações. O significado operacional pode ser formalizado como algoritmos para executar ações (cognitivas). A semântica operacional de *mais* na expressão *sete mais cinco* é a operação de *somar dois números naturais*; essa operação pode ser dada como um conjunto de instruções de cálculo, ou como a descrição do funcionamento de uma máquina de calcular. A distinção entre semântica denotacional e semântica operacional é básica em ciência da computação, e muitas vezes há bastante trabalho envolvido em mostrar que as duas coincidem.

Frequentemente o significado operacional é mais fino que o denotacional. Por exemplo, as expressões sete mais cinco e duas vezes seis ambas se referem ao número natural doze, de modo que seu significado denotacional é o mesmo. Mas elas têm significado operacional diferente, pois a receita para somar sete e cinco é diferente da receita para multiplicar dois e seis

== Propósitos da comunicação
O objetivo mais elevado da comunicação é usar a língua como instrumento para a busca coletiva da verdade. Mas a língua é também um instrumento para fazer seus concidadãos acreditarem em coisas, ou para confundir seus inimigos. Mesmo que dois usuários da língua concordem em não se enganar, isso não exclui o uso da ironia.

Um uso muito importante da língua, e do qual nos ocuparemos bastante nas páginas seguintes, é como instrumento para descrever estados de coisas e como instrumento de raciocínio. Suponha que queiramos usar a língua para comunicar fatos básicos, como "o sol está brilhando", "está frio", "está chovendo", e assim por diante. Se você quiser negar um fato desses, precisa poder dizer algo como "não está frio". Você pode também querer exprimir sua incerteza sobre qual de dois fatos é o caso, e então gostaria de dizer "ou está frio ou está chovendo". Do mesmo modo, você pode querer dizer "está frio e está chovendo", ou: "se chover, então está frio". Assim, os ingredientes do tipo mais simples de comunicação são: fatos básicos, negações, conjunções, disjunções e implicações. Um fragmento de língua natural que só tenha isso já é bastante útil. De fato, a utilidade desse fragmento simples é evidente para os lógicos há muito tempo. O estudo do que pode ser expresso nesse fragmento chama-se lógica proposicional ou lógica booleana, em homenagem ao matemático britânico George Boole (1815–1864).

Pode-se dizer coisas interessantes com a lógica de predicados, ao menos se você souber usá-la, pois a lógica de predicados é muito expressiva. Veremos adiante que a lógica de predicados nos leva bem longe na expressão dos significados de enunciados de língua natural. Ainda mais expressiva é a lógica tipada de ordem superior, que também será usada extensivamente neste livro. Na lógica tipada você pode dizer coisas mais abstratas (mas ainda românticas) como "amar alguém como você me faz muito feliz". Por fim, ainda daremos uma olhada na lógica do conhecimento, ou lógica epistêmica. Isso lançará luz sobre o significado de enunciados como "não tenho certeza absoluta se ainda amo você". Ela também nos permitirá dar um quadro abstrato de como a comunicação por meio de enunciados declarativos leva ao crescimento do conhecimento, de maneiras sutis. Estudaremos o crescimento do conhecimento da audiência sobre o que o falante sabe, mas também o crescimento do conhecimento do falante sobre o conhecimento da audiência sobre o conhecimento do falante, e assim por diante.

Nosso objetivo último é formar um modelo adequado de partes de nossa competência linguística. Adequado significa que o modelo tem de ser realista em termos de complexidade e de aprendibilidade. Não seremos tão ambiciosos a ponto de afirmar que nosso relato espelha processos cognitivos reais, mas o que afirmamos é que nosso relato impõe restrições sobre a aparência que os processos cognitivos reais podem ter. No resto deste capítulo, vamos explorar os meios que nos ajudarão a cumprir esse objetivo.
