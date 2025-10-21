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

  Escrita:  Thalis Ambrosim Falqueto ]

#align(horizon + center)[
  #text(17pt)[
    Projeto e Análise de Algoritmos
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

#align(center + horizon)[
  = Técnicas de Projeto
]

#pagebreak()

== Método guloso (Greedy)

O método guloso é uma famoso paradigma utilizado para projetos de algoritmo, onde a estratégia consiste em escolher a cada iteração a opção com maior valor, e avaliar se deve ser adicionada ao resultado final.

Seguindo essa abordagem, as opções precisam ser ordenadas pro algum critério. Costuma ser simples e eficiente, porém nem todo projeto pode ser resolvido através dessa abordagem.

=== O problema do agendamento de tarefas


 Dado o conjunto de tarefas $T = {t_1, t_2, ... ,t_n}$ com $n$ elementos, cada uma com tempo de ínicio ```start [tk]```, e um tempo de término ```end [tk]```, encontre o maior subconjunto de tarefas que pode ser alocado sem sobreposição temporal.

#figure(
  caption: [Exemplo do problema de agendamento],
  image("images/agendamentoexample.png",width: 80%)
)


Vamos projetar a solução!

Perguntas: 
+ Quais serão as opções a serem avaliadas a cada iteração? 
  - Conjunto de tarefas que ainda não foi alocada ou descartada.
+ Qual critério iremos utilizar para ordenar as opções? 
  - Tempo de ínicio?
  - Menor duração?
  - Menor número de projetos?
  - Tempo de término?

Vamos analisar cada critério tentando construir ao menos um cenário que demonstre que o critério gera um resultado não-ótimo.

Que tal se colocarmos o critério de seleção como o tempo de início do agendamento?

#figure(
  caption: [Contra-exemplo para uma possível solução do problema de agendamento],
  image("images/agendamentoexruim1.png",width: 80%)
)

Isso não daria certo, pois nesse caso, por exemplo, o $t_5$ seria escolhido, enquanto a melhor escolha seria pegar as 4 primeiras tarefas.

E se escolhessemos pela menor duração?

#figure(
  caption: [Contra-exemplo para uma possível solução do problema de agendamento],
  image("images/agendamento-ex-ruim-2.png",width: 80%)
)

Isso também daria errado, já que escolheríamos $t_5, t_6 " e " t_7$ enquanto, novamente, a melhor escolha seriam os 4 primeiros.

Nada funcionou... Mas e se nosso critério fosse o tempo do término?

Ideia geral:

#pseudocode-list[
+ *ordene* $T$ (pelo tempo de término)
+ $T_a [1,...,n] = 0$ 
+ *Insira a primeira tarefa da lista* $t_0$ *em* $T_a$ 
+ $t_"prev" = t_0$
+ *para* $t_k$ *em* $T$:
  + *se* $"start"[t_k] >= "end"[t_"prev"]:$
    + *adicione* $t_k$ *em* $T_a$
    + $t_"prev" = t_k$
+ *retorne* $T_a$.
]

Essa ideia não é muito difícil. Como a lista é ordenada pelo horário de saída, então o primeiro elemento a ser adicionado é simplesmente o primeiro elemento. Note que, como o objetivo é apenas a quantidade máxima de tarefas, e não o tempo máximo que podemos otimizar para todas as tarefas que temos, então pegar o menor término *desde o início* é o que realmente faz o algoritmo funcionar (por exemplo, se tivéssemos os horários `[(5,10),(5,12)]`,
pegar o menor tempo de saída nos ajudaria no caso de termos outra tarefa, como `(11,14)`). 

Após selecionarmos a primeira tarefa da lista, basta compararmos os tempos de entrada das próximas tarefas, já que, pelo mesmo raciocínio do porque escolher a menor saída, se a próxima tarefa não colidir com a saída passada, então podemos pegar nossa nova tarefa e atulizar com o tempo de saída da nova tarefa atual (como a lista está ordenada pelo tempo de fim, a nova tarefa a ser pega garantiria que seria a melhor tarefa, já que seria a primeira que se encaixa com o tempo de finalização da última tarefa selecionada e a mais curta já que estamos olhando por ordenação).

Nosso pseudocódigo usa apenas um for sem nada demais dentro dele, mas precisamos ordenar a lista antes. Isso nos traz uma complexidade de $Theta(n log(n))$.

#figure(
  grid(
  columns: 2,
  column-gutter: 1em,
  image("images/tarefa-example.png", width: 95%),
  image("images/tarefa-example-correta.png", width: 95%),
),
  caption: [Solução para o problema de tarefas usando o algoritmo proposto]
)

*Por que essa solução é ótima?*

#definition[
  Escolha gulosa

  Uma solução ótima global pode ser atingida realizando uma sequência de escolhas locais ótimas (gulosas).
  - A escolha local não considera o resultado das escolhas posteriores, e produz um sub-problema contendo um número menor de elementos.
  - A definição do critério de escolha nos auxilia à organizar os elementos de forma que o algortimo seja eficiente.
]
#definition[ Sub-estrutura ótima

Ocorre quando uma solução ótima de um problema apresenta dentro dela soluções ótimas para sub-problemas.
]

#definition[ Swap argument (Argumento de troca)

Considere que temos uma solução ótima $S$, e a solução gulosa $G$. Então é possível substituir iterativamente os elementos de $S$ por elementos de $G$ sem que a solução deixe de ser viável e ótima, provando assim que $G$ é, no mínimo, tão boa quanto $S$.  
]

Vamos usar o que apredemos então:
===  NAO Sei 

=== O problema da mochila

Dado um conjunto de itens $II = {1,2,3,...,n}$ em que cada item $i in II$ tem um peso $w_i$ e um valor $v_i$, e uma mochila com capacidade de peso $W$, encontre o subconjunto $S subset.eq II$ tal que $sum_(i in S)^(|S|) alpha_i w_i <= W $ e $sum_(i in S)^(|S|) alpha_i v_i $ seja máximo, considerando que $0 < alpha_k <= 1$.

#figure(
  caption: [Tabela de exemplo para o exemplo da mochila],
  image("images/tabela-mochila.png",width: 40%)
)

#example[
  - W = 9
    - A escolha ${1,2,3}$ tem peso 8, valor 12 e cabe na mochila;
    - A escolha ${3,5}$ tem peso 11, valor 14 e *não* cabe na mochila 
    - A escolha ${3_"50%", 5_"100%"}$ tem peso 9, valor 11 e cabe na mochila
    - A escolha ${1_"100%", 3_"75%", 4_"100%"}$ tem peso 9, valor 16.5 e cabe na mochila

]

Seria possível criar um algoritmo capaz de encontrar uma solução ótima para esse problema?

- Pergunta 1: quais são as opções a serem avaliadas à cada iteração?
  - Itens (ou fragmentos de itens) que ainda não foram adicionados ou descartados.
- Pergunta 2: Qual critério iremos utilizar para ordenar as opções?
  - Menor peso? 
  - Menor valor?
  - Maior razão peso/valor?

Essa ideia de razão parece fazer sentido, já que podemos separar e  pegar a proporção que quisermos. Daí vem a ideia do algoritmo:

#pseudocode-list[

+ *Mochila* $ (I, v, w, n, W):$
  + *ordene* $I$ (pela razão valor/peso)
  + $C, i = W, 1$
  + $M[1,...,n] = 0$
  + *enquanto* $i <= n " e " C >= w_i$:
    + $M[i] = 1$
    + $C = C - w_i$
    + $i += 1$
  + *se* $i <= n:$
    + $M[i] = C/w_i$
  - *retorne* $M $
]

Onde $I$ é o conjunto de itens, $v$ o vetor de valores de cada item, $w$ o vetor de pesos de cada item, $n$ a quantidade de itens e $W$ é a capacidade máxima da mochila.

Analisando brevemente, ordenamos *descrescentemente* o vetor de itens $II$, e declaramos a variável $C$, de capacidade, e $i$, de índice. Criamos o vetor de zeros $M$ (de tamanho $n$), que é o vetor de porcentagem, referente a cada item. Note que como estamos ordenando pela proporção de valor por peso decrescentemente, pegar o primeiro item significa pegar o que item que mais vale a pena. Logo, o while serve para, enquanto couber a capacidade, pegara maior quantidade possível de valores. Quando o while quebra (no índice $i$), o algoritmo verifica se não chegou ao final, e, caso não tenha chegado, pega a proporção máxima da capacidade máxima restante sobre o peso, e retorna a lista de pesos ao final.

O mais complexo é a ordenação, que pode ser garantido com $Theta(n log(n))$. 

=== implementar em Python

== Dividir e Conquistar

O nome já diz muito, e esse paradigma é dividido em três etapas:

#wrap-it.wrap-content(
  
  figure(
    
    image("images/divide-and-conquer.png", width: 100%),
    
  ),
  [
    - Dividir o problema em um conjunto de sub-problemas menores.


    - Resolver cada sub-problema recursivamente.

  
    - Combinar os resultados de cada sub-problema gerando a solução.
    #v(6.5em)

    Figura 6: Exemplificação do paradigma Dividir e Conquistar. 
  ],
)

=== O problema de contagem de inversões 

Dado um problema com $n$ números, calcule o número de inversões necessário para torná-la ordenada.

#example[
  
  Considere a sequência `A = [3,7,2,9,5]`

  O número de inversões é 4: `(7,2),(3,2),(9,5),(7,5)`
]

A solução por força bruta seria verificar todos os pares, exigindo $Theta(n^2)$.

A solução baseada em dividir e conquistar deverá definir estratégias para resolver cada sub-problema do número de inversões, e depois juntar, claro. Podemos dividir a sequência em dois grupos com aproximadamente metade (O primeiro array até $n/2$, o segundo de $n/2 + 1$ até $n$). Essa operação é constante, portanto $O(1)$.

A estratégia de resolução deve contar o número de inversões de cada grupo:
#example[
#figure(
  caption: [Exemplo do problema da contagem de inversões],
  image("images/divide-and-conquer-example.png",width: 75%)
)

Esse resultado pode ser obtido executando o algoritmo recursivamente ($~ T(n/2)$). Claro que, por fim, teremos que contar as inversões da junção das duas listas: 

#figure(
  image("images/divide-and-conquer-example2.png",width: 40%)
)

Totalizando, assim, 18 inversões.
]

Ok, a ideia está concisa, mas como fazer essa junção? Se ordenarmos cada segmento, e "juntarmos" direto, conseguiríamos fazer isso de forma fácil. Voltemos ao exemplo após ordenar:

#figure(
  image("images/divide-and-conquer-example3.png",width: 70%)
)

Para a contagem de inversões para a junção, considere a sequências à esquerda de $L$ e à direita de $R$ e defina $i = 0$.

#pseudocode-list[
+ *para* $a_j$ *de* $R$:
  + *incremente* $i$ *até* $L[i] > a_j$
  + $"inv"_"aj"$ $= |L| - i$.
]

Com $"inv"_"aj"$ sendo a quantidade de inversões do elemento $a_j$ de $R$.

Para explicar, considere o exemplo da imagem anterior e relembre um pouco do algoritmo de ordenação MergeSort. Dado que as listas menores já estão ordenadas, se colocarmos um ponteiro no início de cada lista, digamos `l` e `r`, então basta verificar se $L[l] <= R[r]$, e incrementarmos $l$(ou $r$, dependendo da comparação).

Vamos continuar o exemplo (à princípio, pense que apenas juntamos as duas listas): 
  - Para `l = 0` e `r = 0`, temos $1 <= 3$, que é verdade. Incrementamos o `l`.
  - Para `l = 1` e `r = 0`, temos $2 <= 3$, que ainda é verdade. Incrementamos o `l`.
  - Para `l = 2` e `r = 0`, temos $4 <= 3$, que é mentira. Então, podemos aplicar o raciocínio: sabendo que todos os elementos após o $4$, como estão ordenados, são maiores ou iguais a $4$ e, portanto, também teriam que ser considerados como maiores do que 3, então do ínidice $l$ atual até $|L|$, uma inversão precisaria ser feita, se concatenássemos as duas listas. Logo, temos $|L| - l$ trocas a serem feitas a partir de $L[l]$. Isso explica o algoritmo para a contagem de inversões para a junção.

  Agora que resolvemos esse problema, podemos desenhar o algoritmo final:

#pseudocode-list[
+ *CountInversions* $(A):$
  + *se* $"len(A)" = 1:$
    + *retorne* $0$
  + *divida a lista em* $L$ e $R$
  + $i_l = "CountInversions"(L)$
  + $i_r = "CountInversions"(R)$
  + $L = "Sort"(L)$
  + $R = "Sort(R)"$
  + $i = "Combine (L, R)"$

  + *retorne* $i_l + i_r + i $
]

Avaliando a complexidade desse algoritmo, temos:

$
  T(n) = 2 T(n/2) + O (n log(n)) = O(n (log(n))^2)
$

O $O(n log(n))$ vem da ordenação das duas listas, e o $2 T(n/2)$ das duas listas que separamos. Os métodos de complexidade aprendidos na A1 nos levam a uma solução simples de $O(n(log(n))^2)$, já que sabemos que essa divisão pela metade traz um peso de $log(n)$.

Seria possível trazer uma otimização ainda maior? Sim, se eliminassemos a etapa de ordenação explícita. Podemos fazer isso se, no algoritmo de contagem de inversão, além de contar, invertessemos e realizassemos o merge, trazendo o array ordenado direto.

Novo algoritmo:

#pseudocode-list[

+ *CountInversions* $(A):$
  + *se* $"len(A)" = 1:$
    + *retorne* $0, A$
  + *divida a lista em* $L$ e $R$
  + $i_l , L= "CountInversions"(L)$
  + $i_r , R= "CountInversions"(R)$
  + $i = "Combine (L, R)"$
  + $A = "Merge"(L,R)$

  + *retorne* $(i_l + i_r + i), A $
]

Aqui, nós nos aproveitamos da recursão para fazer a ordenação, em vez de fazer isso por outro algoritmo. Dado que a recursão vai até quando só tivermos um elemento, e que sempre fazemos um merge, a lista está garantidamente sempre ordenada. Isso permite a execução do Combine sem problemas.

A função Combine é $O(n)$, já que apenas conta a quantidade de inversões que precisaríamos. A função Merge também é $O(n)$, já que apenas junta as duas listas. Portanto, temos:

$
  T(n) = 2 T(n/2) + O(n) = n log(n)
$

=== implementação em python

=== O problema de pares mais próximos

Dado uma sequência com n pontos em um plano, encontre o par com a menor distância euclidiana.

#wrap-it.wrap-content(
  
  figure(
    image("images/divide-and-conquer-example4.png", width: 100%),
    
  ),
  [
     A primeira solução que vem a cabeça é simplesmente testar cada par com cada outro par, trazendo uma complexidade de $O(n^2)$

     Como desenvolver uma solução melhor com o método que aprendemos?
    
    #v(2em)
     Figura 10: Exemplificação do problema de pares mais próximos
  ],
)

#grid(
  columns: (1fr, 1fr), 
  gutter: 1.5em,       
  [

    Podemos dividir o plano de forma que cada lado tenha aproximadamente o mesmo número de pontos (ordenando pelo eixo x).

    Em seguida, rresolva cada lado encontrando o par mais próximo recursivamente.  
  
    #v(1.5em)
    Figura 11: Exemplificação da solução do problema de pares mais próximos
  ],

  [
    #image("images/divide-and-conquer-example5.png", width: 100%)
  ]
)

