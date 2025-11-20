from collections import deque

def problema_4(n: int) -> list[list[int]]:
    board = [[-1] * n for i in range(n)]                                                #começamos com o tabuleiro completo de -1
    fila = deque()                                                                      
    board[0][0] = 0
    fila.append([0,0])

    positions = [(2,1), (2,-1), (-2, 1), (-2, -1),
                 (1,2), (-1,2), (1,-2), (-1, -2)]
    while fila:
        x, y = fila.popleft()
        for dx, dy in positions:
            nx = x + dx 
            ny = y + dy
            if 0 <= nx <= n - 1 and 0 <= ny <= n - 1 and board[nx][ny] == -1:
                board[nx][ny] = board[x][y] + 1
                fila.append([nx, ny])
    return board

def print_bonito(matriz):
    for linha in matriz:
        print(" ".join(f"{x:2}" for x in linha))
    print("-" * 20)

def rodar_testes():
# --- TESTE 1: N = 3 (O teste do "Buraco no Meio") ---
    # Em um tabuleiro 3x3 começando de (0,0), o cavalo NUNCA chega em (1,1).
    print(">>> Teste 1: N = 3")
    res3 = problema_4(3)
    esperado3 = [
        [0, 3, 2],
        [3, -1, 1],
        [2, 1, 4]
    ]
    print_bonito(res3)
    assert res3 == esperado3, "Erro no N=3! O centro deveria ser -1."
    print("✅ Passou N=3\n")

    print(">>> Teste 2: N = 4")
    res4 = problema_4(4)
    esperado4 = [
        [0, 3, 2, 5],
        [3, 4, 1, 2],
        [2, 1, 4, 3],
        [5, 2, 3, 2] 
    ]
    print_bonito(res4)
    assert res4[0][0] == 0
    assert res4[1][2] == 1 # Movimento direto
    assert res4[3][3] == 2 # (0,0)->(1,2)->(3,3) ou (0,0)->(2,1)->(3,3)
    print("✅ Passou verificações do N=4\n")

    # --- TESTE 3: N = 8 (Tabuleiro Padrão) ---
    print(">>> Teste 3: N = 8 (Spot Check)")
    res8 = problema_4(8)
    
    # Checagens famosas de xadrez:
    # Canto oposto (7,7) leva 6 movimentos a partir de (0,0)
    move_canto = res8[7][7]
    print(f"Distância até (7,7): {move_canto}")
    
    assert res8[0][0] == 0
    assert res8[0][1] == 3 # Lado imediato precisa de 3 manobras
    assert res8[7][7] == 6 # Canto oposto
    
    print("✅ Passou verificações do N=8\n")
    
    print("🏆 PARABÉNS! SEU ALGORITMO DESTRUIU TUDO!")

if __name__ == "__main__":
    rodar_testes()