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

Sinceramente, fazer uma revisão de conceitos muito básicos de grafos que já vimos em Matemática Discreta é um pouco chato, para não dizer
desnecessário. Irei relembrar alguns termos e definir outros que não me lembro de termos vistos. Vamos lá:

== Relembrando conceitos

- $V ->$ vértices;
- $E ->$ arestas;
- Uma aresta é definida pelo par $(v_i, v_j)$;
- O *tamanho* de um grafo é definido por $|V| + |E|$, onde $|.|$ é a cardinalidade (quantidade de elementos);

- Dado $e = (v_i, v_j)$, $v_i$ e $v_j$ são *extremos* da aresta se $e$ é incidente em $v_i$ e $v_j$, e $v_i$ e $v_j$ é incidente em $e$;
- Vértices relacionados por uma aresta são *adjacentes*;
- Duas arestas são *paralelas* se incidem ao mesmo vértice;
- *Laço* $= (v_i,v_i)$;
- $sum_(i = 1)^(|V|) g(v_i) = 2 |E|$, onde $g(v_i)$ é o *grau* do vértice $i$;
- Um grafo é *completo* se cada vértice possuir todos os demais adjacentes à ele;
- O número de arestas em um grafo completo é definido por: $(|V|(|V| - 1))/2$ (observe que isso é ligeiramente menor que $(|V|)^2/2 $;
- Um grafo é *regular* se todos os vértices possuírem o mesmo grau (ou $k$-regular , para grau $k$); 
- O número de arestas em um grafo $k$-regular é $|V|k/2$
- Um grafo é *denso* se o seu tamanho for proporcional ao quadrado do número de vértices ($|V| + |E| prop |V|^2$), e é esparso se $(|V| + |E|) prop |V|$.
- O grafo $H = G(V', E')$ é um *subgrafo* de $G = (V, E)$ se $V' subset.eq V$ e $E' subset.eq E$.
- O grafo $H = G(V', E')$ é um *subgrafo gerador* de $G = (V, E)$ se $H$ for um subgrafo de $G$ e $V' =  V$.
#example[
  #figure(
    image("images/subgraph-generator.png", width: 80%),
    caption: [Exemplo de subgrafo gerador. ]
   
)
]
- O grafo $H = G(V', E')$ é um *grafo induzido* de $G = (V, E)$ se $E'$ for definido por todas as arestas de $E$ adjacentes a um par de vértices $V'$.
#example[
  #figure(
    image("images/subgraph-induced.png", width: 80%),
    caption: [Exemplo de grafo induzido (os vértices escolhidos foram ${1,2,3,5}$ e as arestas(e vértices) que não são desses vértices não aparecem no subgrafo induzido). ]  
)
]
- O grafo $H = G(V', E')$ é um *grafo próprio* de $G = (V, E)$ se $H subset G$.
#example[
  #figure(
    image("images/subgraph-proper.png", width: 80%),
    caption: [Exemplo de grafo próprio (note que é $subset$, não $subset.eq$. Então, um subgrafo próprio é um subgrafo menor, e não igual ao grafo original). ]  
)
]
- Um *caminho* $P$ em $G(V, E)$ consiste em uma sequência de $n$ vértices, finita e não vazia tal que $v_(i+1)$ é adjacente a $v_i$.
- Um caminho é *simples* se não possuir vértices repetidos.  
- Um caminho é *fechado* se $v_1 = v_n$.
- O *comprimento* de um caminho é definido pelo número de arestas do caminho.
- Um grafo $G = (V,E)$ é *conexo* se para qualquer par de vértices existe um caminho em $G$.
- Quando um grafo não é conexo podemos segmentá-lo em *componentes conexos* (um par está no mesmo componente se existe um caminho).
- Um grafo $G(V,E)$ é uma *árvore* se $G$ for conexo e acíclico (possui $|V| - 1$ arestas, a remoção de qualquer aresta torna o grafo não-conexo e para todo par de vértices existe um único caminho);
- Um grafo $G(V,E)$ é uma *floresta* se for um grafo acíclico;
- Um grafo é *planar* se puder ser representado graficamente em um plano de tal forma que não haja cruzamento de arestas;
- Um grafo $G(V,E)$ é *bipartido* se os vértices puderem ser divididos em dois conjuntos $V_1$ e $V_2$ de forma que toda aresta $e_k$ é incidente em $(v_i, v_j)$ tal que $v_i in V_1$ e $v_j in V_2$;
- Um grafo $G(V,E)$ é *orientado* se as arestas possuirem um sentido. Nesse caso, a nomenclatura que definimos $(v_i,v_j)$ significa que ela começa em $v_i$ e termina em $v_j$.
- O grau de *sáida* $g_s (v_i)$ é definido pelo número de arestas que saem de $v_i$. Raciocíno análogo para grau de *entrada* $g_e (v_i)$;
- $sum_(i = 1)^(|V|)  g_e (v_i) = sum_(i = 1)^(|V|) g_s (v_i) = |E|$;
- O vértice $v_i$ é uma *fonte* se $g_e (v_i) = 0$;
- O vértice $v_i$ é um *sorvedouro* se $g_s (v_i) = 0$;
- O vértice  $v_i$ é *isolado* se for sorvedouro e fonte;
- Um grafo (orientado ou não) é *ponderado* se cada aresta estiver associado a um peso;

== Estruturas de dados para representar grafos

Dependendo do problema, a escolha da estrutura pode variar, e, em geral, usamos duas formas de implementar essa representação:

=== Matriz de adjacência

Consiste em um matriz quadrada $A$ de ordem $|V|$ cujas linhas e colunas são indexadas pelos vértices de $V$. Exemplo para grafos orienteados:

#figure(
    image("images/graph-structure1.png", width: 90%),
    caption: [Exemplo de matriz de adjacência para o grafo à direita. ]
    
)

Analogamente, para não orientados:

#figure(
    image("images/graph-structure2.png", width: 90%),
    caption: [Exemplo de matriz de adjacência para o grafo à direita. Nota: a matriz é simétrica! ]
)

A complexidade de acessar(ou verificar) uma aresta é $Theta(1)$, e claramente conta com uma complexidade de espaço de $Theta(|V|^2)$. Além disso, o fato da matriz ser simétrica para grafos não-orientados faz com que o tamanho se reduza para a metade, podendo se armazenar apenas a diagonal superior ou inferior da matriz.

=== Lista de adjacência

Consiste em uma sequência de vértices contendo na estrutura de cada ponteiro para uma lista encadeada com elemento representando as arestas adjacentes ao vértices. Exemplo para grafo dirigido:


#figure(
    image("images/graph-structure3.png", width: 95%),
    caption: [Exemplo da lista de adjacência para o grafo à direita.]
)

Exemplo para grafo não-dirigido:

#figure(
    image("images/graph-structure4.png", width: 95%),
    caption: [Exemplo da lista de adjacência para o grafo à direita.]
)

A complexidade de acessar o conjunto de arestas de um vértice é $Theta(1)$ (mas encontrar uma aresta específica é $Theta(|V|)$ no pior caso). Ainda, uma lista de adjacência exige um espaço $Theta(|V| + |E|)$

As estruturas de dados do vértice e da aresta podem ser estendidas para armazenar informações específicas do problema.

*Nota:* Os exercícios passados no slide não serão feitos aqui (pois isso é um "resumo" teórico), e sim na pasta Exercises. 



#pagebreak()

#align(center + horizon)[
  = Busca em Grafos
]

#pagebreak()


#grid(
  columns: (0.8fr, 1fr), 
  gutter: 1.5em,       
  [
    Após relembrar conceitos e aprender algumas estruturas, temos um novo problema:

    Dado um par de vértices $v_i$ e $v_j$ verificar se $v_j$ pode ser alcançado iniciando um caminho em $v_i$.

    Como resolver esse problema?
  ],

  [
    #figure(
    image("images/graph-search-example1.png", width: 70%),
    caption: [Exemplo do caminho $P = {1,2,5,6}$]
    )
  ]
)

A ideia principal é passar pelo grafo e marcar cada nó e aresta visitada, voltando ao nó anterior se chegar a uma junção já visitada ou sorvedouro.
Podemos escrever um algoritmo que percorre o grafo a partir do vértice $v_i$ armazenando os vértices visitados, e, ao final, verificar se $v_j$ foi visitado. Exemplo dessa ideia em Python para a estrutura de matriz de adjacência:

```py
def reach_recursive_matrix(v_atual, visited, matrix, num_vertices):
    visited[v_atual] = True
    for v_vizinho in range(num_vertices):
        if matrix[v_atual][v_vizinho] == 1 and not visited[v_vizinho]:
            reach_recursive_matrix(v_vizinho, visited, matrix, num_vertices)

def can_reach_matrix(matrix, v1, v2):
    num_vertices = len(matrix)
    visited = [0] * num_vertices
    reach_recursive_matrix(v1, visited, matrix, num_vertices)
    return visited[v2]
```

Como seria a execução desse algoritmo no que grafo que acabamos de ver?

#figure(
image("images/graph-search-example2.png", width: 90%),
caption: [Exemplo da execução do algoritmo can_reach para o mesmo grafo]
)

À esquerda temos a aresta escolhida e ao lado a iteração anterior   (começando do vértice 1). Observe que o resultado também indica todos os demais vértices que podem ser alcançados a partir de $v_i$.

Um *algoritmo de busca* em grafo é qualquer algoritmo que visita todos os vértices percorrendo as arestas definidas (a ordem de pesquisa depende do algoritmo). 

== DFS

O algoritmo de *busca em profundidade (Depth First Search)* consiste em visitar todos os vértices ao menos uma vez e levantar propriedades sobre a estrutura do grafo 

Vamos  começar identificando a ordem de descoberta dos vértices (ou pré-ordem). Em *C++:*

Esse código assume a existência de tipos como 'vertex', 'EdgeNode' e variáveis de membro como 'm_numVertices' e 'm_edges', que seriam parte de uma classe de Grafo. Ele usa algumas funções que não definiu antes, e eu não vou ficar tentando entender isso agora :p 

```cpp
void dfs(int * preOrder) {
    int counter = 0;
    for (vertex v=0; v < m_numVertices; v++) {
        preOrder[v] = -1;
    }
    for (vertex v=0; v < m_numVertices; v++) {
        if (preOrder[v] == -1) {
            dfsRecursive(v, preOrder, counter);
        }
    }
}

void dfsRecursive(vertex v1, int * preOrder, int & counter) {
    preOrder[v1] = counter++;
    EdgeNode * edge = m_edges[v1];
    while (edge) {
        vertex v2 = edge->otherVertex();
        if (preOrder[v2] == -1) {
            dfsRecursive(v2, preOrder, counter);
        }
        edge = edge->next();
    }
}
```
Implementação em Python:

Intuitiva com a ideia, inicia a lista de descoberto como $-1$ e se o vértice é $-1$ (ainda não descoberto), realiza a busca profunda partindo desse vértice, e atualizando a lista ``preorder`` da ordem que foi a partir do primeiro ``v``.

```py
def dfs_preorder(adj_list):
    num_vertices = len(adj_list)
    preorder = [-1] * num_vertices
    counter = 0 
    for v in range(num_vertices):
        if preorder[v] == -1: 
            counter = dfs_recursive(v, preorder, counter, adj_list)
    return preorder

def dfs_recursive(v_atual, preorder, counter, adj_list): #Auxiliar
    preorder[v_atual] = counter
    counter += 1
    for v_vizinho in adj_list[v_atual]:
        if preorder[v_vizinho] == -1:
            counter = dfs_recursive(v_vizinho, preorder, counter, adj_list)
    return counter

```

Voltando ao exemplo inicial, veja como seria o algoritmo:

#figure(
image("images/graph-search-example3.png", width: 90%),
caption: [Exemplo da execução do algoritmo DFS para o mesmo grafo]
)

À esquerda, os parênteses indicam as arestas visitadas e a lista da ordem de visita. A interpretação de ``preorder`` é: o vértice $1$ foi o primeiro a ser visitado, o vértice $3$ foi o segundo, o $5$ o terceiro e assim sucessivamente.

Dizemos então que um vértice $v$ é *visitado* quando ``preOrder[v]`` é consultado e que um vértice $v$ é *descoberto* quando  ``preOrder[v]`` é definido (a busca pode iniciar em qualquer vértice).

A abordagem de tentar percorrer a partir de cada vértice garante que todos os vértices serão inspecionados, mesmo que o grafo não seja conexo. Além disso, um grafo pode apresentar múltiplas sequências de pré-ordem (depende da ordem em que as arestas são inspecionadas).

Falando de complexidade, sabemos pelo algoritmo que cada vértice será processado uma única vez, e em cada vértice são verificadas cada $g_s (v_i)$ arestas.
Sabendo que isso soma $|E|$, fica claro que temos uma complexidade de $Theta(|V| + |E|)$ usando lista de adjacências, e $Theta(|V|^2)$ para matriz de adjacência.

== Grafo topológico

Um *grafo topológico* é um grafo que admite uma ordenação dos vértice de
forma que para toda aresta $(v_i, v_j)$ temos que $i < j$. 

#figure(
image("images/graph-search-example4.png", width: 90%),
caption: [Exemplo da grafo topológico (Note que se os vértices forem dispostos em ordem crescente toda aresta irá apontar para o sentido de crescimento dos números).]
)

Algumas propriedades de grafos topológicos:
- Não apresentam ciclos;
- Todo vértice é: 
  - o término de um caminho que começa numa fonte;
  - a origem de um caminho que termina num sorvedouro;
- Se um grafo é topológico, podem existir várias numerações topológicas diferentes;

Como verificar se um grafo $G = (V,E)$ possui numeração topológica e determiná-la?

Podemos eliminar uma fonte $g_e (v_k) = 0$ de $G$ produzindo um subgrafo $G'$, e repetindo o procedimento sobre ele. Se redumovermos a fonte inicial, isso provavelmente vai criar (caso não tenhamos outra) outra fonte. Se não criar, isso significa que o restante dos vértices estão presos em um ciclo. Numere os vértices removidos, e, se todos eles forem removidos, a numeração é topológica.

*Nota:* O exercício de como fazer o algoritmo que verifica a topologia do grafo está na pasta Exercises.

#grid(
  columns: (0.8fr, 1fr), 
  gutter: 1.5em,       
  [
    Uma *floresta radicada* é um grafo topológico sem vértices com grau de entrada maior que 1 

    As fontes de uma floresta radicada são as raízes das árvores, e os sorvedouros são folhas.

    A floresta gerada pela execução do algoritmo de busca em profundidade também é chamada de floresta DFS (essa floresta é também um grafo gerador).
  ],

  [
    #figure(
    image("images/graph-search-example5.png", width: 85%),
    caption: [Exemplo de floresta radicada (a raiz no 2 foi proposital)]
    )
  ]
)

== DFS modificado

Dado que o grau de entrada de cada vértice é no máximo $1$, podemos representar a floresta DFS como um vetor de pais (parents). Portanto, o algoritmo pode ser modificado para gerar a árvore DFS da seguinte forma:


Esse código assume a existência de tipos como 'vertex', 'EdgeNode' e variáveis de membro como 'm_numVertices' e 'm_edges', que seriam parte de uma classe de Grafo.

Esse código é bem parecido com o DFS anterior, a menos da marcação para ``parents``.
```cpp
void dfs(int * preOrder, int * parents) {
    int counter = 0;
    for (vertex v=0; v < m_numVertices; v++) {
        preOrder[v] = -1;
        parents[v] = -1;
    }

    for (vertex v=0; v < m_numVertices; v++) {
        if (preOrder[v] == -1) {
            parents[v] = v; 
            dfsRecursive(v, preOrder, counter, parents, 0);
        }
    }
}


void dfsRecursive(vertex v1, int * preOrder, int & counter, int * parents, int level=0) {
    preOrder[v1] = counter++;
    EdgeNode * edge = m_edges[v1];
    while (edge) {
        vertex v2 = edge->otherVertex();
        if (preOrder[v2] == -1) {
            parents[v2] = v1; // Set parent first
            dfsRecursive(v2, preOrder, counter, parents, level + 1);
        }
        edge = edge->next();
    }
}
```
Focando na função ``dfs_parents``, e, usando lista de adjacência, criamos a lista de ordem e de pais, e o ``counter``(para marcação de pré-ordem) como $0$. Para cada item da ordem do vértice, se a pré-ordem for $-1$, ou seja, se não tivermos descoberto o vértice ainda (procurando vértices de partida), então ele é marcado como item de partida (se referenciando ``parents[i] = i``). Após isso para cada vértice de partida, iniciamos a marcação.

No ``dfs_recursive_parents``, incrementamos o ``counter`` a cada uso da função (para atualizar o ``preorder``), e a cada filho da lista de adjacências, marca o vértice atual como pai (apenas se esse filho não tiver sido visitado, ignorando filhos já visitados por "outros pais"). 
```py
def dfs_recursive_parents(v_atual, preorder, parents, counter, adj_list):
    preorder[v_atual] = counter
    counter += 1
    for v_vizinho in adj_list[v_atual]:
        if preorder[v_vizinho] == -1:
            parents[v_vizinho] = v_atual  
            counter = dfs_recursive_parents(v_vizinho, preorder, parents, counter, adj_list)

    return counter

def dfs_parents(adj_list):
  num_vertices = len(adj_list)
  preorder = [-1] * num_vertices
  parents = [-1] * num_vertices
  counter = 0

  for v in range(num_vertices):
      if preorder[v] == -1:
          parents[v] = v   
          counter = dfs_recursive_parents(v, preorder,parents, counter, adj_list)
  return preorder, parents
```
Como isso funcionaria no exemplo que já vimos até agora?

#figure(
image("images/graph-search-example6.png", width: 100%),
caption: [Exemplo do algoritmo ``dfs_parents`` para o grafo de exemplo.]
)

um vértice é *exaurido* (essa definição não é minha e não está nos slides do Thiago) no momento em que a busca já explorou todos os caminhos possíveis que saem daquele vértice.

Uma outra informação que podemos gerar a partir da execução de um DFS é a ordem em que os vértices são exauridos (essa sequência é conhecida como pós-ordem).

O algoritmo de DFS pode ser modificado de forma que registre o momento em que o algoritmo termina a avaliação do vértice, da seguinte forma:

```cpp
void dfs(int * preOrder, int * postOrder,
         int * parents) {
    int preCounter = 0;
    int postCounter = 0;
    for (vertex v=0; v < m_numVertices; v++) {
        preOrder[v] = -1;
        parents[v] = -1;
        postOrder[v] = -1;
    }

    for (vertex v=0; v < m_numVertices; v++) {
        if (preOrder[v] == -1) {
            parents[v] = v;
            dfsRecursive(
                v, preOrder, preCounter,
                postOrder, postCounter, parents);
        }
    }
}

void dfsRecursive(vertex v1, int * preOrder, int & preCounter, int * postOrder,
                  int & postCounter, int * parents) {
    preOrder[v1] = preCounter++;
    EdgeNode * edge = m_edges[v1];
    while (edge) {
        vertex v2 = edge->otherVertex();
        if (preOrder[v2] == -1) {
            parents[v2] = v1;
            dfsRecursive(v2, preOrder, preCounter,
                         postOrder, postCounter, parents);
        }
        edge = edge->next();
    }
    postOrder[v1] = postCounter++;
}
```

Note que ele é o mesmo algoritmo que o do DFS modificado, a menos de uma declaração da lista de pós-ordem e preenchimento no fim do while, após exaurir o vértice. Note que

```py
def dfs_recursive_full(v_atual, preorder, postorder, parents, pre_counter, post_counter, adj_list):
    preorder[v_atual] = pre_counter
    pre_counter += 1
    for v_vizinho in adj_list[v_atual]:
        if preorder[v_vizinho] == -1:
            parents[v_vizinho] = v_atual
            pre_counter, post_counter = dfs_recursive_full(v_vizinho, preorder, postorder, parents, pre_counter, post_counter, adj_list)
    postorder[v_atual] = post_counter
    post_counter += 1
    return pre_counter, post_counter

def dfs_full(adj_list):
    num_vertices = len(adj_list)
    preorder = [-1] * num_vertices
    postorder = [-1] * num_vertices
    parents = [-1] * num_vertices
    pre_counter = 0
    post_counter = 0
    for v in range(num_vertices):
        if preorder[v] == -1:
            parents[v] = v  
            pre_counter, post_counter = dfs_recursive_full(v, preorder, postorder, parents, pre_counter, post_counter, adj_list)
return preorder, postorder, parents
```

Focando na pós-ordem, como seria a execução desse algoritmo nos grafos que vimos até agora?

#figure(
image("images/graph-search-example7.png", width: 100%),
caption: [Exemplo do algoritmo ``dfs_parents_full`` para o grafo de exemplo.]
)

== Propriedades úteis advindas do DFS

Algumas delas já vimos: ordenação topológica, floresta DFS, etc. Vamos ver outras

O *intervalo de vida (lifespan)* de um vértice no contexto da busca ocorre entre o momento que ele é descoberto e o momento em que ele é exaurido. Ele não pode ser definido como ``(preOrder[v], postOrder)``, pois são numerações independentes (isso APENAS no algoritmo passado, normalmente o lifespan é definido dessa forma).

Considere dois vértices $v_1$ e $v_2$.
- Se $v_1$ é descoberto antes de $v_2$, então $v_1$ é exaurido:
  - Antes de $v_2$ ser descoberto ($v_2$ não tem nenhum parentesco próximo de $v_1$, por isso $v_1$ e seus filhos são vistos, $v_1$ é exaurido e só depois $v_2$ é descoberto);
  - Depois de $v_2$ ser exaurido (para o caso em que $v_2$ é filho de $v_1$, que acontece porque na chamada recursiva o filho tem que ser limpo primeiro).

Como podemos representar o intervalo de vida da execução do DFS no grafo a seguir?

#figure(
image("images/graph-search-example8.png", width: 100%),
caption: [Exemplo do mapeamento do lifespan no grafo de exemplo.]
)

À esquerda temos a aresta escolhida e ao lado a iteração anterior (começando do vértice 1). a listagem à direita da escolha à esquerda é o histórico da chamada de funções para o vértice i. A lista em baixo representa visualmente o lifespan de cada vértice.

Dado dois vértices $v_1$ e $v_2$ de uma floresta radicada produzida pro uma execução DFS, o relacionamento desses dois vértices pode ser:

- Ancestral: $v_1$ é ancestral de $v_2$ se, para chegar em $v_2$, o algoritmo DFS "passou por" $v_1$ primeiro. (lifespan de $v_2$ contido no lifespan de $v_1$);
- Descendente: É o oposto de ancestral. $v_2$ é descendente de $v_1$ se $v_1$ for seu ancestral.;
- Primo descreve qualquer par de vértices que não tem relação de ancestralidade (lifespans disjuntos).

Primos ainda podem ser comparados:
- $v_1$ é primo mais velho de $v_2$ se:
  - ``preOrder[v1] < preOrder[v2]``
- $v_1$ é primo mais novo de $v_2$ se:
  - ``preOrder[v1] > preOrder[v2]``

Arestas que não pertencem à floresta DFS podem ser classificados de acordo com o grau do parentesco:
- Uma aresta é de retorno caso $v_j$ seja ancestral de $v_i$;
- Uma aresta é de avanço caso $v_j$ seja descendente de $v_i$;
- Uma aresta é cruzada caso $v_j$ seja primo de $v_i$.

Algumas outras características:

- Vértices de arestas cruzadas podem estar em diferentes árvores da floresta;
- Arestas cruzadas são sempre de um primo mais novo para um primo mais velho;
- Grafos não-orientados não possuem arestas cruzadas.

*Problema:* Dada uma aresta não pertencente à floresta DFS, como determinar algoritmicamente se:
  - É uma aresta de avanço:
    - se o intervalo de $v_j$ está contido no intervalo de $v_i$, ou seja:
    - `preOrder[vi] < preOrder[vj] AND postOrder[vi] > postOrder[vj]` 
  - É uma aresta de retorno:
    - se o intervalo de $v_j$ contém o intervalo de $v_i$, ou seja:
    - `preOrder[vi] > preOrder[vj] AND postOrder[vi] < postOrder[vj]`
  - É uma aresta cruzada:
    - se o intervalo de $v_j$ ocorre antes do intervalo de $v_i$, ou seja:
    - `preOrder[vi] > preOrder[vj] AND postOrder[vi] > postOrder[vj]`

#figure(
image("images/graph-search-example-10.png", width: 70%),
caption: [Exemplo de arestas de avanço, retorno e cruzada.]
)

*Nota:* essas propriedades para as arestas que não são da árvore são apenas quando usamos o `preOrder` e o `postOrder` com a contagem junta, ou seja, dependentes, da forma:

```py
# Índices:     0  1  2  3  4
pre_order  = [ 4, 2, 3, 7, 1]
post_order = [ 5, 9, 6, 8, 10]
```
Nesse caso, as definições valem do jeito que foram passadas.

Algumas outras propriedades:

- Um grafo é acíclico se e somente se possuir uma numeração topológica.
- Grafos acíclicos também são chamados de *DAGs* (Direct acyclic graphs).
- Uma floresta radicada é um DAG sem vértices com grau de entrada maior que 1.
- Uma árvore radicada é um DAG em que exatamente um vértice tem grau de entrada zero, e os demais grau de entrada 1.

*Problema:* Como determinar se um grafo $G = (V,E)$ possui ao menos um ciclo?

Basta executar a busca DFS e procurar por uma aresta de retorno comparando os intervalos de vida encontrados para cada vértice. Veja o código em C++:

```cpp
bool hasCycle(int * preOrder, int * postOrder) {
dfs(preOrder, postOrder);
for (vertex v1=0; v1 < m_numVertices; v1++) {
    EdgeNode * edge = m_edges[v1];
    while(edge) {
        vertex v2 = edge->otherVertex();
        if (preOrder[v1] > preOrder[v2]
            && postOrder[v1] < postOrder[v2]) {
            return true;
        }
        edge = edge->next();
    }
}
return false;
}```


*Implementação em Python:*

Indo para Python, vamos considerar que passamos as listas de preorder e postorder:

```py
def has_cycle(adj_list, preorder, postorder):
    num_vertices = len(adj_list)
    for v1 in range(num_vertices):
        for v2 in adj_list[v1]:            
            if preorder[v1] > preorder[v2] and postorder[v1] < postorder[v2]:
                return True
    return False
```

== BFS

O algoritmo de busca em largura (BFS - Breadth First Search) é uma outra estratégia de varredura em um grafo. A ideia principal é:

#grid(
  columns: (0.8fr, 1fr), 
  gutter: 1.5em,       
  [
    Percorrer o grafo por camadas, ou seja:
    - Inicia visitando um grafo $v_0$;
    - Visita seus vértices adjacentes;
    - Visita os adjacentes dos adjacentes (que ainda não foram visitados);
    - Continua até todos os vértices terem sido visitados.

    Assim como o DFS, define a ordem de descoberta dos vértices.
  ],

  [
    #figure(
    image("images/graph-search-example9.png", width: 85%),
    caption: [Exemplo do algoritmo BFS (note que cada nível está de uma cor). ]
    )
  ]
)

Uma implementação comum desse algoritmo utiliza uma fila para armazenar os vértices descobertos que ainda não foram explorados. Vamos ver o código:

```cpp
void bfs(vertex v0, int * order) {
    queue<int> queue;
    int counter = 0;
    for (int i=0; i < m_numVertices; i++) {
        order[i] = -1;
    }
    order[v0] = counter++;
    queue.push(v0);
    while (!queue.empty()) {
        int v1 = queue.front();
        queue.pop();
        EdgeNode * edge = m_edges[v1];
        while (edge) {
            vertex v2 = edge->otherVertex();
            if (order[v2] == -1) {
                order[v2] = counter++;
                queue.push(v2);
            }
            edge = edge->next();
        }
    }
}
```

Essa função recebe um vértice inicial `v[0]` e um ponteiro para a lista de ordem que será dada a ele. Inicia-se também uma fila (estrutura de dados que vimos em ED) e um counter que vai determinar a posição de cada vértice (a ordem). Após preencher a lista de ordem como -1, ele marca a posição do elemento `v[0]` na lista de ordem e faz o push de $v_0$ na fila.

Continuando, enquanto a fila não for vazia, chamamos de $v_1$ o primeiro item da fila, o retiramos da fila e pegamos sua lista de adjacência. Enquanto tiverem vértices nessa lista, pegamos o vértice do outro lado da aresta ($v_2$) e verificamos se ele não está na lista de ordem (já visitado). Caso já não tenha sido visitado, ele é adicionado na fila, e passamos para o próximo vértice.

O que podemos ver aqui é que a utilização da fila como estrutura de dados para esse algoritmo faz total diferença, já que isso faz com que, começando do vértice $v_0$, passamos por todos os seus filhos, e o uso da fila faz com que apenas os próximos $i$ a serem visitados sejam exatamente os $i$ filhos de $v_0$, e assim sucessivamente, trazendo uma busca em nível. Observe que essa implementação númera apenas os vértices a partir de $v_0$ (funciona bem quando você sabe que é um grafo com apenas uma componente conexa e com $v_0$ como raiz).

Como faríamos para garantir um algoritmo que numera todos os vértices?

```cpp
void bfsForest(int * order) {
    int counter = 0;
    for (int i=0; i < m_numVertices; i++) { order[i] = -1; }
    for (int i=0; i < m_numVertices; i++) {
        if (order[i] != -1) { 
            continue; 
            }
        order[i] = counter++;
        queue<int> queue;
        queue.push(i);
        while (!queue.empty()) {
            int v1 = queue.front();
            queue.pop();
            EdgeNode * edge = m_edges[v1];
            while(edge) {
                vertex v2 = edge->otherVertex();
                if (order[v2] == -1) {
                    order[v2] = counter++;
                    queue.push(v2);
                }
                edge = edge->next();
            }
        }
    }
}
```

O que muda desse algoritmo para o anterior é simplesmente a inicialização, pois agora nos baseamos no número de vértices para preencher a ordem como $-1$ e além disso, fazemos um for para passar por todos os vértices. Mas a ideia é a mesma, pois dentro desse for continuamos se ele já foi visitado, e se não foi, marcamos sua posição, e fazemos a mesma verificação para a lista de adjacências dele.

Legal, temos um array (`order`) que mostra a ordem de visitação, mas isso não me mostra exatamente como chegar de um vértice a outro diretamente. E se marcassemos o pai de cada vértice?

```cpp
void bfs(vertex v0, int * order, int * parent) {
    queue<int> queue;
    int counter = 0;
    for (int i=0; i < m_numVertices; i++) {
        order[i] = -1;
        parent[i] = -1;
    }
    order[v0] = counter++;
    parent[v0] = v0;
    queue.push(v0);
    while (!queue.empty()) {
        int v1 = queue.front();
        queue.pop();
        EdgeNode * edge = m_edges[v1];
        while (edge) {
            vertex v2 = edge->otherVertex();
            if (order[v2] == -1) {
                order[v2] = counter++;
                parent[v2] = v1;
                queue.push(v2);
            }
            edge = edge->next();
        }
    }
}
```
Note que precisamos voltar com o $v_0$, já que marcar o vértice no caminho mais curto vindo da origem sem uma origem não faz muito sentido.

Ele é exatamente igual o algoritmo anterior, a menos do vetor `parents`, que inicialment é declarado como $-1$ para todo vértice e, quando entra no if do não visitado, é marcado que $v_1$ é seu pai. Simples assim!

Analisando a complexidade (do último algoritmo), passamos por um for no número de vértices ($O(V)$), depois fazemos um while na queue. Como a queue terá no máximo tamanho $|V|$, pois o if verifica se já foi adicionado, e no while de dentro passamos por cada aresta de $v_i$ (que sabemos que $sum_(i =1)^(|V|) g_s (v_i) = |E|$), temos uma complexidade de no máximo $Theta(V + E)$ ao utilizar lista de adjacências. 

Ao utilizar matriz de adjacências, teríamos que buscar cada ligação de cada vértice sem receber uma lista pronta com isso, o que traria uma complexidade de $Theta( V^2)$. Ainda, para grafos densos, ambas as estruturas de dados traria uma complexidade de $Theta(V^2)$.
 
*Implementação em Python*

Vamos implementar os dois últimos algoritmos, pois são os mais completos. Forest:

```py
from collections import deque

def bfs_forest (list_adj):
    num_vertices = len(list_adj)
    counter = 0
    order = [-1] * num_vertices
    for i in range(num_vertices):
        if order[i] != -1:
            continue
        fila = deque()
        order[i] = counter
        counter += 1
        fila.append(i)
        while fila:
            v1 = fila.popleft()
            for vizinho in list_adj[v1]:
                if order[vizinho] == -1:
                    order[vizinho] = counter
                    counter += 1
                    fila.append(vizinho)
    
    return order
```

Note que ambos precisam de usar deque(fila com ponteiros para início e fim) para funcionarem com as mesmas complexidades. BFS:

```py
from collections import deque

def bfs (v0, list_adj):
    num_vertices = len(list_adj)
    fila = deque()
    counter = 0
    order = [-1] * num_vertices
    parent = [-1] * num_vertices

    order[v0] = counter
    counter += 1
    parent[v0] = v0
    fila.append(v0)
    while fila:
        v1 = fila.popleft()
        for vizinho in list_adj[v1]:
            if order[vizinho] == -1:
                order[vizinho] = counter 
                counter += 1
                parent[vizinho] = v1
                fila.append(vizinho)
    return parent, order
```

Fim! Mas agora, como achar o menor caminho em um grafo??



#pagebreak()

#align(center + horizon)[
  = Menor caminho em Grafos
]

#pagebreak()

Na seção anterior, tentamos verificar que o caminho existe. Agora, temos um novo problema:

Dados dois vértices $v_i$ e $v_j$ em um grafo $G = (V, E)$, encontre o caminho mínimo $P$ que começa em $v_i$ e termina em $v_j$.

Se o grafo for tiver mais de uma componente conexa, pode não existir um caminho entre $v_i$ e $v_j$ (podemos dizer que a distância é infinita). Além disso, se o grafo for orientado, a distância entre $v_i$ e $v_j$ pode ser diferente de $v_j$ para $v_i$. 

Para encontrar o caminho mais curto entre $v_i$ e $v_j$ é inevitável encontrar todos os caminhos que iniciam em $v_i$. A árvore produzida pela busca do menor caminho é chamada de Árvore de caminhos mais curtos (SPT - Shortest Path Tree).

A árvore SPT é uma sub-árvore radicada de $G$:
  - Todos os vértices de $G$ estão presentes na SPT.
  - Todo caminho na SPT a partir da raiz é mínimo no grafo $G$.

Um grafo possui uma SPT caso todos os vértices sejam acessíveis a partir de $v_i$. Caso não exista uma SPT para um grafo $G$ a partir de um grafo $v_i$, existe uma SPT para um sub-grafo induzido de $G$ com os vértices acessíveis a partir de $v_i$.

Portanto, para encontrar o menor caminho entre $v_i$ e $v_j$ precisamos encontrar a árvore radicada desse sub-grafo com raiz em $v_i$.

== Caminho mais curto em um DAG


#grid(
  columns: (0.4fr, 1fr), 
  gutter: 1.5em,       
  [

    *Problema:* Como criar um algoritmo capaz de gerar a SPT de um DAG iniciando na sua única fonte? (Considere que você possui uma possível ordem topológica para o DAG)

    Dica: use as propriedades do DAG!

  ],

  [
    #figure(
    image("images/spt-example1.png", width: 100%),
    caption: [Exemplo de DAG com uma fonte (verde) e um sorvedouro (vermelho)]
    )
  ]
)

Solução:

  - Inicialize cada vértice com a distância infinita para a raiz ($d[v_i] =  infinity$) e pai indefinido ($"parent"[v_i] =  -1$)
  - Defina a raiz com distância zero ($d[v_1] = 0$)
  - Percorra os vértices seguindo a ordem topológica
    - Avalie para cada vértice adjacente se $d[v_i] + 1 <= d[v_j]$
      - se for, atualiza $d[v_j]$ no vértice adjacente com a menor distância e define o novo pai do vértice adjacente.

Como seria a execução desse algoritmo para o grafo de exemplo?

#figure(
image("images/spt-example2.png", width: 100%),
caption: [Exemplo do algoritmo para o grafo dado anteriormente.]
)

Esse algoritmo funciona pois o vetor `parent` define uma árvore radicada $T$ com raiz em $v_0$ e, para toda aresta $e = (v_i, v_j)$, se $v_i$ foi processado então $e$ já foi avaliada. Por fim, ao término de execução $T$ é uma árvore radicada de um grafo induzido $H$, induzido de $G$, contendo os vértices acessíveis a partir de $v_0$, toda aresta de $H$ foi avaliada e $T$ é uma árvore geradora de $H$.

*Nota:* a implementação disso está nos Exercises

== Caminho mais curto em grafos não-dirigidos/ciclo

A comparação $d[v_i] + 1 <= d[v_j]$ e a eventual atualização no vetor de distância é conhecida como *operação de relaxamento.* Uma aresta está *relaxada* se $d[v_j] - d[v_i] <= 1$ e *tensa* se $d[v_j] - d[v_i] > 1$.

#example[ 
  estou no vértice $v_i$, e quero ir para o meu vizinho $v_j$, sabendo que $d[v]$ é a distância mínima conhecida até agora da origem até aquele vértice. Se $d[v_j] - d[v_i] <= 1$ (considerando que os pesos são inteiros e unitários), significa que a aresta $(e_i, e_j)$, mesmo com peso 1, não conseguiria fazer com que o valor de $d[v_j]$ mude, pois ele já é o menor possível, e então essa aresta é relaxada. Pelo contrário, se $d[v_j] - d[v_i] > 1$, significa que se o peso da aresta entre os dois vértices é 1, então $d[v_j]$ consegue ser atualizado, por isso é uma aresta tensa.
]

Chamamos de potencial relaxado uma numeração para os vértices que torne todas as aresta do grafo relaxadas. O vetor de distâncias resultante do algoritmo anterior é um potencial relaxado.

Voltando ao problema inicial: desejamos encontrar o caminho mais curto entre dois vértices em qualquer grafo. Como produzir uma solução para grafos não-dirigidos e/ou que possuem ciclos?

Podemos adaptar o algoritmo de busca em largura (BFS) de forma que a numeração dos vértices represente a distância para a raiz.

*Ideia geral:* modificar o ciclo do BFS para remover o vértice $v_i$ da fila, visitar seus vértices adjacentes e:
  - se $d[v_j]$ não estiver definida:
    - $d[v_j] = d[v_i] + 1$
    - $"parent"[v_j] = v_i$
    - inserir $v_j$ na fila

Note que o valor $d[v]$ é alterado somente uma vez.

*Nota:* a implementação disso está nos Exercises

== Caminho mais barato em grafos 

Um grafo (orientado ou não) é ponderado se cada aresta estiver associada à um valor (pode ser custo, peso, capacidade, etc).

*Problema:* dado dois vértices $v_i$ e $v_j$ em um grafo, encontre o caminho $p$ com o custo mínimo que comea-ça em $v_i$ e termina em $v_j$. (O custo é a soma das arestas e o custo mínimo é o menor valor possível de custo de um caminho de $v_i$ a $v_j$).

A distância entre $v_i$ e $v_j$ é definida pelo comprimento do caminho mais barato. Essa distância pode ser negativa se existirem arstas negativas, se não existir caminho entre dois vértices podemos dizer que a distância é infinita. Ainda, a distância entre os mesmos dois vértices podem ser diferentes caso o grafo seja orientado.

Um *ciclo negativo* é um ciclo cujo custo restante da soma de suas arestas é negativo. Se um grafo possuir ciclos negativos o caminho mais barato entre dois vértices pode não ser simples.

#figure(
image("images/spt-example3.png", width: 45%),
caption: [Exemplo de grafo com ciclo negativo.]
)

O problema de busca pelo caminho mais barato se torna muito mais simples quando não existem ciclos negativos, já que se $v_0$ é um vértice que não possui negativos ao seu alcance, todo caminho $p$ é simples e todo trecho inicial de $p$ entre $v_0$ e $v_k$ é o caminho mais barato de $v_0$ e $v_k$.

A árvore encontrada na busca pelo caminho mais barato é chamada de Árvore de caminhos mais barato - CPT (Cheapest Path Tree)

Essa árvore é sub-radicada em $G$:
  - Todos os vértices de $G$ estão presentes na $"CPT"$;
  - Todo caminho na $"CPT"$ a partir da raiz é mínimo no grafo $G$.

=== Djikstra

Esse famoso algoritmo, que provavelmente você, caro leitor, já viu em MD, é capaz de encontrar caminhos mais baratos em um grafo $G=(V,E)$ que possua arestas com custos positivos.

A solução consiste em crescer uma árvore radicada a partir do vértice inicial $v_0$ até que ela seja uma árvore geradora do subgrafo induzido a partir de $v_0$.

Antes de explicar melhor, a *franja* de uma árvore radicada $T$ com raiz em $v_0$ é o conjunto das arestas $(v_i, v_j)$ que possuem $v_i$ em $T$ e $v_j$ fora de $T$. A franja pode ser vista como o grau de saída do conjunto de vértices de $T$.

#figure(
image("images/djikstra-1.png", width: 50%),
caption: [Exemplo de franja. Os vértices $(1,2,3)$ já estão árvore radicada, e a franja é o conjuntos de arestas pontilhadas de peso $(2, 4, 1)$. ]
)

Depois de entender esse conceito, essa é a ideia geral para o Djikstra:

#pseudocode-list[
+ *insira* $v_0$ *em* $T$ 
+ *defina* $d[v_0] = 0$
+ *enquanto a franja não estiver vazia:*
  + *escolha $v_k$ de menor distância*
  + *aplique a operação de relaxamento em todas as arestas de $v_k$ da franja*
  + *insira $v_k$ em $T$*  
]

Veja a implementação em C++:

```cpp
void cptDijkstraSlow(vertex v0, vertex *parent, int *distance) {
  std::vector<bool> checked(m_numVertices);
  for (vertex v = 0; v < m_numVertices; v++) {
      parent[v] = -1;
      distance[v] = INT_MAX;
      checked[v] = false;
  }
  parent[v0] = v0;
  distance[v0] = 0;

  while (true) {
      int minDistance = INT_MAX;
      vertex v1 = -1;
      for (vertex i = 0; i < m_numVertices; i++) {
          if (!checked[i] && distance[i] < minDistance) {
              minDistance = distance[i];
              v1 = i;
          }
      }
      if (minDistance == INT_MAX || v1 == -1) break;
      checked[v1] = true;
      EdgeNode *edge = m_edges[v1];
      while (edge) {
          vertex v2 = edge->otherVertex();
          if (!checked[v2]) {
              int cost = edge->cost();
              if (distance[v1] != INT_MAX && distance[v1] + cost < distance[v2]) {
                  parent[v2] = v1;
                  distance[v2] = distance[v1] + cost;
              }
          }
          edge = edge->next();
      }
  }
}
```

O algoritmo inicializa os vetores do começo `parent`, `distance` e `checked`, e declara as informações iniciais de $v_0$. Depois, inicializa um while onde, a cada iteração declara a maior distância como um inteiro máximo, e, após isso, o vértice escolhido de $-1$(pois não escolhemos ainda). Nosso objetivo no for de baixo é escolher, dentre os que tem distância definida e ainda não foram checados (ou seja, a franja), quem tem a menor distância. Após selecionar esse vértice e verificarmos a condição de parada(se a menor distância não mudou, então não temos mais vértices para checar), marcamos ele como checado e fazemos a análise para cada vizinho.

Para cada vizinho, chamamos de $v_2$ o vizinho a ser analisado. Se ele não tiver sido checado, pegamos o seu custo e se a distância do $v_1 +$ custo da aresta for menor, então atualizamos a distância e o pai de $v_2$, e passamos para o próximo vértice. (a outra verificação desse if é pra evitar overflow).

*Implementação em Python* 

Aqui, consideramos que a lista de adjacências é da forma:
```py 
[
[(vértice, custo), (vértice, custo)], #arestas do vértice 0
[(vértice, custo), (vértice, custo)], #arestas do vértice 1
]
```
Isso é apenas a transformação do código para Python, usando essa estrutura mais simples, que fica dessa forma:

```py
def cpt_djikstra_slow(v0, list_adj):
    num_vertices = len(list_adj)
    checked = [0] * num_vertices
    parent = [-1] * num_vertices
    distance = [float('inf')] * num_vertices
    parent[v0] = v0
    distance[v0] = 0

    while True:
        mindistance = float('inf')
        v1 = -1
        for i in range(num_vertices):
            if checked[i] == False and distance[i] < mindistance:
                mindistance = distance[i]
                v1 = i
        if mindistance == float('inf') or v1 == -1:
            break
        checked[v1] = True
        for vizinho, custo in list_adj[v1]:
            if checked[vizinho] == False:
                if distance[v1] != float('inf') and distance[v1] + custo < distance[vizinho]:
                    parent[vizinho] = v1
                    distance[vizinho] = distance[v1] + custo

    return parent,  distance 
```

Esse código é bem parecido com os que já vimos, ele faz várias declarações de variáveis $O(V)$, e o while True roda no máximo $V$ vezes, já que depende de um for que roda também $V$ vezes (pois a verificação em algum intervalo $[0, |V|]$ é interrompida, porque cai no caso de condição de parada). Esse for só faz verificações constantes, e por isso é $O(V)$. continuando, temos um if e outro for que passa por $g_s (v_k)$ arestas, que ao final somam $E$. Portanto, dentro do while temos $O(V( V + g_s (v_k))) = O(V^2 + E)$, já que $sum_(i = 1)^(|V|) g_s (v_i) = |E|  $.

Existe uma característica importante nesse algoritmo: a cada iteração onde verificamos o elemento da franja a ser escolhido (passando por mais elementos que o necessário para escolher o menor, pois passamos por todos), uma iteração qualquer é sempre semelhante à iteração anterior. Com essa informação, como podemos melhorar o desempenho do algoritmo?

=== Djikstra "Rápido"

*Ideia*: manter os vértices da franja em uma fila de prioridades, implementada como um heap mínimo e que contém todos os vértices que ainda não foram verificados.

#figure(
  caption: [Exemplo do estado do algoritmo após processar o vértice 1. A imagem à esquerda mostra o heap nessa iteração.],
  image("images/djikstra-4.png",width: 90%)
)

```py
def cpt_djikstra_fast(v0, list_adj):
    num_vertices = len(list_adj)
    checked = [0] * num_vertices
    parent = [-1] * num_vertices
    distance = [float('inf')] * num_vertices
    parent[v0] = v0
    distance[v0] = 0

    while True:
        mindistance = float('inf')
        v1 = -1
        for i in range(num_vertices):
            if checked[i] == False and distance[i] < mindistance:
                mindistance = distance[i]
                v1 = i
        if mindistance == float('inf') or v1 == -1:
            break
        checked[v1] = True
        for vizinho, custo in list_adj[v1]:
            if checked[vizinho] == False:
                if distance[v1] != float('inf') and distance[v1] + custo < distance[vizinho]:
                    parent[vizinho] = v1
                    distance[vizinho] = distance[v1] + custo

    return parent,  distance 
```

=== Bellman-Ford

Esse algoritmo é capaz de encontrar caminhos mais baratos em um grafo $G = (V,E)$ mesmo que as arestas possuam custos positivos e negativos. Ele retorna falso se detectar um ciclo negativo.

O algoritmo consiste em relaxar as arestas do grafo sistematicamente,reduzindo progressivamente uma estimativa $d[v]$ para cada vértice $v in V$ do grafo, até alcançar a menor distância.

Essa é a ideia geral:
#pseudocode-list[
+ *insira* $v_0$ *em* $T$ 
+ *defina* $d[v_0] = 0$
+ *execute V - 1 vezes:*
  + *para cada arsta $(v_i, v_j)$:*
    + *aplique o relaxamento*  
+ *execute o relaxamento sobre todas as arestas*
  + *se alguma distância $d[v_k]$ for reduzida, ciclo negativo*
]

