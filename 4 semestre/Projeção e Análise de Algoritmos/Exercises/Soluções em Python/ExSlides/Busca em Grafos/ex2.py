def in_degree(list_adj):
    V = len(list_adj)
    in_d = [0] * V
    for v1 in list_adj:
        for v2 in v1:
            in_d[v2] += 1
    return in_d 


def has_topologic_order(list_adj):
    V = len(list_adj)
    order = [-1] * V
    counter = 0
    in_degre = in_degree(list_adj)
    while counter < V:
        i = 0
        while i < V:
            if in_degre[i] == 0  and order[i] == -1:
                break
            i += 1
        if i >= V:
            return False
        order [i] = counter
        counter += 1
        for v in list_adj[i]:
            in_degre[v] -= 1
    return True

# # Teste 1: Grafo Linha Reta (Válido)
# graph_1 = [[1], [2], []]
# print(f"Teste 1 (0->1->2): {has_topologic_order(graph_1)}") # Esperado: True

# # Teste 2: Grafo "Fork-Join" (Válido)
# graph_2 = [[1, 2], [3], [3], []]
# print(f"Teste 2 (Fork-Join): {has_topologic_order(graph_2)}") # Esperado: True

# # Teste 3: Múltiplas Fontes (Válido)
# graph_3 = [[2], [2], []]
# print(f"Teste 3 (Múltiplas Fontes): {has_topologic_order(graph_3)}") # Esperado: True

# # Teste 4: Grafo Desconectado (Válido)
# graph_4 = [[1], [], [3], []]
# print(f"Teste 4 (Desconectado): {has_topologic_order(graph_4)}") # Esperado: True

# # Teste 5: Grafo Vazio (Válido)
# graph_5 = []
# print(f"Teste 5 (Vazio): {has_topologic_order(graph_5)}") # Esperado: True

# # Teste 6: Grafo de Um Nó (Válido)
# graph_6 = [[]]
# print(f"Teste 6 (Um Nó): {has_topologic_order(graph_6)}") # Esperado: True


# # Teste 7: Ciclo Simples
# graph_7 = [[1], [0]]
# print(f"\nTeste 7 (Ciclo 0<->1): {has_topologic_order(graph_7)}") # Esperado: False

# # Teste 8: Ciclo Longo
# graph_8 = [[1], [2], [0]]
# print(f"Teste 8 (Ciclo 0->1->2->0): {has_topologic_order(graph_8)}") # Esperado: False

# # Teste 9: Auto-Loop (Self-loop)
# graph_9 = [[0]]
# print(f"Teste 9 (Auto-Loop 0->0): {has_topologic_order(graph_9)}") # Esperado: False

# # Teste 10: Ciclo em componente
# graph_10 = [[1], [0], [3], [2]]
# print(f"Teste 10 (Múltiplos Ciclos): {has_topologic_order(graph_10)}") # Esperado: False

# # Teste 11: Ciclo mais complexo
# graph_11 = [[1], [2], [3, 4], [1], []]
# print(f"Teste 11 (Ciclo 1->2->3->1): {has_topologic_order(graph_11)}") # Esperado: False

from collections import deque       #uma fila com ponteiro de entrada e saída

def topological_sort_efficient(list_adj):
    num_vertices = len(list_adj)
    in_degre = in_degree(list_adj)
    queue = deque()
    for i in range(num_vertices):
        if in_degre[i] == 0:
            queue.append(i)
    topological_order = []
    counter = 0

    while queue:
        u = queue.popleft() 
        topological_order.append(u)
        counter += 1
        for v in list_adj[u]:
            in_degre[v] -= 1
            if in_degre[v] == 0:
                queue.append(v)

    if counter == num_vertices:
        return topological_order  
    else:
        return None

graph_1 = [[1], [2], []]               # 0->1->2
graph_2 = [[1, 2], [3], [3], []]     # Fork-Join
graph_3 = [[2], [2], []]               # Múltiplas Fontes
graph_4 = [[1], [], [3], []]          # Desconectado

print(f"Teste 1: {topological_sort_efficient(graph_1)}")
print(f"Teste 2: {topological_sort_efficient(graph_2)}")
print(f"Teste 3: {topological_sort_efficient(graph_3)}")
print(f"Teste 4: {topological_sort_efficient(graph_4)}")

graph_7 = [[1], [0]]                 # 0<->1
graph_8 = [[1], [2], [0]]            # 0->1->2->0
graph_9 = [[0]]                      # 0->0

print(f"\nTeste 7 (Ciclo): {topological_sort_efficient(graph_7)}")
print(f"Teste 8 (Ciclo): {topological_sort_efficient(graph_8)}")
print(f"Teste 9 (Ciclo): {topological_sort_efficient(graph_9)}")