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

== Exercício de String

Enunciado: Dadas duas strings, encontre o comprimento da maior subsequência comum entre elas.

== Exercício da moeda

Dado um valor $v$ e uma lista de denominações de moedas (de um sistema canônico), encontre o número de moedas para formar $v$.

== Menor quantidade de comparações

Dado um array $A$ com $n$ elementos, encontre simultaneamente o maior e o menor elemento usando o menor número possível de comparações.

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
