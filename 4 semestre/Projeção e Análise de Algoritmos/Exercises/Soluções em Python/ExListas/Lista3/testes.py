from collections import deque

def problema_4(n: int) -> list[list[int]]:
    num_vertices = 1
    board = [[-1] * n for i in range(n)]
    fila = deque()