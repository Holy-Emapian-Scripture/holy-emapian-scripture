def mst_kruskal_slow(list_adj):
    num_vertices = len(list_adj)
    group = [v for v in range(num_vertices)]
    edges = []
    while True:
        mincost = float('inf')
        minv1, minv2 = -1, -1
        for v in range(num_vertices):
            for vizinho, custo in list_adj[v]:
                if v < vizinho and group[v] != group[vizinho] and custo < mincost:
                    mincost = custo
                    minv1 = v
                    minv2 = vizinho

        if mincost == float('inf'):
            break
        edges.append((minv1, minv2, mincost))
        leader1 = group[minv1]
        leader2 = group[minv2]
        for v in range(num_vertices):
            if group[v] == leader2:
                group[v] = leader1
    
    return edges

def executar_teste(nome, grafo, esperado, custo_total_esperado):
    print(f"=== {nome} ===")
    resultado = mst_kruskal_slow(grafo)
    
    # Calcula custo total obtido
    custo_obtido = sum(e[2] for e in resultado)
    
    # Ordena as listas para comparação justa (caso haja empate na ordem)
    # Mas no Kruskal Slow determinístico, a ordem costuma ser estável.
    passou_arestas = sorted(resultado) == sorted(esperado)
    passou_custo = custo_obtido == custo_total_esperado
    
    if passou_arestas and passou_custo:
        print("✅ SUCESSO")
        print(f"   Arestas: {resultado}")
        print(f"   Custo:   {custo_obtido}")
    else:
        print("❌ FALHA")
        print(f"   Esperado: {esperado} (Custo {custo_total_esperado})")
        print(f"   Obtido:   {resultado} (Custo {custo_obtido})")
    print()

if __name__ == "__main__":

    # TESTE 1: Triângulo Básico
    # 0-1 (10), 0-2 (5), 1-2 (2)
    # Ordem de escolha: 
    # 1. (1, 2, 2) - Menor global
    # 2. (0, 2, 5) - Segundo menor
    # 3. (0, 1, 10) - Ignorado pois 0 e 1 já estarão no mesmo grupo (via 2)
    grafo_triangulo = [
        [(1, 10), (2, 5)],
        [(0, 10), (2, 2)],
        [(0, 5), (1, 2)]
    ]
    executar_teste("Triângulo", grafo_triangulo, 
                   esperado=[(1, 2, 2), (0, 2, 5)], 
                   custo_total_esperado=7)

    # TESTE 2: Grafo Desconectado (Duas ilhas)
    # Ilha 1: 0-1 (custo 5)
    # Ilha 2: 2-3 (custo 10)
    # O algoritmo deve pegar ambas as arestas.
    grafo_desc = [
        [(1, 5)],   # 0
        [(0, 5)],   # 1
        [(3, 10)],  # 2
        [(2, 10)]   # 3
    ]
    executar_teste("Desconectado", grafo_desc,
                   esperado=[(0, 1, 5), (2, 3, 10)],
                   custo_total_esperado=15)

    # TESTE 3: Ordem Inversa (Pesos decrescentes)
    # 0--1 (Peso 30)
    # 1--2 (Peso 20)
    # 2--3 (Peso 10)
    # O algoritmo TEM que pegar o 2-3 primeiro, depois 1-2, depois 0-1.
    grafo_inverso = [
        [(1, 30)],          # 0
        [(0, 30), (2, 20)], # 1
        [(1, 20), (3, 10)], # 2
        [(2, 10)]           # 3
    ]
    # Nota: O algoritmo retorna na ordem que encontrou.
    executar_teste("Ordem Inversa", grafo_inverso,
                   esperado=[(2, 3, 10), (1, 2, 20), (0, 1, 30)],
                   custo_total_esperado=60)

    # TESTE 4: Ciclo Quadrado (Pesos Iguais)
    # 0-1(1), 1-2(1), 2-3(1), 3-0(1)
    # Ele deve pegar 3 arestas e descartar a última que fecharia o quadrado.
    # A ordem exata depende da ordem do 'for', mas o custo deve ser 3.
    grafo_quadrado = [
        [(1, 1), (3, 1)], # 0
        [(0, 1), (2, 1)], # 1
        [(1, 1), (3, 1)], # 2
        [(2, 1), (0, 1)]  # 3
    ]
    # Provável ordem dos índices loops: (0,1), (0,3), (1,2). (2,3) será ciclo.
    executar_teste("Quadrado Pesos Iguais", grafo_quadrado,
                   esperado=[(0, 1, 1), (0, 3, 1), (1, 2, 1)],
                   custo_total_esperado=3)