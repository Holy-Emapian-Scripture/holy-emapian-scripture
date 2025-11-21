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


