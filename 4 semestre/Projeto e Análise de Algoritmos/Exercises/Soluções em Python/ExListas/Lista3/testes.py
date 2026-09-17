import sys
from typing import List, Tuple

# --- Cole a sua função problema_8 aqui ---
def problema_8(n: int, m: int, transicoes: List[Tuple[int, int]]) -> int:
    adj = [[] for _ in range(n + 1)]
    for u, v in transicoes:
        adj[u].append(v)

    memo = [-1] * (n + 1)

    def dfs(u):
        if u == n:
            return 1
        
        if memo[u] != -1:
            return memo[u]
        
        total = 0
        for v in adj[u]:
            total += dfs(v)
        
        memo[u] = total
        return total

    return dfs(1)

# --- BATERIA DE TESTES ---

def rodar_testes():
    testes = [
        {
            "nome": "Exemplo 1 da Tabela (Linha Simples)",
            "n": 3,
            "m": 2,
            "transicoes": [(1, 2), (2, 3)],
            "esperado": 1
        },
        {
            "nome": "Exemplo 2 da Tabela (Grafo do Desenho)",
            "n": 5,
            "m": 7,
            "transicoes": [
                (1, 3), (3, 4), (1, 2), (2, 5), 
                (1, 4), (4, 5), (3, 5)
            ],
            "esperado": 4
        },
        {
            "nome": "Exemplo 3 da Tabela (Alvo Inalcançável)",
            "n": 3,
            "m": 2,
            "transicoes": [(1, 2), (3, 2)], # O caminho morre no 2, o 3 é inalcançável do 1
            "esperado": 0
        },
        {
            "nome": "Losango Simples (Diamond)",
            "n": 4,
            "m": 4,
            "transicoes": [
                (1, 2), (1, 3), # Bifurcação
                (2, 4), (3, 4)  # Junção
            ],
            "esperado": 2
        },
        {
            "nome": "Conexão Direta",
            "n": 2,
            "m": 1,
            "transicoes": [(1, 2)],
            "esperado": 1
        }
    ]

    print("=== INICIANDO TESTES DO PROBLEMA 8 ===\n")
    todos_passaram = True

    for t in testes:
        try:
            resultado = problema_8(t['n'], t['m'], t['transicoes'])
            
            if resultado == t['esperado']:
                print(f"✅ {t['nome']}: Passou! (Caminhos: {resultado})")
            else:
                print(f"❌ {t['nome']}: Falhou.")
                print(f"   Esperado: {t['esperado']}")
                print(f"   Obtido:   {resultado}")
                todos_passaram = False
        except Exception as e:
            print(f"❌ {t['nome']}: Erro de Execução -> {e}")
            todos_passaram = False
    
    print("\n======================================")
    if todos_passaram:
        print("Todos os testes passaram com sucesso!")

if __name__ == "__main__":
    rodar_testes()