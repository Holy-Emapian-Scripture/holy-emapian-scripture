def problema_1(n: int, A: list[int]) -> int:
    qtd = 0
    sorv = [0] * n
    sorv[n-1] = A[n-1]
    qtd += A[n-1]
    for i in range (n-2, -1, -1):
        if sorv[i+1] > A[i]:
            qtd += A[i]
            sorv[i] = A[i]
        elif sorv[i+1] <= A[i]:
            prev = sorv[i + 1] - 1
            if prev > 0:
                qtd += prev
                sorv[i] =  sorv[i + 1] - 1
    return qtd

print(problema_1(5,[1,2,1,3,6]))
print(problema_1(5, [3,2,5,4,10]))
print(problema_1(4,[2,2,2,2]))

    # for i in range (n-1, -1, -1):
    #     if A[i] > A[i - 1] and A[i - 1] > min_now:
    #         qtd += A[i]
    #     elif A[i] > A[i - 1] and A[i - 1] > min_now:
    #         min_now = min(min_now, A[i])
    #         qtd += min_now
    #     else:
    #         if min_now > 1:
                 
    #         else:
    #             break

    # if A[0] > min_now:
    #     qtd += min_now
    # else: 
    #     qtd += A[0] 


            # if A[i] > A[i - 1] and A[i - 1] > min_now:
        #     qtd += A[i]
        # elif A[i] > A[i - 1] and A[i - 1] < min_now:
        #     min_now = A[i - 1]
        #     qtd += A[i]
        # elif A[i] < A[i - 1] and A[i] > min_now:
        #     qtd += A[i] 
        # elif A[i] < A[i - 1] and A[i] < min_now:
        #     min_now = A[i]
        #     qtd += A[i - 1] - 1 


    # for i in range(n):
    #     if A[i] not in hasht:
    #         hasht[A[i]] = 1
    #     else:
    #         hasht[A[i]] += 1

    # for i in range(n - 1):
    #     if A[i] < A[i + 1] and A[i] != min_a:
    #         qtd += min_a - 1
    #     elif A[i] < A[i + 1] and A[i] == min_a and hasht[A[i]] > 1:
    #         hasht[A[i]] -= 1
    #         qtd += min_a 
    #     elif A[i] > A[i + 1] and A[i] != max_a:
    #         qtd += A[i + 1] - 1
    #     else:
    #         hasht[A[i]] -= 1
    #         qtd += max_a 
    
    # if A[n - 1] > A[n - 2]:
    #     qtd += A[n - 1]
    # else: 
    #     qtd += A[n - 2] - 1

    # return qtd


#     for i in range(n - 1):
#         if A[i] < A[i+1] and hasht[A[i]] > 1:
#             hasht[A[i]] -= 1
#             qtd += A[i] - 1
#             last_add = qtd 
#         elif A[i] < A[i+1] and hasht[A[i]] == 1:
#             qtd += A[i]
#             last_add = qtd 
#         elif A[i] > A[i+1] and hasht[A[i]] > 1:
#             hasht[A[i]] -= 1
#             qtd += A[i] - 1
#             last_add = qtd
#         else:
#             qtd += A[i + 1] - 1
#             last_add = qtd



        #     qtd += A[i]
        #     last_add = qtd        
        # elif A[i] > A[i+1]:
        #     qtd += A[i + 1] - 1
        #     last_add = qtd
        # else:
        #     if last_add == A[i + 1] - 1:
        #         qtd += A[i + 1]
        #     elif last_add < A[i + 1] - 1:
        #         qtd += A[i + 1] - 1
        #     else:
        #         continue

testes = [
    # Exemplos fornecidos na imagem (Corretos)
    (5, [1, 2, 1, 3, 6], 10),     # q = [0, 0, 1, 3, 6]
    (5, [3, 2, 5, 4, 10], 20),    # q = [1, 2, 3, 4, 10]
    (4, [2, 2, 2, 2], 3),         # q = [0, 0, 1, 2]

    # Casos de borda e adicionais (AGORA CORRIGIDOS)
    
    # Estoque sempre crescente (Correto)
    (5, [1, 2, 3, 4, 5], 15),    # q = [1, 2, 3, 4, 5]
    
    # Estoque sempre decrescente (Corrigido)
    (5, [5, 4, 3, 2, 1], 1),     # q = [0, 0, 0, 0, 1]
    
    # Estoque que quebra a sequência no meio (Correto)
    (5, [10, 11, 1, 10, 11], 22), # q = [0, 0, 1, 10, 11]
    
    # Casos simples (Corretos)
    (1, [10], 10),               # q = [10]
    (1, [0], 0),                 # q = [0]
    (3, [0, 0, 0], 0),           # q = [0, 0, 0]
    
    # Sequência longa onde o início é impossível (Corrigido)
    (7, [1, 1, 1, 1, 1, 10, 11], 22), # q = [0, 0, 0, 0, 1, 10, 11]
    
    # Sequência longa que quebra várias vezes (Correto)
    (7, [1, 1, 10, 1, 1, 10, 11], 22), # q = [0, 0, 0, 0, 1, 10, 11]
    
    # Estoque grande no início, mas inútil (Correto)
    (3, [100, 1, 2], 3),         # q = [0, 1, 2]
    
    # Estoque constante (Correto)
    (5, [5, 5, 5, 5, 5], 15),    # q = [1, 2, 3, 4, 5]
    
    # Outro caso de quebra (Corrigido)
    (6, [3, 4, 5, 1, 2, 3], 6)   # q = [0, 0, 0, 1, 2, 3]
]
for (n, A, esperado) in testes:
    resultado = problema_1(n, A)
    assert resultado == esperado, f"Falha para A={A}: Esperado {esperado}, obtido {resultado}"
print("Todos os testes passaram!")