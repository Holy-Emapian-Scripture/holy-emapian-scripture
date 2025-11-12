
def problema_2(n: int , k: int, C1: int, C2: int, A: list[int]) -> int:
    def analize_costs(A, start, end):
        


    return 0

        
    
    # # L = 2^n
    # n_fake = n
    # A = sorted(A)
    # costs = []

    # while n_fake > -1:
    #     if n_fake == n:
    #         if k != 0:
    #             costs.append(C2 * (2 ** n) * k)
    #     else:
    #         end = 0 
    #         start = k
    #         k_left = 0
    #         k_right = 0
    #         if end - start > 1:
    #             midk = (start + end) // 2
    #             while A[midk] > 2 ** n_fake:
    #                 #acha o meio exato para definir a quantidade de buracos para cada lado 

    #     n_fake -= 1




# Lista de testes no formato:
# (n, k, C1, C2, A, resultado_esperado)
testes_problema_2 = [
    
    # Exemplo 1 do enunciado
    # n=2 (L=4), k=2, C1=1, C2=2, A=[1, 3]
    # Custo(1,4) = min(Consertar=16, Dividir=C(1,2)+C(3,4))
    # C(1,2) = min(Consertar=4, Dividir=C(1,1)+C(2,2) = 2+1=3) -> 3
    # C(3,4) = min(Consertar=4, Dividir=C(3,3)+C(4,4) = 2+1=3) -> 3
    # Custo final = 3 + 3 = 6
    (2, 2, 1, 2, [1, 3], 6),

    # Exemplo 2 do enunciado
    # n=3 (L=8), k=2, C1=1, C2=2, A=[1, 7]
    # Custo(1,8) = min(Consertar=32, Dividir=C(1,4)+C(5,8))
    # C(1,4) com {1} = min(Consertar=8, Dividir=C(1,2)+C(3,4) = 3+1=4) -> 4
    # C(5,8) com {7} = min(Consertar=8, Dividir=C(5,6)+C(7,8) = 1+3=4) -> 4
    # Custo final = 4 + 4 = 8
    (3, 2, 1, 2, [1, 7], 8),

    # Caso onde C1 (sem buracos) é muito caro
    # n=2 (L=4), k=2, C1=1000, C2=1, A=[1, 3]
    # Custo(1,4) = min(Consertar=8, Dividir=C(1,2)+C(3,4))
    # C(1,2) = min(Consertar=2, Dividir=C(1,1)+C(2,2) = 1+1000=1001) -> 2
    # C(3,4) = min(Consertar=2, Dividir=C(3,3)+C(4,4) = 1+1000=1001) -> 2
    # Custo final = 2 + 2 = 4
    (2, 2, 1000, 1, [1, 3], 4),

    # Caso onde "Consertar" a estrada inteira é a melhor opção
    # n=3 (L=8), k=2, C1=100, C2=1, A=[1, 8]
    # Custo(1,8) = min(Consertar=16, Dividir=C(1,4)+C(5,8))
    # C(1,4) com {1} = min(Consertar=4, Dividir=C(1,2)+C(3,4) = 3+100=103) -> 4
    # C(5,8) com {8} = min(Consertar=4, Dividir=C(5,6)+C(7,8) = 100+3=103) -> 4
    # Custo final = min(16, 4+4=8) = 8
    (3, 2, 100, 1, [1, 8], 8),

    # Caso sem nenhum buraco (k=0)
    # n=3 (L=8), k=0, C1=100, C2=1, A=[]
    # Custo(1,8) = min(Consertar=C1=100, Dividir=C(1,4)+C(5,8))
    # C(1,4) = min(C1=100, Dividir=C(1,2)+C(3,4))
    # C(1,2) = min(C1=100, Dividir=C(1,1)+C(2,2) = 100+100=200) -> 100
    # C(3,4) -> 100
    # C(1,4) -> min(100, 100+100=200) -> 100
    # C(5,8) -> 100
    # Custo final = min(100, 100+100=200) = 100
    (3, 0, 100, 1, [], 100),

    # Todos os segmentos mínimos (L=1) têm buracos
    # n=2 (L=4), k=4, C1=100, C2=1, A=[1, 2, 3, 4]
    # Custo(1,4) = min(Consertar=16, Dividir=C(1,2)+C(3,4))
    # C(1,2) = min(Consertar=4, Dividir=C(1,1)+C(2,2) = 1+1=2) -> 2
    # C(3,4) = min(Consertar=4, Dividir=C(3,3)+C(4,4) = 1+1=2) -> 2
    # Custo final = 2 + 2 = 4
    (2, 4, 100, 1, [1, 2, 3, 4], 4),

    # Buracos duplicados (deve contar como múltiplos buracos)
    # n=2 (L=4), k=3, C1=1, C2=2, A=[1, 1, 3]
    # Custo(1,4) = min(Consertar(Nb=3)=24, Dividir=C(1,2)+C(3,4))
    # C(1,2) com {1,1} = min(Consertar(Nb=2)=8, Dividir=C(1,1)+C(2,2) = 4+1=5) -> 5
    # C(3,4) com {3} = min(Consertar(Nb=1)=4, Dividir=C(3,3)+C(4,4) = 2+1=3) -> 3
    # Custo final = 5 + 3 = 8
    (2, 3, 1, 2, [1, 1, 3], 8),
    
    # Apenas um buraco em uma estrada grande
    # n=4 (L=16), k=1, C1=10, C2=2, A=[7]
    # C(1,16) = min(Consertar=32, Dividir=C(1,8)+C(9,16))
    # C(1,8) com {7} = min(Consertar=16, Dividir=C(1,4)+C(5,8))
    # C(1,4) (Nb=0) -> min(C1=10, C(1,2)+C(3,4) = 10+10=20) -> 10
    # C(5,8) com {7} = min(Consertar=8, Dividir=C(5,6)+C(7,8))
    # C(5,6) (Nb=0) -> 10
    # C(7,8) com {7} = min(Consertar=4, Dividir=C(7,7)+C(8,8) = 2+10=12) -> 4
    # C(5,8) -> min(8, 10+4=14) -> 8
    # C(1,8) -> min(16, 10+8=18) -> 16
    # C(9,16) (Nb=0) -> 10
    # Custo final = min(32, 16+10=26) = 26
    (4, 1, 10, 2, [7], 26),
]

def rodar_testes():
    print("--- 🚀 Iniciando testes para o Problema 2 ---")
    total = len(testes_problema_2)
    passou = 0

    for i, (n, k, C1, C2, A, esperado) in enumerate(testes_problema_2):
        test_label = f"(n={n}, k={k}, C1={C1}, C2={C2}, A={A})"
        
        try:
            # Chama a sua função
            resultado = problema_2(n, k, C1, C2, A)
            
            # Compara o resultado
            if resultado == esperado:
                print(f"✅ Teste {i+1}/{total}: PASSOU")
                passou += 1
            else:
                print(f"❌ Teste {i+1}/{total}: FALHOU")
                print(f"   Entrada: {test_label}")
                print(f"   Esperado: {esperado}")
                print(f"   Recebido: {resultado}")
        
        except Exception as e:
            # Caso sua função dê algum erro (ex: recursão infinita, erro de índice)
            print(f"💥 Teste {i+1}/{total}: ERRO AO EXECUTAR")
            print(f"   Entrada: {test_label}")
            print(f"   Erro: {e}")

    print("\n--- 🏁 Resumo dos Testes ---")
    print(f"{passou} de {total} testes passaram.")
    if passou == total:
        print("🎉 Excelente! Todos os testes passaram!")
    else:
        print("🐞 Ops! Alguns testes falharam. Continue depurando.")

# --- Executa o testador ---
if __name__ == "__main__":
    rodar_testes()