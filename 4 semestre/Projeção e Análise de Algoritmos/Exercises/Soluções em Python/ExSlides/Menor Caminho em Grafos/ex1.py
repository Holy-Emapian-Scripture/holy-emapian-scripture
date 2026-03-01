def dag_spt(list_adj):
    inf = len(list_adj)
    distance = [inf] * inf
    parent = [-1] * inf
    distance[0] = 0
    parent[0] = 0

    for i in range(inf):
        for vizinho in list_adj[i]:
            if distance[i] + 1 < distance[vizinho]:
                distance[vizinho] = distance[i] + 1
                parent[vizinho] = i
    
    return distance, parent

def rodar_testes():
    
    # TESTE 1: Corrente Simples
    # 0 -> 1 -> 2 -> 3
    print("\n>>> Teste 1: Corrente Linear (0->1->2->3)")
    adj1 = [[1], [2], [3], []] 
    d1, p1 = dag_spt(adj1)
    print(f"Distâncias: {d1} (Esperado: [0, 1, 2, 3])")
    print(f"Pais:       {p1} (Esperado: [0, 0, 1, 2])")
    assert d1 == [0, 1, 2, 3]

    # TESTE 2: Bifurcação (Diamante)
    # 0 vai para 1 e 2.
    # Tanto 1 quanto 2 vão para 3.
    # Caminhos: 0->1->3 (len 2) e 0->2->3 (len 2). Ambos são ótimos.
    print("\n>>> Teste 2: Diamante (Caminhos iguais)")
    adj2 = [[1, 2], [3], [3], []]
    d2, p2 = dag_spt(adj2)
    print(f"Distâncias: {d2} (Esperado: [0, 1, 1, 2])")
    # Nota: O pai de 3 pode ser 1 ou 2, depende da ordem da lista de adjacência de 0.
    # Como 2 aparece DEPOIS de 1 na lista do 0? Não, eles estão em índices diferentes.
    # O loop roda i=1 (atualiza 3 via 1). Depois roda i=2 (tenta atualizar 3 via 2).
    # Como as distâncias são iguais, o segundo NÃO atualiza (usa < estrito).
    # Então o pai deve ser o primeiro processado (1).
    print(f"Pais:       {p2} (Esperado: [0, 0, 0, 1])") 
    assert d2 == [0, 1, 1, 2]

    # TESTE 3: O Atalho (Shortest Path Real)
    # 0 -> 1 -> 2 -> 3 (Caminho longo, custo 3)
    # 0 -> 3 (Atalho direto, custo 1)
    # O algoritmo DEVE escolher o direto.
    print("\n>>> Teste 3: O Atalho")
    adj3 = [[1, 3], [2], [3], []]
    d3, p3 = dag_spt(adj3)
    print(f"Distâncias: {d3} (Esperado: [0, 1, 2, 1])")
    print(f"Pais:       {p3} (Esperado: [0, 0, 1, 0])")
    assert d3 == [0, 1, 2, 1]
    assert p3[3] == 0 # O pai do 3 tem que ser o 0, não o 2.

    # TESTE 4: Desconexos (Ilha)
    # 0 -> 1. O vértice 2 e 3 estão isolados entre si.
    print("\n>>> Teste 4: Vértices Inalcançáveis")
    adj4 = [[1], [], [3], []]
    d4, p4 = dag_spt(adj4)
    # Infinito aqui é 4 (len(adj))
    print(f"Distâncias: {d4} (Esperado: [0, 1, 4, 4])")
    assert d4 == [0, 1, 4, 4]

    # TESTE 5: A FALHA (Ordem não topológica)
    # Grafo: 0 <- 1 (1 aponta para 0).
    # Ordem do array: [vizinhos do 0, vizinhos do 1]
    # 0 não tem vizinhos. 1 tem vizinho 0.
    # Como o loop vai de 0 a 1, quando chegar no 1, ele tenta atualizar o 0.
    # Mas o algoritmo "pensa" que o 0 é a origem fixa.
    # Vamos tentar algo mais sutil: 0 -> 2 <- 1. Começando de 0.
    # Se a gente quer testar a falha de "flecha pra trás": 2 -> 1 -> 0
    # Mas o código força start no 0.
    # Vamos tentar: 0 -> ... mas com uma aresta (2 -> 1).
    # 0 -> 2. E existe aresta 2 -> 1.
    # Caminho: 0 -> 2 -> 1.
    # Array: 0:[2], 1:[], 2:[1]
    print("\n>>> Teste 5: A FALHA (Aresta 2->1 processada tarde demais)")
    adj5 = [[2], [], [1]]
    d5, p5 = dag_spt(adj5)
    
    # O que acontece:
    # i=0: Atualiza dist[2] = 1.
    # i=1: dist[1] é INF. Não faz nada.
    # i=2: Atualiza dist[1] usando dist[2]. dist[1] vira 2.
    # Mas o loop ACABOU. Se tivesse um nó 3 conectado ao 1, ele ficaria INF.
    # Vamos adicionar um nó 3 conectado ao 1 para provar a falha.
    
    adj_fail = [[2], [3], [1], []] # 0->2->1->3
    # Ordem de processamento: 0, 1, 2, 3
    # Correto seria ordem topologica: 0, 2, 1, 3
    
    d_fail, p_fail = dag_spt(adj_fail)
    print(f"Grafo: 0->2->1->3 (Ordem incorreta no array)")
    print(f"Distâncias: {d_fail}")
    print(f"Esperado se fosse Dijkstra: [0, 2, 1, 3]")
    print("Nota: Veja como o vértice 3 ficou inalcançável (4) ou com valor errado\nporque quando processamos o 1, ele ainda não tinha recebido valor do 2.")

if __name__ == "__main__":
    rodar_testes()