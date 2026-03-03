def is_topological_matrix(matrix):
    num_vertices = len(matrix)
    for i in range (num_vertices):
        for j in range (num_vertices):
            if matrix[i][j] == 1 and i >= j:
                return False
    return True

def is_topological_list(list):
    num_vertices = len(list)
    for i in range (num_vertices):
        for j in range(len(list[i])):
            if i >= list[i][j]:
                return False
    return True

matriz_valida = [
    [0, 1, 1],
    [0, 0, 1],
    [0, 0, 0]
]
lista_valida = [
    [1, 2], 
    [2],     
    []       
]

matriz_invalida = [
    [0, 1, 0],
    [0, 0, 0],
    [0, 1, 0] 
]
lista_invalida = [
    [1],     
    [],      
    [1]      
]

print("--- Testes com Matriz ---")
print(f"Grafo 1 é topológico? {is_topological_matrix(matriz_valida)}")  # True
print(f"Grafo 2 é topológico? {is_topological_matrix(matriz_invalida)}") # False

print("\n--- Testes com Lista ---")
print(f"Grafo 1 é topológico? {is_topological_list(lista_valida)}")   # True
print(f"Grafo 2 é topológico? {is_topological_list(lista_invalida)}")  # False