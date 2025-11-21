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

import math

# --- Função Auxiliar para Testes ---
def run_test(nome, grafo, inicio, esperado_dist, esperado_pai):
    print(f"--- {nome} ---")
    pais, distancias = cpt_djikstra_slow(inicio, grafo)
    
    passou_dist = distancias == esperado_dist
    passou_pai = pais == esperado_pai
    
    print(f"Distâncias: {distancias} -> {'OK' if passou_dist else 'FALHO'}")
    if not passou_dist: print(f"   Esperado: {esperado_dist}")
        
    print(f"Pais:       {pais} -> {'OK' if passou_pai else 'FALHO'}")
    if not passou_pai: print(f"   Esperado: {esperado_pai}")
    print()


# Teste 1: O Exemplo Numérico da nossa conversa anterior
# 0->1(5), 0->2(2), 2->1(1), 1->3(4), 2->3(8)
grafo_exemplo = [
    [(1, 5), (2, 2)], # Vértice 0: vizinhos 1 (custo 5) e 2 (custo 2)
    [(3, 4)],         # Vértice 1: vizinho 3 (custo 4)
    [(1, 1), (3, 8)], # Vértice 2: vizinhos 1 (custo 1) e 3 (custo 8)
    []                # Vértice 3: sem vizinhos saindo dele
]

# Teste 2: Grafo Desconectado
# 0->1(10). O vértice 2 e 3 estão isolados do 0.
grafo_desconectado = [
    [(1, 10)], # 0
    [],        # 1
    [(3, 5)],  # 2 (inalcançável a partir do 0)
    []         # 3
]

if __name__ == "__main__":
    # Teste 1
    # Esperamos: Distâncias [0, 3, 2, 7] e Pais [0, 2, 0, 1]
    run_test("Teste Numérico (Exemplo)", 
             grafo_exemplo, 
             0, 
             [0, 3, 2, 7], 
             [0, 2, 0, 1])

    # Teste 2
    # Esperamos: 0 e 1 com valores, 2 e 3 como infinito
    run_test("Teste Desconectado", 
             grafo_desconectado, 
             0, 
             [0, 10, float('inf'), float('inf')], 
             [0, 0, -1, -1])