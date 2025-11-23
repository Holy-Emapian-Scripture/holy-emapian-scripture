from collections import deque


def problema_5(n: int, m: int, grid: list[list[str]]) -> int:
    water_queue = deque()                                                       #inicializamos duas filas, uma para monitorar a água
    player_queue = deque()                                                      #e outra para monitorar o jogador
    water_time = [[float('inf')] * m for _ in range(n)]                         #fazemos uma matriz para monitorar o avanço da água
    player_visited = [[False] * m for _ in range(n)]                            #matriz para saber onde o player já pisou
    
    player_start = None
    for r in range(n):                                                          #fazemos a primeira passada para entender onde o player e a água estão
        for c in range(m):
            if grid[r][c] == 'A':                                               #salvamos na fila
                water_queue.append((r, c))
                water_time[r][c] = 0
            elif grid[r][c] == 'V':
                player_start = (r, c)                                           #e no caso do player uma variável
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]                             #dimensões para andar da água

    while water_queue:                                                          #para cada água inicial                
        r, c = water_queue.popleft()
        for dr, dc in directions:                   
            nr, nc = r + dr, c + dc
            if 0 <= nr < n and 0 <= nc < m:                                     #verifamos se podemos andar para a próxima posição da água
                if grid[nr][nc] != '#' and water_time[nr][nc] == float('inf'):  #se nao tiver parede e estiver vazio (inf)
                    water_time[nr][nc] = water_time[r][c] + 1                   #o timing de aumento de água atual é da célula anterior a que veio + 1
                    water_queue.append((nr, nc))                                #apendamos para fazer essa verificação por toda a matriz

    vr, vc = player_start                                                       #agora, vamos andar com o player
    player_queue.append((vr, vc, 0)) 
    player_visited[vr][vc] = True                           
    if vr == 0 or vr == n-1 or vc == 0 or vc == m-1:                            #se ele já estiver na saída, ganhamos
        return 0

    while player_queue:                                                         #enquanto tivermos algo na fila
        r, c, time = player_queue.popleft()
        next_time = time + 1                                                    #contagem do tempo
        for dr, dc in directions:
            nr, nc = r + dr, c + dc                                                                                 
            if 0 <= nr < n and 0 <= nc < m:                                     #se não tivermos na borda 
                if grid[nr][nc] != '#' and not player_visited[nr][nc]:          #se não tivermos em nenhuma parede e lugares já visitados
                    if next_time < water_time[nr][nc]:                          #e se a água não tiver chegado ainda
                        if nr == 0 or nr == n-1 or nc == 0 or nc == m-1:        #se tivermos chegados a uma borda válida, então retornamos o tempo
                            return next_time                    
                        player_visited[nr][nc] = True                           #caso não, marcamos na matriz como verdadeiro
                        player_queue.append((nr, nc, next_time))                #e adicionamos a fila uma possibilidade existente para o participante
    
    return -1

def rodar_testes():
    # Caso 1 da Imagem (Saída esperada: 5)
    grid1 = [
        "########",
        "#A..V..#",
        "#. #.A#.#".replace(" ", ""), # Removendo espaços visuais pra garantir
        "#A#..#..",
        "#.######" 
    ]
    
    # Caso 2 da Imagem (Saída esperada: -1)
    grid2 = [
        "########",
        "#...V..#",
        "#. #..#.#".replace(" ", ""),
        "#.A..A..",
        "#.######"
    ]
    
    # Caso 3 da Imagem (Saída esperada: 0)
    # Nota: O 'V' está na posição (3, 7), que é a última coluna (borda).
    grid3 = [
        "########",
        "#A...#.#",
        "#. #.A#.#".replace(" ", ""),
        "#A#...#V",
        "#.######"
    ]

    testes = [
        ("Caso 1 (Normal)", 5, 8, grid1, 5),
        ("Caso 2 (Impossível)", 5, 8, grid2, -1),
        ("Caso 3 (Já na borda)", 5, 8, grid3, 0)
    ]

    print("=== INICIANDO TESTES DA IMAGEM ===\n")
    
    all_passed = True
    for nome, n, m, grid, esperado in testes:
        # Limpeza das strings (caso tenha copiado com espaços extras)
        grid_limpo = [linha.replace(" ", "") for linha in grid]
        
        resultado = problema_5(n, m, grid_limpo)
        
        if resultado == esperado:
            print(f"✅ {nome}: Passou! Resultado: {resultado}")
        else:
            print(f"❌ {nome}: Falhou.")
            print(f"   Esperado: {esperado}")
            print(f"   Obtido:   {resultado}")
            all_passed = False
    
    print("\n==================================")
    if all_passed:
        print("Todos os testes passaram conforme a imagem!")

if __name__ == "__main__":
    rodar_testes()