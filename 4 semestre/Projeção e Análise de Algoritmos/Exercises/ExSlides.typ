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
    Exercícios de Slides
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

= Técnicas de Projeto

== Maior subsequência de Strings

* Dadas duas strings, encontre o comprimento da maior subsequência comum entre elas.*

Essa solução usa o paradigma da Programação Dinâmica, onde usaremos uma matriz para guardar os valores de cada sub string. Por exemplo, a matriz no índice $i "x" j$ será o tamanho da maior subsequênciade string dado que nossas substrings são $"string1"$ ```[:i]``` e $"string2"$```[:j]```.

Após construir a matriz, passamos completando cada elemento. Caso as letras sejam iguais, nós atualizamos a tabela somando o valor de um e o valor das substrings passadas, quando não tínhamos nenhuma das duas letras comparadas. Caso contrário, pegamos o maior entre $"string1"$```[:i-1]``` e $"string2"$```[:j]```

=== explicar melhor os casos e pq funciona

```py
def string_problem(string1, string2):
    str1 = list(string1)
    str2 = list(string2)
    len_str1 = len(str1)
    len_str2 = len(str2)
    M = [[0] * (len_str1 + 1) for _ in range(len_str2 + 1)]
    
    for j in range (1, len_str2 + 1):
        for i in range (1, len_str1 + 1):
            if str1[i - 1] == str2[j - 1]:
                M[j][i] = 1 + M[j-1][i-1]
            else:
                M[j][i] = max(M[j][i - 1], M[j - 1][i])
            
    return M[len_str2][len_str1]
```

== Menor quantidade de moedas


* Dado um valor $v$ e uma lista de denominações de moedas (de um sistema canônico), encontre o número de moedas para formar $v$.*

Nesse problema, vamos usar o paradigma Guloso. Considerando a lista de moedas *ordenada*, declaramos duas váriaveis, e para cada moeda da lista, se ```v_fake``` for 0 (significa que nossa soma de moedas chegou no valor que queríamos), acabamos o código. Caso contrário, pegamos a divisão inteira, que no caso significa quantas vezes cada moeda consegue fazer parte do valor, subtraímos do que falta em ```v_fake``` e incrementamos a contagem.

```py
def coin_problem(v, coins):
    counting_coins = 0
    v_fake = v

    for coin in coins:
        if v_fake == 0:
            break
        qtd = v_fake // coin 
        if qtd > 0:
            v_fake -= qtd * coin
            counting_coins += qtd

    return counting_coins
```

== Menor quantidade de comparações

*Dado um array $A$ com $n$ elementos, encontre simultaneamente o maior e o menor elemento usando o menor número possível de comparações.*

Uma solução genérica, mas que não atende a menor quantidade de comparações possível é se tivermos duas variáveis, uma para o mínimo e outra para o máximo, e passar pela lista em apenas um for. Infelizmente, a cada elemento o algoritmo deve verificar se o número é o menor ou o maior dentre o valor das variáveis anteriores. Desde que isso traz duas verificações por elementos, ao fim temos $2 n$ comparações. Mas essa não é a solução ótima. 

=== Solução (recursiva):

Essa solução, assim como a outra, depende de uma sacada interessante, em que queremos reduzir a quantidade de comparações $(2n)$ do algoritmo ingênuo. Para isso, usaremos uma estratégia de comparação entre *pares*, utilizando o paradigma Dividir e Conquistar. Tratamos os dois casos base na função e dividimos a lista ao meio para fazer isso recursivamente, até que tenhamos apenas $1$ ou $2$ elementos a serem analisad os, e isso nos traz 3 verificações por elemento (uma para o par ```arr[left] < arr[right]``` ), duas para comparar com os mínimos globais(uma pro máximo, outra pro mínimo), trazendo $approx 3n/2 $ comparações.


```py
def max_min(arr, left, right):
    if left == right:
        return arr[left], arr[right]
    if left == right - 1:
        if arr[left] < arr[right]:
            return arr[left], arr[right]
        else:
            return arr[right], arr[left]
        
    mid = (left + right) // 2
    min1, max1 = max_min(arr, left, mid)
    min2, max2 = max_min(arr, mid+1, right)

    min_global = min(min1, min2)
    max_global = max(max1, max2)

    return (min_global, max_global)
```

=== Solução (pairwise):

Essa solução é interativa, e usa uma ideia parecida com o algoritmo anterior. Foi separada em duas funções para evitar duplicação de código. Declaramos algumas variáveis para tracking dos mínimos e máximos, e vemos se o tamanho da lista é par ou ímpar. Se for par, então teremos uma quantidade de pares sem nenhuma sobra, e assim executamos ``` pairwise```, que passa na lista de elementos de par em par e verifica o maior (e menor) entre a dupla (uma verificação) e atualiza o máximo e mínimo global (2 verificações).

Para o caso de uma lista de tamanho ímpar, apenas é feita a mesma verificação para o último elemento ainda não verificado.
```py
def pairwise(arr, max_local, min_local, max_global, min_global):
    for i in range(0, len(arr) - 1, 2):
        if arr[i] >= arr[i+1]:
            max_local = arr[i]
            min_local = arr[i + 1]
        else: 
            max_local = arr[i + 1]
            min_local = arr[i]
        
        if max_local > max_global:
            max_global = max_local
        if min_local < min_global:
            min_global = min_local

    return min_global, max_global

def comparation_problem(arr):
    max_global = -float('inf')
    min_global = float('inf')
    max_local = 0
    min_local = 0

    if len(arr) % 2 == 0:
        min_global, max_global = pairwise(arr, max_local, min_local, max_global, min_global)
    else:
        min_global, max_global = pairwise(arr, max_local, min_local, max_global, min_global)
        
        k = len(arr) - 1 
        max_local = arr[k]
        min_local = arr[k]
    
        if max_local > max_global:
            max_global = max_local
        if min_local < min_global:
            min_global = min_local

    return (min_global, max_global)
```

#pagebreak()

= Grafos

== Matriz de adjacência

*Implemente uma classe para representar um grafo utilizando matriz de adjacência.*

=== C++

Em breve

=== Python

Nada de difícil entendimento aqui, portanto não precisa ser explicado. É apenas a implementação em Python do código dado nos slides de PAA do mesmo exercício em C++.

```py
class GraphMatrix:

    def __init__(self, num_vertices):
        self.num_vertices = num_vertices
        self.matrix = [[0 for _ in range(num_vertices)] for i in range(num_vertices)]

    def has_edge(self, v1, v2):
        if 0 <= v1 < self.num_vertices and 0 <= v2 < self.num_vertices:
            return self.matrix[v1][v2]
        return False

    def add_edge(self, v1, v2):
        if 0 <= v1 < self.num_vertices and 0 <= v2 < self.num_vertices:
            self.matrix[v1][v2] = 1
            self.matrix[v2][v1] = 1
        else:
            print("Erro")

    def remove_edge(self, v1, v2):
        if 0 <= v1 < self.num_vertices and 0 <= v2 < self.num_vertices:
            self.matrix[v1][v2] = 0
            self.matrix[v2][v1] = 0
        else:
            print("Erro")
        
    def print(self):
        for v1 in range(self.num_vertices):
            list_adj = []
            for v2 in range(self.num_vertices):
                if self.has_edge(v1, v2):
                    list_adj.append(f"({v1},{v2})")
            print(list_adj)

    def print_matrix(self):
        for v1 in range(self.num_vertices):
            row = []
            for v2 in range(self.num_vertices):
                row.append(self.matrix[v1][v2])
            print(row)
```

== Lista de adjacências

*Implemente uma classe para representar um grafo utilizando lista de adjacências.*

=== C++

Em breve

=== Python

Considerando que os vértices são sempre sequências de inteiros de $0$ a $n -1$, podemos fazer apenas uma lista de listas em vez de usar ponteiros em Python. Caso não fosse, poderíamos usar uma hashtable de listas, ou algo semelhante.

```py
class GraphAdjList:

    def __init__(self, num_vertices):
        self.num_vertices = num_vertices
        self.listadj = [[] for _ in range(num_vertices)]
        
    def has_edge(self, v1, v2):
        for i in range(len(self.listadj[v1])):
            if v2 in self.listadj[v1]:
                return True
        return False

    def add_edge(self, v1, v2):
        self.listadj[v1].append(v2)
        self.listadj[v2].append(v1)
        
    def remove_edge(self, v1, v2):
        self.listadj[v1].remove(v2)
        self.listadj[v2].remove(v1)

    def print_listadj(self):
        for vertex in range(self.num_vertices):
            print(f'{vertex}: {self.listadj[vertex]}')
    
    def print_matrix(self):
        matrix = [[0 for _ in range(self.num_vertices)] for i in range(self.num_vertices)]
        for vertex in range(self.num_vertices):
            for edge in self.listadj[vertex]:
                matrix[vertex][edge] = 1
            print(matrix[vertex]) 
```

== Verificação de subgrafo

*Dados dois grafos $G = (V, E)$ e $H = (V', E')$ com $V = V'$, crie um algoritmo que verifica se $H$ é subgrafo de $G$.*

Nesse problema, $V = V'$, então é possível usarmos matriz de adjacência tranquilamente (lista de adjacência também). Sabendo disso, vamos fazer para os dois casos:

=== Matriz de adjacência

Para a matriz, basta apenas passar por cada elemento das matrizes e verificarmos se, quando em $H$ é $1$, $G$ é $0$, pois isso significaria que existe alguma aresta fora do grafo original.

```py
def is_subgraph_matrix(gmatrix, hmatrix):
    num_vertices = len(gmatrix)
    for row in range(num_vertices):
        for column in range(num_vertices):
            if hmatrix[row][column] == 1 and gmatrix[row][column] == 0:
                return False
    return True
```

=== Lista de adjacência
Para a lista, basta apenas passarmos por cada elemento de cada lista de vértice, e ver so vértice está na lista do grafo original.

```py
def is_subgraph_list(glist,hlist):
    num_vertices = len(glist)
    for vi in range(num_vertices):
        for vj in hlist[vi]:
            if vj not in glist[vi]:
                return False
    return True
```

#pagebreak()

= Busca em Grafos


== Verificação de caminho e caminho simples

*Dado um grafo $G = (V,E)$ e um caminho $P$ composto por uma sequência de vértices, verifique se $P$ é um caminho de $G$, e se o caminho é simples.*

=== Matriz de adjacência

Basta passar a matriz e a cada $v_i$ e $v_(i + 1)$ verificar se é $1$ na matriz.
Eu decidi verificar se é um caminho simples em uma função separada, mas o leitor pode fazer junto se quiser. (a função serve tanto para lista quanto para matriz, por isso não irei repeti-la). É só olhar o tamanho da lista de caminhos se for igual quanto a transformamos em conjunto.

```py
def is_path_matrix(matrix, path):
    for order in range(len(path) - 1):
        if matrix[path[order]][path[order + 1]] != 1:
            return False
    return True

def is_simple_path(path):
    if len(set(path)) != len(path):
        return False
    return True
```

=== Lista de adjacência


Basta passar a lista e a cada $v_i$ e $v_(i + 1)$ verificar se existe o vértice na lista de arestas de $v_i$
```py

def is_path_list(list, path):
    for order in range(len(path) - 1):
        if path[order + 1] not in list[path[order]]:
            return False
    return True 
```

== Verificação de númeração topológica

Crie um algoritmo que verifica se a numeração dos vértices de um grafo $G = (V,E)$ é topológica.

=== Matriz de adjacência
Trivialmente, basta verificar se cada $i>=j$(evitando laços). Como a matriz não é simétrica, não podemos ignorar metade da matriz.

```py
def is_topological_matrix(matrix):
    num_vertices = len(matrix)
    for i in range (num_vertices):
        for j in range (num_vertices):
            if matrix[i][j] == 1 and i >= j:
                return False
    return True
```

=== Lista de adjacência

Análogo, só que para lista :D

```py
def is_topological_list(list):
    num_vertices = len(list)
    for i in range (num_vertices):
        for j in range(len(list[i])):
            if i >= list[i][j]:
                return False
    return True
```
=== Verificação de ordenação topológica (e determinação)

Crie um algoritmo para determinar se um grafo possui ordenação topológica e determiná-la.