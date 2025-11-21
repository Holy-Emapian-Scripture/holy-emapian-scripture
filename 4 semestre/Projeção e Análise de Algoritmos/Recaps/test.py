import heapq

def cpt_dijkstra_fast(v0, list_adj):
    num_vertices = len(list_adj)
    checked = [False] * num_vertices
    parent = [-1] * num_vertices
    distance = [float('inf')] * num_vertices
    parent[v0] = v0
    distance[v0] = 0
    heap = []
    heapq.heappush(heap, (0, v0))

    while heap:
        dist_v1, v1 = heapq.heappop(heap)
        if dist_v1 > distance[v1]:
            continue
        if distance[v1] == float('inf'):
            break
        for v2, cost in list_adj[v1]:
            if not checked[v2]:
                if distance[v1] + cost < distance[v2]:
                    parent[v2] = v1
                    distance[v2] = distance[v1] + cost
                    heapq.heappush(heap, (distance[v2], v2))
        checked[v1] = True
    return parent, distance

def executar_teste(nome, grafo, inicio, exp_parent, exp_dist):
    print(f"Executando: {nome}...", end=" ")
    parent, distance = cpt_dijkstra_fast(inicio, grafo)
    
    passou = True
    if parent != exp_parent:
        print("\n[FALHA] Parent incorreto.")
        print(f"   Obtido:   {parent}")
        print(f"   Esperado: {exp_parent}")
        passou = False
    
    if distance != exp_dist:
        print("\n[FALHA] Distance incorreto.")
        print(f"   Obtido:   {distance}")
        print(f"   Esperado: {exp_dist}")
        passou = False
        
    if passou:
        print("OK!")

if __name__ == "__main__":
    print("=== INICIANDO TESTES ===\n")

    # CASO 1: O Grafo Padrão (da nossa discussão)
    # 0->1(5), 0->2(2), 2->1(1), 1->3(4), 2->3(8)
    # Caminho para 3: 0 -> 2 -> 1 -> 3 (Custo 2+1+4 = 7)
    grafo_1 = [
        [(1, 5), (2, 2)], # 0
        [(3, 4)],         # 1
        [(1, 1), (3, 8)], # 2
        []                # 3
    ]
    executar_teste("Teste Básico", grafo_1, 0, 
                   exp_parent=[0, 2, 0, 1], 
                   exp_dist=[0, 3, 2, 7])

    # CASO 2: Grafo Desconectado
    # 0 conecta com 1. 2 conecta com 3. Não há ponte entre os grupos.
    grafo_2 = [
        [(1, 10)], # 0
        [],        # 1
        [(3, 5)],  # 2
        []         # 3
    ]
    # Espera-se que 2 e 3 fiquem com dist infinita e parent -1
    executar_teste("Teste Desconectado", grafo_2, 0, 
                   exp_parent=[0, 0, -1, -1], 
                   exp_dist=[0, 10, float('inf'), float('inf')])

    # CASO 3: Grafo Linear (Linguiça)
    # 0->1->2->3->4 (peso 1 cada)
    grafo_3 = [
        [(1, 1)], # 0
        [(2, 1)], # 1
        [(3, 1)], # 2
        [(4, 1)], # 3
        []        # 4
    ]
    executar_teste("Teste Linear", grafo_3, 0,
                   exp_parent=[0, 0, 1, 2, 3],
                   exp_dist=[0, 1, 2, 3, 4])

    # CASO 4: Nó Único (Grafo de tamanho 1)
    grafo_4 = [
        [] # 0
    ]
    executar_teste("Teste Nó Único", grafo_4, 0,
                   exp_parent=[0],
                   exp_dist=[0])

    print("\n=== TESTES FINALIZADOS ===")