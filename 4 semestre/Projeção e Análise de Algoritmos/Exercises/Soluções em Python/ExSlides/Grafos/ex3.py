def is_subgraph_matrix(gmatrix, hmatrix):
    num_vertices = len(gmatrix)
    for row in range(num_vertices):
        for column in range(num_vertices):
            if hmatrix[row][column] == 1 and gmatrix[row][column] == 0:
                return False
    return True

def is_subgraph_list(glist,hlist):
    num_vertices = len(glist)
    for vi in range(num_vertices):
        for vj in hlist[vi]:
            if vj not in glist[vi]:
                return False
    return True

G = [
    [0, 1, 1, 0],
    [1, 0, 1, 0],
    [1, 1, 0, 0],
    [0, 0, 0, 0]
]

H1 = [  #válido
    [0, 1, 1, 0],
    [1, 0, 0, 0],
    [1, 0, 0, 0],
    [0, 0, 0, 0]
]

H2 = [  #inválido
    [0, 1, 1, 0],
    [1, 0, 1, 0],
    [1, 1, 0, 1], # H[2][3] é 1
    [0, 0, 1, 0]  # G[2][3] é 0
]

print(f"H1 é subgrafo de G? Matrix {is_subgraph_matrix(G, H1)}") # Deve ser True
print(f"H2 é subgrafo de G? Matrix {is_subgraph_matrix(G, H2)}") # Deve ser False

glist = [
    [1, 2],       
    [0, 2, 3],    
    [0, 1],       
    [1]           
]

hlist1 = [
    [2],       
    [3],       
    [0],       
    [1]        
]

hlist2 = [
    [1, 3],    
    [0],       
    [],        
    [0]        
]

print(f"H1 é subgrafo de G? List {is_subgraph_list(G, H1)}") # Deve ser True
print(f"H2 é subgrafo de G? List {is_subgraph_list(G, H2)}") # Deve ser False
