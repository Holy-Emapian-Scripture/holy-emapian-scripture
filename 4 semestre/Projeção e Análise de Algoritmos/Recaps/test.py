def mst_prim_fastv1(list_adj):
    num_vertices = len(list_adj)
    parent = [-1] * num_vertices
    intree = [0] * num_vertices
    vertexcost = [float('inf')] * num_vertices
    parent[0] = 0
    intree[0] = True
    for vizinho, custo in list_adj[0]:
        parent[vizinho] = 0
        vertexcost[vizinho] = custo
    
    while True:
        mincost = float('inf')
        v1 = -1
        for v in range(num_vertices):
            if not intree[v] and vertexcost[v] < mincost:
                mincost = vertexcost[v]
                v1 = v
        if mincost == float('inf'):
            break
        intree[v1] = True
        for v2,custo in list_adj[v1]:
             if not intree[v2] and custo < vertexcost[v2]:
                vertexcost[v2] = custo
                parent[v2] = v1
    
    return parent

def rodar_teste(nome, grafo, esperado):
    print(f"Teste: {nome}")
    try:
        # Chamada sem o v0, conforme sua implementação
        resultado = mst_prim_fastv1(grafo)
        if resultado == esperado:
            print(f"✅ Sucesso! Resultado: {resultado}")
        else:
            print(f"❌ Falha.")
            print(f"   Esperado: {esperado}")
            print(f"   Obtido:   {resultado}")
    except Exception as e:
        print(f"❌ Erro de Execução: {e}")
    print("-" * 30)

if __name__ == "__main__":

    # TESTE 1: O Triângulo Clássico
    # 0 ligado a 1 (custo 10) e 2 (custo 5)
    # 2 ligado a 1 (custo 2) -> Atalho melhor que 0->1
    # Esperado: 0->2, 2->1. Pai de 2 é 0. Pai de 1 é 2.
    grafo_triangulo = [
        [(1, 10), (2, 5)], # 0
        [(0, 10), (2, 2)], # 1
        [(0, 5), (1, 2)]   # 2
    ]
    rodar_teste("Triângulo (Update de Custo)", grafo_triangulo, [0, 2, 0])

    # TESTE 2: Grafo Estrela (Hub)
    # 0 no centro ligado a todos.
    # Como 0 é a raiz, todos serão filhos diretos de 0 se as arestas diretas forem as melhores.
    grafo_estrela = [
        [(1, 1), (2, 4), (3, 3)], # 0
        [(0, 1)],                 # 1
        [(0, 4)],                 # 2
        [(0, 3)]                  # 3
    ]
    rodar_teste("Estrela (0 no centro)", grafo_estrela, [0, 0, 0, 0])

    # TESTE 3: Grafo Linear (Linguiça)
    # 0 --(1)--> 1 --(1)--> 2 --(1)--> 3
    # O algoritmo deve seguir a linha sequencialmente.
    grafo_linear = [
        [(1, 1)],       # 0
        [(0, 1), (2, 1)], # 1
        [(1, 1), (3, 1)], # 2
        [(2, 1)]        # 3
    ]
    rodar_teste("Linear (Propagação)", grafo_linear, [0, 0, 1, 2])

    # TESTE 4: Grafo Desconectado
    # 0 ligado a 1. 2 ligado a 3. Sem ponte entre os grupos.
    # Esperado: 0 e 1 conectados. 2 e 3 ficam com parent -1 (inalcançáveis).
    grafo_desc = [
        [(1, 10)], # 0
        [(0, 10)], # 1
        [(3, 5)],  # 2
        [(2, 5)]   # 3
    ]
    rodar_teste("Desconectado", grafo_desc, [0, 0, -1, -1])

    # TESTE 5: Competição de Arestas
    # 0->1 (custo 100)
    # 0->2 (custo 100)
    # 1->2 (custo 1) -> Aresta muito barata lá na frente
    # Lógica: 0 pega 1 (ou 2). Digamos que pegue 1.
    # Agora temos {0, 1}. Arestas: 0->2 (100), 1->2 (1).
    # 1->2 ganha disparado.
    grafo_comp = [
        [(1, 100), (2, 100)],
        [(0, 100), (2, 1)],
        [(0, 100), (1, 1)]
    ]
    # Nota: A ordem de escolha entre 1 e 2 na primeira passada depende do loop 'for v in range'.
    # Como o loop é crescente, ele vê o 1, mincost=100. Vê o 2, mincost=100 (não é menor, é igual).
    # Então ele escolhe o 1 primeiro.
    # Logo: 0->1, 1->2.
    rodar_teste("Competição de Custos", grafo_comp, [0, 0, 1])