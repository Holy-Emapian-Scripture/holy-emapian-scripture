def problema_3(n: int, A: list[int]) -> int:
    def hash_div(A):                                            #função para gerar a tabela hash dos divisores de cada número de A
        hasht = {}                                              #inicio a tabela
        A = list(set(A))                                        #transforma a lista em conjunto para fazer o hash sem duplicatas (O(n)) e depois em lista novamente (O(n))

        for i in range (len(A)):                                #
            if A[i] not in hasht:
                hasht[A[i]] = []
            root = int(A[i] ** 0.5)
            for k in range(1, root + 1):
                if A[i] % k == 0 and k != A[i] // k:
                    hasht[A[i]].append(k)
                    hasht[A[i]].append(A[i] // k)
                elif A[i] % k == 0:
                    hasht[A[i]].append(k)
            hasht[A[i]].sort(reverse=True)

        return hasht
    
    hash_divs = hash_div(A)
    dp = [0] * n 
    for i in range(n):
        for div in hash_divs[A[i]]:
            if div > 1:
                dp[div - 1] += dp[div - 2]
            else:
                dp[div - 1] += 1

    return sum(dp)     

print(problema_3(5, [1,4,2,3,5]))
print(problema_3(10, [1,6,2,8,5,3,4,10,2,9,3]))
