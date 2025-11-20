def problema_3(n: int, A: list[int]) -> int:
    def hash_div(A):                                            #função para gerar a tabela hash dos divisores de cada número de A
        hasht = {}                                              #inicio a tabela
        A = list(set(A))                                        #transforma a lista em conjunto para fazer o hash sem duplicatas (O(n)) e depois em lista novamente (O(n))

        for i in range (len(A)):                                #cria a hash para cada valor de A (O(n))
            if A[i] not in hasht:
                hasht[A[i]] = []
            root = int(A[i] ** 0.5)                             #tira a raiz para encontrar seus divisores 
            for k in range(1, root + 1):                        #vou até a raiz (O(raiz(n)))
                if A[i] % k == 0 and k != A[i] // k:            #se a divisão der zero e for diverente do resultado da divisão (acha o número e evita duplicata)
                    hasht[A[i]].append(k)                       #adiciona tanto o divisor quanto o resultado
                    hasht[A[i]].append(A[i] // k)               
                elif A[i] % k == 0:                             #para o caso de mesmos divisores (ex: 36 / 6 = 6)
                    hasht[A[i]].append(k)
            hasht[A[i]].sort(reverse=True)                      #ordem reversa para fazer o algoritmo (também O(raiz(n)))
        return hasht
    
    hash_divs = hash_div(A)                                     #pegamos o hash
    dp = [0] * n                                                #o item dp[i] mostra a quantidade de sequencias de tamanho i que conseguimos fazer   
    for i in range(len(A)):                                     #para cada item na nova lista
        for div in hash_divs[A[i]]:                             #e para cada divisor
                                                                #eu vejo a quantidade de subsequencias que tive de tamanho div - 1 até agora.
                                                                #até agora pois estou vendo a quantidade de subsequencias que consegui fazer com os números anteriores a A[i], o que faz sentido
            if div > 1:                                         #se esse divisor for maior que 1, eu consigo adicionar a subsequencia de atual a quantidade de subsequências anteriores 
                dp[div - 1] += dp[div - 2]                      #(como se apenas adicionasse esse novo divisor às subsequências de tamanhos div -1)
            else:                                               #caso seja divisor 1, então não temos subsequências anteriores e adicionamos só 1
                dp[div - 1] += 1

    return sum(dp) % 999999937                                  #retorna a soma

def rodar_testes():
    testes = [
        {
            "input": {"n": 3, "A": [1, 2, 2]},
            "esperado": 6,
            "descricao": "Exemplo do enunciado: [1], [2], [2], [1,2], [1,2], [2,2]"
        },
        {
            "input": {"n": 1, "A": [1]},
            "esperado": 1,
            "descricao": "Caso unitário simples"
        },
        {
            "input": {"n": 5, "A": [2, 2, 1, 5, 3]},
            "esperado": 7,
            "descricao": "Exemplo do enunciado embaralhado"
        },
        {
            "input": {"n": 4, "A": [4, 2, 4, 1]},
            "esperado": 7,
            "descricao": "Ordem inversa e saltos"
        },
        {
            "input": {"n": 6, "A": [6]},
            "esperado": 1,
            "descricao": "Único número com vários divisores (1, 2, 3, 6). Sequências: [6] valendo como pos 1, 2, 3 ou 6? Não! Apenas [6] pos 1 é válida sozinha. Se dp estiver zerado, ele só soma no div=1. Esperado = 1." 
        },
        {
             "input": {"n": 3, "A": [1, 2, 3]},
             "esperado": 5,
             "descricao": "Escadinha [1], [2], [3], [1,2], [1,2,3]"
        }
    ]

    passou_todos = True
    for i, t in enumerate(testes):
        res = problema_3(t["input"]["n"], t["input"]["A"])
        if res == t["esperado"]:
            print(f"✅ Teste {i+1} Passou: {t['descricao']}")
        else:
            print(f"❌ Teste {i+1} Falhou: {t['descricao']}")
            print(f"   Esperado: {t['esperado']}, Recebido: {res}")
            passou_todos = False
    
    if passou_todos:
        print("\n🏆 PARABÉNS! Seu código passou em todos os testes básicos.")

# Execute os testes
rodar_testes()