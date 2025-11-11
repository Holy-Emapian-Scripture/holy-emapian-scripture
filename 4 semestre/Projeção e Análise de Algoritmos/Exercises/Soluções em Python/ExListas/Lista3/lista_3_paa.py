import sys
import heapq
from collections import deque
from typing import List, Tuple, Dict, Set

# sys.setrecursionlimit(200010)

##### ATENÇÃO #####
# Não altere o nome deste arquivo.
# Não altere a assinatura das funções.
# Não importe outros módulos além dos já importados.
# Você pode criar outras funções ou classes se julgar necessário, mas deve defini-las no corpo da função do exercicio.

# ==============================================================================
# Problema de exemplo
# ==============================================================================
def problema_0(n: int, m: int, A: List[Tuple[int, int]]) -> int:
    """
    Recebe um grafo com $n$ vertices numerados de $1$ a $n$ e m arestas
    bidirecionadas e retorna o número de componentes conexas do grafo.
    
    Complexidade: O(n + m)
    """

    # Podemos utilizar listas simples, ao invés de dicionários ou conjuntos, para 
    # representar o grafo, já que os vértices são numerados de 1 a n.
    # Isso economiza processamento e memória.
    visited = [False] * (n + 1)
    adj = [[] for _ in range(n + 1)] # lista de adjacência
	
    # Construindo o grafo
    for u, v in A:
        adj[u].append(v)
        adj[v].append(u)

    # No geral, dê preferência a BFS iterativa, pois é mais eficiente que a
    # DFS recursiva (principalmente em Python).
    def bfs(start: int):
        queue = deque([start]) # fila para BFS
        visited[start] = True

        while queue:
            u = queue.popleft() # nó atual

            for v in adj[u]: # vizinhos
                if not visited[v]:
                    visited[v] = True
                    queue.append(v)

    number_of_components = 0
    for u in range(1, n + 1):
        if not visited[u]:
            bfs(u)
            number_of_components += 1

    return number_of_components


# ==============================================================================
# Problema 1 - Sisi e a Sorveteria: Parte 2
# ==============================================================================

def problema_1(n: int, A: List[int]) -> int:
    """
    Desenvolva um algoritmo com complexidade $O(n)$ que encontre a quantidade
    máxima total de sorvete que Sisi pode obter.

    Entrada:
    A entrada consiste em uma lista de $n$ inteiros $A = [a_1, a_2,  dots, a_n]$,
    onde $a_i$ é o estoque do $i$-ésimo sorvete.

    Saída:
    Retorne um único inteiro $Q$, a quantidade máxima total de sorvete
    que Sisi pode obter.
    """
    qtd = 0
    sorv = [0] * n
    sorv[n-1] = A[n-1]
    qtd += A[n-1]
    for i in range (n-2, -1, -1):
        if sorv[i+1] > A[i]:
            qtd += A[i]
            sorv[i] = A[i]
        elif sorv[i+1] <= A[i]:
            prev = sorv[i + 1] - 1
            if prev > 0:
                qtd += prev
                sorv[i] =  sorv[i + 1] - 1
    return qtd



# ==============================================================================
# Problema 2 - Minimizando Custos de Reparo
# ==============================================================================

def problema_2(n: int, k: int, C1: int, C2: int, A: List[int]) -> int:
    """
    Desenvolva um algoritmo com complexidade $O(k * log k)$ que encontre o
    custo mínimo para reparar a estrada.

    Entrada:
    - $n$: O expoente do comprimento da estrada ($L = 2^n$).
    - $C1$, $C2$: As constante de custo.
    - $A = [a_1, a_2,  dots, a_k]$: Uma lista com as $k$ posições dos buracos.

    Saída:
    - Retorne um único inteiro: o custo mínimo total para reparar toda a estrada.
    """
    pass


# ==============================================================================
# Problema 3 - Subsequências radicais
# ==============================================================================

def problema_3(n: int, A: List[int]) -> int:
    """
    Desenvolva um algoritmo com complexidade $O(n * sqrt n)$ que retorne
    a quantidade de subsequências radicais.

    Entrada:
    - $A = [a_1, a_2,  dots, a_n]$ (com $1 <= a_i <= n$).

    Saída:
    - A quantidade total de subsequências radicais, módulo $999999937$.
    """
    pass


# ==============================================================================
# Problema 4 - Cavalo
# ==============================================================================

def problema_4(n: int) -> List[List[int]]:
    """
    Desenvolva um algoritmo com complexidade $O(n^2)$ que retorne
    a matriz de movimentos mínimos.

    Entrada:
    - $n$: O tamanho do lado do tabuleiro ($3   <= n   <= 10^3$).

    Saída:
    - Retorna uma matriz $A$, onde $A[i][j]$ é o número mínimo de
      movimentos para um cavalo ir da posição (i, j) para a posição (0, 0).
    """
    pass


# ==============================================================================
# Problema 5 - Escape se for possível
# ==============================================================================

def problema_5(n: int, m: int, grid: List[List[str]]) -> int:
    """
    Desenvolva um algoritmo com complexidade $O(n^2)$ que retorne
    o menor tempo para escapar.

    Entrada:
    - grid: Uma lista de listas de strings representando a caverna.

    Saída:
    - Retorne o menor tempo para escapar. Se não for possível, retorne -1.
    """
    pass


# ==============================================================================
# Problema 6 - Viagem Intergalática
# ==============================================================================

def problema_6(n: int, m: int, rotas: List[Tuple[int, int, int]]) -> int:
    """
    Desenvolva um algoritmo com complexidade $O(m  log n)$ que retorne
    o custo mínimo total.

    Entrada:
    - $n$: Número de planetas ($1 <= n <= 10^5$).
    - $m$: Número de rotas ($1 <= m <= 2 * 10^5$).
    - rotas: Lista de $m$ tuplas $(a, b, c)$, onde $a$ é a origem,
      $b$ é o destino e $c$ é o custo.

    Saída:
    - Retorne o menor custo total possível para a viagem.
    """
    pass


# ==============================================================================
# Problema 7 - Reparo das Estradas
# ==============================================================================

def problema_7(n: int, m: int, estradas: List[Tuple[int, int, int]]) -> int:
    """
    Desenvolva um algoritmo com complexidade $O(m  log n)$ que retorne
    o custo mínimo total para conectar as cidades.

    Entrada:
    - $n$: Número de cidades ($1 <= n <= 10^5$).
    - $m$: Número de estradas ($1 <= m <= 2 * 10^5$).
    - estradas: Lista de $m$ tuplas $(a, b, c)$, onde $a$ e $b$ são
      cidades e $c$ é o custo do reparo.

    Saída:
    - Retorne o custo mínimo total para conectar todas as $n$ cidades.
    """
    pass


# ==============================================================================
# Problema 8 - Video Game
# ==============================================================================

def problema_8(n: int, m: int, transicoes: List[Tuple[int, int]]) -> int:
    """
    Desenvolva um algoritmo com complexidade $O(n + m)$ que encontre o número
    de formas distintas de ir do estado 1 ao estado $n$.

    Entrada:
    - $n$: O número de estados ($1 <= n <= 10^5$).
    - $m$: O número de transições ($1 <= m <= 2 * 10^5$).
    - transicoes: Uma lista com $m$ tuplas $(a, b)$ representando
      transições válidas.

    Saída:
    - Retorne um único inteiro: o número de formas distintas de ir do
      estado 1 ao estado $n$.
    """
    pass