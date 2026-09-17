from collections import deque

def spt(v0, list_adj):
    inf = len(list_adj)
    distance = [inf] * inf
    parent = [-1] * inf
    distance[v0] = 0
    parent[v0] = 0

    fila = deque()
    fila.append(v0)
    while fila:
        v1 = fila.popleft()
        for vizinho in list_adj[v1]:
            if distance[vizinho] == inf:
                distance[vizinho] = distance[v1] + 1
                parent[vizinho] = v1
                fila.append(vizinho)

    return distance, parent
    
def rodar_testes():
    print("--- INICIANDO BATERIA DE TESTES BFS ---\n")

    # TESTE 1: O Básico (Triângulo)
    # 0 se conecta a 1 e 2.
    print(">>> Teste 1: Básico")
    adj1 = [[1, 2], [], []]
    d1, p1 = spt(0, adj1)
    print(f"Distâncias: {d1}")
    assert d1 == [0, 1, 1]
    print("✅ Passou\n")

    # TESTE 2: O "Destruidor de DAGs" (Aquele que falhou no outro código)
    # Caminho: 0 -> 2 -> 1 -> 3
    # Índices fora de ordem. O BFS deve seguir as setas, não os índices.
    print(">>> Teste 2: Índices fora de ordem (0->2->1->3)")
    adj2 = [
        [2],    # 0 aponta para 2
        [3],    # 1 aponta para 3
        [1],    # 2 aponta para 1 (A flecha para trás no vetor!)
        []      # 3 fim
    ]
    d2, p2 = spt(0, adj2)
    print(f"Distâncias: {d2}")
    print(f"Pais:       {p2}")
    # Esperado: 
    # 0: dist 0
    # 2: dist 1 (vizinho do 0)
    # 1: dist 2 (vizinho do 2)
    # 3: dist 3 (vizinho do 1)
    assert d2 == [0, 2, 1, 3] 
    assert p2 == [0, 2, 0, 1] # Pai do 1 é 2, Pai do 2 é 0, Pai do 3 é 1
    print("✅ Passou (O BFS venceu onde o loop simples falhou!)\n")

    # TESTE 3: Ciclo (Loop)
    # 0 -> 1 -> 2 -> 0 (Volta pro início)
    # O BFS deve parar e não ficar rodando pra sempre.
    print(">>> Teste 3: Ciclo (0->1->2->0)")
    adj3 = [[1], [2], [0]]
    d3, p3 = spt(0, adj3)
    print(f"Distâncias: {d3}")
    assert d3 == [0, 1, 2]
    print("✅ Passou\n")

    # TESTE 4: Grafo Desconexo
    # 0 -> 1. O vértice 2 e 3 estão isolados numa ilha.
    print(">>> Teste 4: Ilhas Desconexas")
    adj4 = [[1], [], [3], []]
    d4, p4 = spt(0, adj4)
    # Infinito aqui é 4 (len da lista)
    print(f"Distâncias: {d4}")
    assert d4 == [0, 1, 4, 4]
    print("✅ Passou\n")

    # TESTE 5: Caminho Longo vs Curto
    # 0 -> 1 -> 2 -> 3 (Longo)
    # 0 -> 3 (Curto)
    # BFS garante o menor caminho (camadas).
    print(">>> Teste 5: Atalho (Shortest Path)")
    adj5 = [[1, 3], [2], [3], []]
    d5, p5 = spt(0, adj5)
    print(f"Distâncias: {d5}")
    assert d5 == [0, 1, 2, 1] # Distância pro 3 tem que ser 1, não 3
    assert p5[3] == 0         # Pai do 3 tem que ser o 0, não o 2
    print("✅ Passou\n")

    print("🏆 PARABÉNS! SEU CÓDIGO ESTÁ BLINDADO!")

if __name__ == "__main__":
    rodar_testes()
