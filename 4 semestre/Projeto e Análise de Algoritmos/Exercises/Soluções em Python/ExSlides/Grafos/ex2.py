class GraphAdjList:

    def __init__(self, num_vertices):
        self.num_vertices = num_vertices
        self.listadj = [[] for _ in range(num_vertices)]
        
    def has_edge(self, v1, v2):
        for i in range(len(self.listadj[v1])):
            if v2 in self.listadj[v1]:
                return True
        return False

    def add_edge(self, v1, v2):
        self.listadj[v1].append(v2)
        self.listadj[v2].append(v1)
        
    def remove_edge(self, v1, v2):
        self.listadj[v1].remove(v2)
        self.listadj[v2].remove(v1)

    def print_listadj(self):
        for vertex in range(self.num_vertices):
            print(f'{vertex}: {self.listadj[vertex]}')
    
    def print_matrix(self):
        matrix = [[0 for _ in range(self.num_vertices)] for i in range(self.num_vertices)]
        for vertex in range(self.num_vertices):
            for edge in self.listadj[vertex]:
                matrix[vertex][edge] = 1
            print(matrix[vertex])

if __name__ == "__main__":
    g = GraphAdjList(5)
    g.add_edge(0, 1)
    g.add_edge(0, 4)
    g.add_edge(1, 2)
    g.add_edge(1, 3)
    g.add_edge(1, 4)

    g.print_listadj()
    g.print_matrix()

    print(f"\nTem aresta 0-1? {g.has_edge(0, 1)}") # True
    print(f"Tem aresta 0-2? {g.has_edge(0, 2)}") # False

    print("\n... Removendo aresta (1, 4) ...")
    g.remove_edge(1, 4)
    g.print_listadj()