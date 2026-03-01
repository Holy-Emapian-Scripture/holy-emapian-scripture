def is_path_matrix(matrix, path):
    for order in range(len(path) - 1):
        if matrix[path[order]][path[order + 1]] != 1:
            return False
    return True

def is_simple_path(path):
    if len(set(path)) != len(path):
        return False
    return True


def is_path_list(list, path):
    for order in range(len(path) - 1):
        if path[order + 1] not in list[path[order]]:
            return False
    return True 


G_matrix = [
    [0, 1, 1, 1],  
    [1, 0, 0, 0],  
    [1, 0, 0, 1],  
    [1, 0, 1, 0]   
]

G_list = [
    [1, 2, 3],  
    [0],        
    [0, 3],     
    [0, 2]      
]

path_A = [1, 0, 2, 3]   #valido e simples
path_B = [0, 3, 1]      #invalido
path_C = [1, 0, 2, 3, 0]#valido e não simples

print(is_path_matrix(G_matrix, path_A))
print(is_path_matrix(G_matrix, path_B))
print(is_path_matrix(G_matrix, path_C))

print(is_path_list(G_list, path_A))
print(is_path_list(G_list, path_B))
print(is_path_list(G_list, path_C))

print(is_simple_path(path_A))
print(is_simple_path(path_B))
print(is_simple_path(path_C))