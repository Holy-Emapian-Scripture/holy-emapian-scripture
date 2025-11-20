from collections import deque

def problema_4(n: int) -> list[list[int]]:
    board = [[-1] * n for i in range(n)]                                                #começamos com o tabuleiro completo de -1
    fila = deque()                                                                      #iniciamos um deque para servir de fila (adicionar a direita e retirar a esquerda em O(1))
    board[0][0] = 0                                                                     #vertice inicial marcado
    fila.append([0,0])                                                                  #adicionamos a fila as coordenadas 

    positions = [(2,1), (2,-1), (-2, 1), (-2, -1),                                      #fazemos a lista de todas as posições que um cavalo pode ir dado uma coordenada
                 (1,2), (-1,2), (1,-2), (-1, -2)]
    while fila:                                                                         #enquanto a fila não estiver vazia, ou seja, enquanto pudermos nos mover
        x, y = fila.popleft()                                                           #retiro a posição mais velha
        for dx, dy in positions:                                                        #para cada posição possível que podemos ir partindo da posição que pegamos da fila
            nx = x + dx                                                                 #essa seria a nova posição possivel (soma da posição atual + as possíveis pro cavalo)
            ny = y + dy
            if 0 <= nx <= n - 1 and 0 <= ny <= n - 1 and board[nx][ny] == -1:           #se não sairmos dos limites da borda e a célula ainda não tiver sido visitada
                board[nx][ny] = board[x][y] + 1                                         #somo a posição antiga + 1 
                fila.append([nx, ny])                                                   #coloco essa nova posição para ser analisada na fila
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