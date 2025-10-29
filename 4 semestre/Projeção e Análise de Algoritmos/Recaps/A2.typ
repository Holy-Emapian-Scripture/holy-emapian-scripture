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
Vamos usar o que aprendemos então:

Seja $T_a = {g_1, g_2, ..., g_k}$ o conjunto de $k$ tarefas selecionadas pelo nosso algoritmo guloso, já ordenadas pelo tempo de término (como no pseudocódigo).
Seja $S = {s_1, s_2, ..., s_m}$ uma _solução ótima_ qualquer, com $m$ tarefas, também ordenadas por tempo de término.

Nosso objetivo é provar que $T_a$ é ótima, ou seja, que $k = m$.

Queremos primeiro provar que a primeira escolha gulosa, $g_1$, pode fazer parte de _alguma_ solução ótima.

+ $g_1$ é a tarefa escolhida por nosso algoritmo, então ela é a tarefa em _todo_ o conjunto $T$ com o _menor tempo de término_.
+ $s_1$ é a primeira tarefa da solução ótima $S$. Ela tem o menor tempo de término _dentro de $S$_.

Por definição, como $g_1$ tem o menor tempo de término de _todas_ as tarefas, seu tempo de término deve ser menor ou igual ao de $s_1$:

$ "end"[g_1] <= "end"[s_1] $

Agora, vamos comparar $g_1$ e $s_1$.

+ _Caso 1:_ $g_1 = s_1$.
  Se a primeira tarefa da solução ótima $S$ é a mesma da solução gulosa $T_a$, então $S$ já começa com a escolha gulosa.

+ _Caso 2:_ $g_1 != s_1$.
  Vamos "trocar" $s_1$ por $g_1$ na solução ótima $S$. Considere uma nova solução $S'$:
  $S' ={g_1, s_2, s_3, ..., s_m\} $
  Precisamos verificar se $S'$ ainda é uma solução viável (sem sobreposições).
  - Como $S$ era uma solução viável, todas as suas tarefas eram compatíveis. Sabemos que $s_2$ devia começar após $s_1$ terminar: $"start"[s_2] >= "end"[s_1] $.
  - Mas, como vimos na Etapa 1, $"end"[g_1] <= "end"[s_1] $.
  - Combinando os fatos, temos que $"start"[s_2] >= "end"[g_1] $.
  - Isso significa que $g_1$ não se sobrepõe a $s_2$, e o resto das tarefas ($s_3, ...$) também não, pois já eram compatíveis com $s_2$.
  
A nova solução $S'$ é, portanto, viável. O mais importante é que $S'$ tem $m$ tarefas, o _mesmo tamanho_ da solução ótima $S$. Isso significa que $S'$ _também é uma solução ótima_.

Concluímos que _sempre_ existe uma solução ótima (seja $S$ ou $S'$) que começa com a primeira escolha gulosa $g_1$.
Podemos repetir esse processo indutivamente. Em cada passo $i$, trocamos $s_i$ por $g_i$, transformando a solução ótima $S$ na solução gulosa $T_a$, sem nunca diminuir o número de tarefas, usando sub-estruturas ótimas.
Isso só é possível se as duas soluções tiverem o mesmo tamanho desde o início. Portanto, $k = m$.

Logo, a solução gulosa $T_a$ é, de fato, uma solução ótima.

*Implementação em Python:*

```py
def scheduling_problem(tasks):  
    if len(tasks) == 0:                               #caso de contorno
        return 0

    sorted_by_end = sorted(tasks, key= lambda x:x[1]) #ordena pelo término
    choosed_tasks = []
    choosed_tasks.append(sorted_by_end[0]) 
    t_prev = sorted_by_end[0]

    for task in sorted_by_end[1:]:                    #começa depois da primeira
        if task[0] >= t_prev[1]:                      #tempo maior que o de saída
            choosed_tasks.append(task)
            t_prev = task
    return choosed_tasks, len(choosed_tasks)          #retorna lista, quantidade
```

=== O problema da mochila fracionária

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

*Implementação em Python:*

```py 
def fractional_bag_problem(I, v, w, max_w):
  n = len(I)                            #as três listas têm o mesmo tamanho   
  idx_w_ratio = []
  for i in range(n):
      ratio = v[i]/w[i]
      idx_w_ratio.append((i, w[i], ratio))#lista que armazena o índice, peso e razão
                                        #ordena por razão logo abaixo
  idx_w_ratio = sorted(idx_w_ratio, key = lambda x: x[2], reverse=True)
  capacity, i = max_w, 0
  M = [0] * n

  while i < n and capacity >= idx_w_ratio[i][1]: 
      M[i] = 1                          #faz o while normal 
      capacity -= idx_w_ratio[i][1]
      i += 1
  if i < n:
      M[i] = capacity/idx_w_ratio[i][1]
  
  itens_choosed = [0] * n               #lista que referencia a cada item a sua 
  for j in range(n):                    #porcentagem escolhida
      if M[j] != 0:
          itens_choosed[idx_w_ratio[j][0]] = M[j]
    
  return itens_choosed                  #retorna a lista de índices com a %
```

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

*Implementação em python*

Para essa implementação, vamos relembrar basicamente a função MergeSort, só que contando a quantidade de inversões. Ainda, vamos juntar as funções CountInversions e a Merge numa mesma.  
```py
def combine_merge(v, start_a, start_b, end_b):
    r = [0] * (end_b - start_a)
    a_idx = start_a
    b_idx = start_b
    r_idx = 0
    num_inv = 0                         #adicionado
    
    while a_idx < start_b and b_idx < end_b:
        if v[a_idx] <= v[b_idx]:
            r[r_idx] = v[a_idx]
            a_idx += 1
        else:
            num_inv += start_b - a_idx  #adicionado (explicado anteriormente)
            r[r_idx] = v[b_idx]
            b_idx += 1
        r_idx += 1
        
    while a_idx < start_b:
        r[r_idx] = v[a_idx]
        a_idx += 1
        r_idx += 1
        
    while b_idx < end_b:
        r[r_idx] = v[b_idx]
        b_idx += 1
        r_idx += 1
        
    for i in range(len(r)):
        v[start_a + i] = r[i]

    return num_inv                      #adicionado

def count_inversions(v, start_idx, end_idx):
    if (end_idx - start_idx) > 1:
        mid_idx = (start_idx + end_idx) // 2
        il = count_inversions(v, start_idx, mid_idx)      #essas linhas mudaram 
        ir = count_inversions(v, mid_idx, end_idx)        #apenas a igualdade
        
        i = combine_merge(v, start_idx, mid_idx, end_idx) #antes não tinha
      return il + ir + i                #adicionado
    else:
      return 0  
```
Todo o código (a menos de linhas comentadas) foi tirado da versão original do MergeSort. Como dito, fizemos o MergeSort contando a quantidade de inversões. :)
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

    Em seguida, resolva cada lado encontrando o par mais próximo recursivamente.  
  
    #v(1.5em)
    Figura 11: Exemplificação da solução do problema de pares mais próximos
  ],

  [
    #image("images/divide-and-conquer-example5.png", width: 100%)
  ]
)

Com o plano dividido, combine os resultados comparando O par mais próximo no lado direito, o par mais próximo do lado esquerdo, e o par mais próximo em cada lado. A última comparação parece exigir $Theta(n^2)$, não parece muito bom.

Se pensarmos apenas na comparação da divisão dos planos, sejam $delta_l$ e $delta_r$ os pares com menor distância nos lados esquerdo e direito, respectivamente.

#wrap-it.wrap-content(
  
  figure(
    image("images/divide-and-conquer-example6.png", width: 100%),
    caption: "Exemplo da distância de comparação."
    
  ),
  [
    Como estamos procurando o par mais próximo, seja $delta_"min" <= min(delta_l, delta_r)$ (sabemos que $delta_"min"$ está restrito a, no máximo, essa distância).

    Ideia: procurar somente os pontos que estejam no máximo à $delta_min$ da divisória, ordenando os pontos na faixa $2 delta_min$ pela posição o eixo y. 

    Qual seria a complexidade desse algoritmo?
  ],
)

Bom, não seria $O(n^2)$, pois a distância em cada lado é no mínimo $delta_min$.

=== como faz isso cara como é 11 7, 5 sla

=== Implementação em Python

== Programação Dinâmica

O paradigma de programação dinâmica consiste em quebrar em sub-problemas menores e resolvê-los de forma independente. Semelhante ao dividir e conquistar, porém com foco em sub-problemas que usam repetição. Nessa técnica, um sub-problema só é resolvido caso não tenha sido resolvido antes (caso contrário é usado o resultado anterior guardado previamente).

=== O problema de Fibonacci

#wrap-it.wrap-content(
  
  figure(
    image("images/dynamic-programming-example.png", width: 89%),
    caption: [Exemplo de como seria $"fib"(6)$]
    
  ),
  [
    Dado um inteiro $n >= 1$, encontre $F_n$. Solução recursiva (e ineficiente):

    ```py
    def fib(n):
      if n <= 2:
        return 1
      return fib(n-1) + fib(n-2)
    ```
  ],
)

Note como, para $n$, o tempo de execução é exponencial, e que, grande parte dos problemas são re-computados. Podemos utilizar um cachê para reaproveitar resultados. Vamos fazer isso!

#grid(
  columns: (1fr, 0.8fr), 
  gutter: 1.5em,       
  [
    
Solução Top-Down (recursiva):


    ```py
    def Fib(n):
      if n == 0:
          return 0
      if n == 1:
          return 1

      F = [-1] * (n + 1)
      F[0], F[1], F[2] = 0,1,1

      def FibAux(k):
        if F[k] == -1:
          F[k] = FibAux(k - 1) + FibAux(k-2)
        return F[k]

      return FibAux(n)
    ```
  ],

  [
    #figure(
    image("images/dynamic-programming-example2.png", width: 100%),
    caption: [Exemplo de como fica o cachê para $"Fib"(6)$]
    )
  ]
)

A complexidade desse algoritmo é $Theta(n)$, sabendo que usamos apenas a lista para guardar os valores da lista de Fibonacci. 

Solução Bottom-Up (interativa):

```py
def Fib(n):
  if n <= 2:
      return 1
  F = [0] * n
  F[1], F[2] = 1, 1
  for i in range (3,n + 1,1):
      F[i] = F[i - 1] + F[i - 2]
  return F[n]
```

A complexidade é a mesma da recursiva, desde que continuamos usando apenas um for e usando-a para guardar apenas uma lista.

A abordagem Top-Down é recursiva, somente executa a recursão caso o sub-problema não tenha sido resolvido e inicia no problema maior, enquanto em problemas Bottom-Up a solução é iterativa e resolve os sub-problemas do menor para o  maior. Além disso, em geral apresentam a mesma complexidade.

=== O problema da mochila (não fracionária)

Dado um conjunto de itens $II = {1,2,3,...,n}$ em que cada item $i in II$ tem um peso $w_i$ e um valor $v_i$, e uma mochila com capacidade de peso $W$, encontre o subconjunto $S subset.eq II$ tal que $sum_(i in S)^(|S|) w_i <= W$ e $sum_(i in S)^(|S|) v_i$ seja máximo.

A diferença desse problema para o que vimos no paradigma Guloso é que agora, não podemos pegar uma fração do item, apenas ou o pegamos ou não. Isso faz com que, agora, por mais que o item seja o mais valoroso possível na proporção valor/peso, ainda assim possa existir alguma outra combinação que tenha um valor maior.



#grid(
  columns: (1fr, 1fr), 
  gutter: 1.5em,       
  [
    Exemplo:

    W = 11

    A escolha ${1,2,4}$ tem peso 9, valor 29 e cabe na mochila.

    A escolha ${3,5}$ tem peso 12, valor 46 e não cabe na mochila.
  ],

  [
    #figure(
    image("images/dynamic-programming-example3.png", width: 80%),
    caption: [Tabela auxiliar para exemplo]
    )
  ]
)

Solução(ineficiente): criar um algoritmo de força bruta que testa todas as possibilidades e escolhe a que cabe na mochila com maior valor.

Tentando usar o que estamos aprendendo aqui (programação dinâmica), temos: 
- para cada item  $i$, considere a possibilidade de adicioná-lo ou não a mochila;
  - se adiconado, o valor é incrementado de $v_i$ e a capacidade é reduzida de $w_i$
  - avalie qual o melhor valor obtido em cada caso.
Após considerar esse item, restam $n-1$ itens disponíveis para serem avaliados (encontramos a sub-estrutura ótima).

Ideia geral (sem cachê):

#pseudocode-list[

+ *Mochila* $ (I, v, w, W):$
  + *se* $|I| = 0$ *ou* $W = 0$
    +   *retorne* 0
  + *escolha* um item $i in I$
  + *se* $w_i > W:$
    + *retorne Mochila* $ (I - i, v, w, W):$
  + $"value_using" = v_i +$ *Mochila* $(I - i, v, w, W - w_i)$
  + $"value_not_using" = $ *Mochila* $(I - i, v, w, W)$
  + *retorna* $max{"value_using", "value_not_using"}$
]

Vamos para as soluções definitivas, usando o paradigma que estamos aprendendo. A ideia, como temos que fazer uma comparação a cada item que podemos pegar com e sem ele, é usar uma matriz $I "x" W$, onde o valor de cada célula $M[i][w]$ responde a seguinte pergunta: Qual é o valor máximo que consigo obter usando apenas os itens de 1 até $i$, com uma mochila de capacidade máxima $w$ (não $W$).



#grid(
  columns: (1fr, 1fr), 
  gutter: 1.5em,       
  [
    Solução Top-Down:

  #pseudocode-list[

  + *Mochila* $ (n, v, w, W):$
    + *crie* uma matriz $n "x" W$
    + *para* $i = 0 $ *até* $W$:
      + $M[0][i] = 0$
      + *para* $j = 1$ *até* $n$:
        + $M[j][0] = 0$
        + $M[j][i] = -1$
    + *retorna MocilhaAux*$(n,v,w,W)$
  ]

  onde $n$ é o total de itens. 

  Continuação da solução:
  ],

  [
    #figure(
    image("images/dynamic-programming-example4.png", width: 80%),
    caption: [Exemplo da matriz para o algoritmo Top-Down e valores anteriores.]
    )
  ]
)

#pseudocode-list[

+ *MochilaAux* $ (i, v, w, W):$
  + *se* $M[i][W] = -1$:
    + *se* $w_i > W$:
      + $M[i][W] =$ *MochilaAux* $(i - 1, v, w, W)$
    + *caso contrário*:
      + $"using" =v_i +$ *MochilaAux* $(i - 1,v,w,W - w_i)$
      + $"not_using" = $ *MochilaAux* $(i -1, v ,w ,W)$
      + $M[i][W] = max{"using,not_using"}$
  + *retorna* $M[i][W ]$
]

Onde $i$ é o item que estamos considerando no momento. Essa solução usa a ideia explicada anteriormente, de fazer a verificação entre o melhor caso, adicionando e não adicionando. Vamos agora para a solução Bottom-Up:


#pseudocode-list[

+ *Mochila* $ (n, v, w, W):$
  + *crie* uma matriz $n "x" W$
  + *para* $i = 0 $ *até* $W$:
    + $M[0][i] = 0$
  + *para* $j = 1$ *até* $n$:
    + $M[j][0] = 0$
  + *para* $j = 1$ *até* $n$:
    + *para* $i = 1$ *até* $W$:
      + *se* $w_j > i:$
        + $M[j][i] = M[j-1][i]$
      + *caso contrário*:
        + $"using" =v_j + M[j -1][i - w_j]$ 
        + $"not_using" = M[j - 1][i]$ 
        + $M[j][i] = max{"using,not_using"}$
  + *retorna* $M[n][W]$
]

Sabendo que toda a análise e o algoritmo é baseado na criação da matriz, onde dentro da criação de cada item acontecem apenas verificações, então a complexidade $Theta(n W)$ (o que *não* é polinomial, já que $W$ é um tamanho, não um valor). Vamos ver agora como essa matriz ficaria no final:

#figure(
image("images/dynamic-programming-example5.png", width: 90%),
caption: [Resultado final da matriz finalizando o primeiro exemplo da mochila fracionária.]
)

Lembre qual a função da matriz: o índice $i$ (na linha) representa que podemos pegar qualquer dos itens $1$ até $i$, e o peso $W$ (na coluna) é o peso $w$ que foi escolhido, e o número no índice $n "x" w$ é o valor que conseguimos nessa combinação. Portanto, podemos interpretar que, na segunda linha, na coluna de $w = 0$, temos $0$ itens para ser colocados e podemos colocar até um peso $0$, logo, o valor máximo é 0. Ao continuar dessa linha, conseguimos ver que, a partir de quando o peso fica $>= 1$, conseguimos colocar o único item liberado ($1$), com peso $1$ e valor $1$. Por isso, toda a segunda linha é igual a $1$ a partir do momento que $w >= 1$.

*Nota:* Seguindo esse raciocínio, você, caro leitor, pode verificar cada valor da tabela. Existe *um* erro na tabela. Convido a você interpretá-la e entendê-lá e encontrar o erro. Se quiser validar que encontrou o erro, mande uma mensagem (Thalis).

Para finalizar, precisamos definir quais itens devem ser adicionados à mochila:


#wrap-it.wrap-content(
  columns: (1.375fr, 1fr),
  figure(
    image("images/dynamic-programming-example6.png", width: 100%),
    caption: [Exemplo da busca dos itens adicionados (as células pintadas de laranja são as células visitadas pelo algoritmo)]
    
  ),
  [
    #pseudocode-list[
    + $S, i, j = {}, W, n$
    + *enquanto* $j >= 1$:
      + *se* $M[j][i] = M[j-1][i - w_j] + v_j$
        + $S = S union {j}$
        + $i = i - w_j$
      + $j = j -1$
    + *retorna* $S$ 
    ]
  ],
)

Vamos entender o código: $j$ itera nas linhas, W nas colunas. Em teoria, a última célula da matriz ($n "x" W$) carrega com certeza o maior valor que satisfaz a condição do problema, e por isso começamos por ela. O que estamos fazendo é verificar se $M[j][i] = M[j-1][i - w_j] + v_j$, ou seja, se o valor da célula voltando o peso do item atual (supondo que ele foi adicionado) e voltando um item ($j - 1$) somado ao valor de $v_j$ é igual ao valor da célula atual, pois, se isso for verdade, significa que adicionamos esse valor ao descobrir o item $j$.

Vamos olhar para o exemplo da tabela:
- Ponto de partida: $M[5][11]$. Valor $= 40$. O item 5 (peso 7, valor 28) foi usado para obter esse valor de 40?
  - Comparamos o valor atual ($M[5][11]=40$) com o valor da célula de cima ($M[4][4]=7 + v_j = 7 + 28 != 40$).
  - Como os valores não são iguais, significa que o item 5 *não* foi incluído. A solução ótima para capacidade 11 já existia sem ele.
  - Então o algoritmo "sobe" para a célula $M[4][11]$. 

- Posição Atual: Célula $M[4][11]$. Valor $= 40$. O item 4 (peso 6, valor 22) foi usado?
  -  Comparamos o valor atual ($M[4][11]=40$) com o valor da célula de cima ($M[3][5]=18 + v_j = 18 + 22 = 40 $).
  - Os valores são iguais. Isso significa que o item 4 *foi* incluído!
  - Adicionamos o item 4 ao nosso conjunto de solução $S$.O algoritmo "sobe" para a linha anterior ($i=3$) e "anda para a esquerda" subtraindo o peso do item 4 da capacidade: $11 - 6 = 5$. O novo ponto de análise é $M[3][5]$ .

E assim sucessivamente!

*Implementação em Python*

```py
def bag_problem_bottom_up(n, v, w, W):
  #primeira parte (criar a matriz e inserir os valores)
  M = [[0] * (W + 1) for _ in range(n + 1)]
  for j in range(1, n + 1):
      for i in range(1, W + 1):
          peso_item_j = w[j-1]
          valor_item_j = v[j-1]          
          if peso_item_j > i:
              M[j][i] = M[j - 1][i]
          else:
              not_using = M[j - 1][i]
              using = valor_item_j + M[j - 1][i - peso_item_j]
              M[j][i] = max(using, not_using)
                
  #segunda parte (identificar os itens selecionados)
  itens_selecionados = []
  valor_maximo = M[n][W]
  j, i = n, W
  while j > 0 and i > 0:
      peso_item_j = w[j-1]
      valor_item_j = v[j-1]
      if peso_item_j <= i and M[j][i] == (M[j- 1][i - peso_item_j] + valor_item_j):
          itens_selecionados.append(j)
          i -= peso_item_j
          j -= 1
  itens_selecionados.reverse()
  return valor_maximo, M, itens_selecionados
```
Convido o caro leitor a implementar a solução Top-Down. 



#pagebreak()

#align(center + horizon)[
  = Grafos
]

#pagebreak()

== wow grafos
