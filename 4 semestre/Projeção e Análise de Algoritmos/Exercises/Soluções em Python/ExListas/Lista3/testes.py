import heapq
from typing import List, Tuple

def problema_7(n: int, m: int, estradas: List[Tuple[int, int, int]]) -> int:
    """
    Desenvolva um algoritmo com complexidade $O(m log n)$ que retorne
    o custo mínimo total para conectar as cidades.

    Entrada:
    - $n$: Número de cidades ($1 <= n <= 10^5$).
    - $m$: Número de estradas ($1 <= m <= 2 * 10^5$).
    - estradas: Lista de $m$ tuplas $(a, b, c)$, onde $a$ e $b$ são
      cidades e $c$ é o custo do reparo.

    Saída:
    - Retorne o custo mínimo total para conectar todas as $n$ cidades.
      (Retorna -1 se for impossível conectar todas).
    """
    adj = [[] for _ in range(n + 1)]
    
    for u, v, c in estradas:                        #pega os vértices e o custo
        adj[u].append((v, c))                       #fazemos uma lista de adjacência digna
        adj[v].append((u, c)) 
    pq = [(0, 1)]                                   #pra iniciar o heap (peso 0, vértice 1)
    
    visited = [False] * (n + 1)
    total_cost = 0
    nodes_connected = 0
    while pq:
        cost, u = heapq.heappop(pq)                 #popamos o primeiro
        if visited[u]:                              #se conseguirmos visitar o u com alguma entrada melhor, só passamos
            continue
        visited[u] = True                           #se passou, marcamos como visitado
        total_cost += cost                          #somamos ao custo
        nodes_connected += 1                        #somamos a quantidade de nós
        if nodes_connected == n:                    #se tivermos chegado em todos os nós, quebramos 
            break
        for v, weight in adj[u]:                    #e para cada vizinho no menor escolhido
            if not visited[v]:
                heapq.heappush(pq, (weight, v))     #adicionamos ao heap
    if nodes_connected < n:                         #se após o while, não conseguirmos conectar todas as arestas, então não satisfizemos o problema
        return -1         
    return total_cost                               #retorna o custo total

def rodar_testes():
    testes = [
        {
            "nome": "Exemplo 1 da Tabela",
            "n": 5,
            "m": 6,
            "estradas": [
                (1, 2, 3), (2, 3, 5), (2, 4, 2),
                (3, 4, 8), (5, 1, 7), (5, 4, 4)
            ],
            "esperado": 14
        },
        {
            "nome": "Exemplo 2 da Tabela (com aresta custo 0)",
            "n": 5,
            "m": 6,
            "estradas": [
                (1, 2, 3), (2, 3, 5), (2, 4, 2),
                (3, 4, 0), (5, 1, 7), (5, 4, 4)
            ],
            "esperado": 9
        },
        {
            "nome": "Exemplo 3 (Pequeno)",
            "n": 2,
            "m": 1,
            "estradas": [(1, 2, 0)],
            "esperado": 0
        },
        {
            "nome": "Grafo Desconectado (Impossível)",
            "n": 4,
            "m": 2,
            "estradas": [
                (1, 2, 10), # Grupo 1
                (3, 4, 20)  # Grupo 2 (sem conexão com o 1)
            ],
            "esperado": -1
        },
        {
            "nome": "Grafo com Ciclo (Triângulo)",
            "n": 3,
            "m": 3,
            "estradas": [
                (1, 2, 10),
                (2, 3, 10),
                (1, 3, 50) # Aresta cara que deve ser ignorada
            ],
            "esperado": 20
        }
    ]

    print("=== INICIANDO TESTES ===\n")
    todos_passaram = True

    for t in testes:
        resultado = problema_7(t['n'], t['m'], t['estradas'])
        
        if resultado == t['esperado']:
            print(f"✅ {t['nome']}: Passou! (Custo: {resultado})")
        else:
            print(f"❌ {t['nome']}: Falhou.")
            print(f"   Esperado: {t['esperado']}")
            print(f"   Obtido:   {resultado}")
            todos_passaram = False
    
    print("\n========================")
    if todos_passaram:
        print("Todos os testes passaram com sucesso!")

if __name__ == "__main__":
    rodar_testes()