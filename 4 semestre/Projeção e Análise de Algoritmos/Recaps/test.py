def mst_prim_slow(v0, list_adj):
    num_vertices = len(list_adj)
    parent = [-1] * num_vertices
    parent[v0] = v0
    while True:
        min = float('inf')
        treeV, newV = -1, -1
        for i in range(num_vertices):
            if parent[i] == -1:
                continue
            for vizinho, custo in list_adj[i]:
                if parent[vizinho] == -1 and custo < min:
                    min = custo
                    treeV = i
                    newV = vizinho
        if min == float('inf'):
            break
        parent[newV] = treeV

    return parent        

def testar(nome, grafo, inicio, esperado):
    print(f"Executando: {nome}...", end=" ")
    resultado = mst_prim_slow(inicio, grafo)
    
    if resultado == esperado:
        print("OK!")
    else:
        print("\n[ERRO]")
        print(f"   Obtido:   {resultado}")
        print(f"   Esperado: {esperado}")
    print("-" * 30)

if __name__ == "__main__":
    
    # TESTE 1: Grafo Simples (Triângulo)
    # 0 --(10)--> 1
    # 0 --(5)--> 2
    # 1 --(2)--> 2
    # MST esperada começando de 0:
    # 1. Escolhe aresta 0-2 (custo 5). Parent[2] = 0.
    # 2. Agora temos {0, 2}. Arestas disponiveis para fora:
    #    - De 0 para 1 (custo 10)
    #    - De 2 para 1 (custo 2) -> MELHOR!
    # 3. Escolhe 2-1. Parent[1] = 2.
    grafo_triangulo = [
        [(1, 10), (2, 5)], # 0
        [(0, 10), (2, 2)], # 1
        [(0, 5), (1, 2)]   # 2
    ]
    testar("Triângulo Simples (Start 0)", grafo_triangulo, 0, [0, 2, 0])

    # TESTE 2: Grafo Linear (Caminho)
    # 0 --(1)--> 1 --(1)--> 2 --(1)--> 3
    # O algoritmo deve seguir a linha.
    grafo_linha = [
        [(1, 1)],       # 0
        [(0, 1), (2, 1)], # 1
        [(1, 1), (3, 1)], # 2
        [(2, 1)]        # 3
    ]
    testar("Linha Reta", grafo_linha, 0, [0, 0, 1, 2])

    # TESTE 3: Grafo Desconectado
    # 0 --(5)--> 1
    # 2 (Isolado)
    # O algoritmo deve conectar 0 e 1, e deixar o 2 como -1.
    grafo_desc = [
        [(1, 5)], # 0
        [(0, 5)], # 1
        []        # 2
    ]
    testar("Desconectado", grafo_desc, 0, [0, 0, -1])

    # TESTE 4: Começando de outro vértice (v0 = 2)
    # Usando o mesmo triângulo do Teste 1, mas começando do 2.
    # 2 --(2)--> 1 (Melhor que 2->0 que custa 5) -> Parent[1] = 2
    # Agora temos {2, 1}.
    # Arestas para fora: 2->0 (5), 1->0 (10). Melhor é 2->0.
    # Parent[0] = 2.
    testar("Start diferente (v0=2)", grafo_triangulo, 2, [2, 2, 2])
