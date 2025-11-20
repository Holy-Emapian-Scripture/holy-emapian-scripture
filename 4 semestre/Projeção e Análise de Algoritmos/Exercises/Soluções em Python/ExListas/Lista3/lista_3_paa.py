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

def problema_2(n: int, k: int, C1: int, C2: int, A: list[int]) -> int:
    def decider (inicio_estrada, fim_estrada, idx_buraco_inicio, idx_buraco_fim, A_ord):
        num_buracos = 0
        if idx_buraco_fim >= idx_buraco_inicio:
            num_buracos = (idx_buraco_fim - idx_buraco_inicio) + 1
        comprimento_segmento = (fim_estrada - inicio_estrada) + 1
        custo_consertar = 0
        if num_buracos == 0:
            custo_consertar = C1
        else:
            custo_consertar = C2 * num_buracos * comprimento_segmento

        if comprimento_segmento == 1:
            return custo_consertar

        ponto_meio_estrada = inicio_estrada + (comprimento_segmento // 2) - 1

        low = idx_buraco_inicio
        high = idx_buraco_fim
        idx_ponto_divisao_buracos = idx_buraco_fim + 1 

        while low <= high:
            mid = (low + high) // 2
            if A_ord[mid] > ponto_meio_estrada:
                idx_ponto_divisao_buracos = mid
                high = mid - 1
            else:
                low = mid + 1
        
        custo_esquerda = decider (inicio_estrada,ponto_meio_estrada,idx_buraco_inicio,idx_ponto_divisao_buracos - 1, A_ord)
        custo_direita = decider (ponto_meio_estrada + 1,fim_estrada,idx_ponto_divisao_buracos,idx_buraco_fim,A_ord)
        custo_dividir = custo_esquerda + custo_direita

        return min(custo_consertar, custo_dividir)

    if k == 0:
        return C1
    A = sorted(A)    
    L = 2**n
    return decider (1, L, 0, k - 1, A)

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
    def hash_div(A):                                            #função para gerar a tabela hash dos divisores de cada número de A
        hasht = {}                                              #inicio a tabela
        A = list(set(A))                                        #transforma a lista em conjunto para fazer o hash sem duplicatas (O(n)) e depois em lista novamente (O(n))

        for i in range (len(A)):                                #cria a hash para cada valor de A (O(n))
            if A[i] not in hasht:
                hasht[A[i]] = []
            root = int(A[i] ** 0.5)                             #tira a raiz para encontrar seus divisores 
            for k in range(1, root + 1):                        #vou até a raiz (O(raiz(n)))
                if A[i] % k == 0 and k != A[i] // k:            #se a divisão der zero e for diverente do resultado da divisão (acha o número e evita duplicata)
                    hasht[A[i]].append(k)                       #adiciona tanto o divisor quanto o resultado
                    hasht[A[i]].append(A[i] // k)               
                elif A[i] % k == 0:                             #para o caso de mesmos divisores (ex: 36 / 6 = 6)
                    hasht[A[i]].append(k)
            hasht[A[i]].sort(reverse=True)                      #ordem reversa para fazer o algoritmo (também O(raiz(n)))
        return hasht                                            #ordem reversa é escolhida para evitar duplicação de análise de números na ideia abaixo
    
    hash_divs = hash_div(A)                                     #pegamos o hash
    dp = [0] * n                                                #o item dp[i] mostra a quantidade de sequencias de tamanho i que conseguimos fazer   
    for i in range(len(A)):                                     #para cada item na nova lista
        for div in hash_divs[A[i]]:                             #e para cada divisor
                                                                #eu vejo a quantidade de subsequencias que tive de tamanho div - 1 até agora.
                                                                #até agora pois estou vendo a quantidade de subsequencias que consegui fazer com os números anteriores a A[i], o que faz sentido
            if div > 1:                                         #se esse divisor for maior que 1, eu consigo adicionar a subsequencia de atual a quantidade de subsequências anteriores 
                dp[div - 1] += dp[div - 2]                      #(como se apenas adicionasse esse novo divisor às subsequências de tamanhos div -1)
            else:                                               #caso seja divisor 1, então não temos subsequências anteriores e adicionamos só 1
                dp[div - 1] += 1

    return sum(dp) % 999999937                                  #retorna a soma



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