class GraphMatrix:

    def __init__(self, num_vertices):
        self.num_vertices = num_vertices
        self.matrix = [[0 for _ in range(num_vertices)] for i in range(num_vertices)]

    def has_edge(self, v1, v2):
        if 0 <= v1 < self.num_vertices and 0 <= v2 < self.num_vertices:
            return self.matrix[v1][v2]
        return False

    def add_edge(self, v1, v2):
        if 0 <= v1 < self.num_vertices and 0 <= v2 < self.num_vertices:
            self.matrix[v1][v2] = 1
            self.matrix[v2][v1] = 1
        else:
            print("Erro")

    def remove_edge(self, v1, v2):
        if 0 <= v1 < self.num_vertices and 0 <= v2 < self.num_vertices:
            self.matrix[v1][v2] = 0
            self.matrix[v2][v1] = 0
        else:
            print("Erro")
        
    def print_listadj(self):
        for v1 in range(self.num_vertices):
            list_adj = []
            for v2 in range(self.num_vertices):
                if self.has_edge(v1, v2):
                    list_adj.append(f"({v1},{v2})")
            print(list_adj)

    def print_matrix(self):
        for v1 in range(self.num_vertices):
            row = []
            for v2 in range(self.num_vertices):
                row.append(self.matrix[v1][v2])
            print(row)

#Exemplo
if __name__ == "__main__":
    
    g = GraphMatrix(5)

    g.add_edge(0, 1)
    g.add_edge(0, 4)
    g.add_edge(1, 2)
    g.add_edge(1, 3)
    g.add_edge(1, 4)
    g.add_edge(2, 3)
    g.add_edge(3, 4)

    g.print_matrix()
    g.print_listadj()

    print(f"\nTem aresta 0-1? {g.has_edge(0, 1)}")  # Deve ser True
    print(f"Tem aresta 0-2? {g.has_edge(0, 2)}")  # Deve ser False

    print("\n... Removendo aresta 1-4 ...")
    g.remove_edge(1, 4)

    g.print_matrix()
    print(f"Tem aresta 1-4? {g.has_edge(1, 4)}")  # Deve ser False
           