def bellman_ford(v0, list_adj):
    num_vertices = len(list_adj)
    parent = [-1] * num_vertices
    distance = [float('inf')] * num_vertices
    parent[v0] = v0
    distance[v0] = 0
    for i in range(num_vertices - 1):
        for j in range(num_vertices):
            for vizinho, custo in list_adj[j]:
                if distance[j] + custo < distance[vizinho]:
                    parent[vizinho] = j
                    distance[vizinho] = distance[j] + custo

    for j in range(num_vertices):
        for vizinho, custo in list_adj[j]:
            if distance[j] + custo < distance[vizinho]:
                return False
    
    return parent, distance

def run_test(nome, grafo, inicio):
    print(f"--- {nome} ---")
    resultado = bellman_ford(inicio, grafo)
    
    if resultado == False:
        print("Resultado: CICLO NEGATIVO DETECTADO")
    else:
        pais, dists = resultado
        print(f"Distâncias: {dists}")
        print(f"Pais:       {pais}")
    print()

if __name__ == "__main__":
    # CASO 1: Grafo Normal (Dijkstra também resolveria)
    # 0->1(5), 0->2(2), 2->1(1)
    # Caminho 0->1 custa 5. Caminho 0->2->1 custa 3.
    grafo_normal = [
        [(1, 5), (2, 2)],
        [],
        [(1, 1)]
    ]
    run_test("Teste 1: Grafo Simples", grafo_normal, 0)
    # Esperado: Dist [0, 3, 2]

    # CASO 2: Arestas Negativas (mas SEM ciclo negativo)
    # 0->1 (custo 10)
    # 1->2 (custo -5)
    # Total 0->2 é 5. Tudo válido.
    grafo_negativo_valido = [
        [(1, 10)],
        [(2, -5)],
        []
    ]
    run_test("Teste 2: Negativo Válido", grafo_negativo_valido, 0)
    # Esperado: Dist [0, 10, 5]

    # CASO 3: Ciclo Negativo (O pesadelo)
    # 0->1 (1)
    # 1->2 (2)
    # 2->1 (-5) -> Ciclo entre 1 e 2 com custo líquido -3
    grafo_ciclo = [
        [(1, 1)],       # 0
        [(2, 2)],       # 1
        [(1, -5)]       # 2
    ]
    run_test("Teste 3: Ciclo Negativo", grafo_ciclo, 0)
    # Esperado: CICLO NEGATIVO DETECTADO