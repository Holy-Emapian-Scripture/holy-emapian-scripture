import heapq

def cpt_djikstra_fast(v0, list_adj):
    num_vertices = len(list_adj)
    checked = [0] * num_vertices
    parent = [-1] * num_vertices
    distance = [float('inf')] * num_vertices
    parent[v0] = v0
    distance[v0] = 0
    heap = heapq()

    
    
    return parent,  distance 
