# def coin_problem(v, coins):
#     qtd_coins = 0
#     counting_coins = 0
#     v_fake = v
#     coins_fake = coins.copy()
#     while counting_coins != v:
#         for coin in coins_fake:
#             if coin > v_fake:
#                 coins_fake.remove(coin)
#                 break
#             else:
#                 v_fake -= coin
#                 counting_coins += coin
#                 qtd_coins += 1
#                 break
    
#     return qtd_coins

def coin_problem(v, coins):
    counting_coins = 0
    v_fake = v

    for coin in coins:
        if v_fake == 0:
            break
        qtd = v_fake // coin 
        if qtd > 0:
            v_fake -= qtd * coin
            counting_coins += qtd

    return counting_coins

sistema_brl = [100, 50, 25, 10, 5, 1]
print(coin_problem(48, sistema_brl) )

def test_coin_problem():

    sistema_brl = [100, 50, 25, 10, 5, 1]
    assert coin_problem(48, sistema_brl) == 6, "Falha no Teste 1.1 (Valor 48)"
    assert coin_problem(99, sistema_brl) == 8, "Falha no Teste 1.2 (Valor 99)"
    
    # Teste 1.3: Valor exato de uma moeda
    assert coin_problem(25, sistema_brl) == 1, "Falha no Teste 1.3 (Valor 25)"
    
    # Teste 1.4: Soma de duas moedas
    # 75 = 1x50 + 1x25 = 2 moedas
    assert coin_problem(75, sistema_brl) == 2, "Falha no Teste 1.4 (Valor 75)"

    # --- Teste 2: Casos de Borda (Edge Cases) ---
    
    # Teste 2.1: Valor Zero
    assert coin_problem(0, sistema_brl) == 0, "Falha no Teste 2.1 (Valor 0)"
    
    # Teste 2.2: Apenas uma moeda no sistema
    sistema_simples = [1]
    # 7 = 7x1 = 7 moedas
    assert coin_problem(7, sistema_simples) == 7, "Falha no Teste 2.2 (Valor 7, Moeda 1)"
    
    # Teste 2.3: Apenas uma moeda no sistema (maior)
    sistema_simples_10 = [10]
    # 30 = 3x10 = 3 moedas
    assert coin_problem(30, sistema_simples_10) == 3, "Falha no Teste 2.3 (Valor 30, Moeda 10)"
    
    # --- Teste 3: Outros Sistemas (ordenados) ---
    
    # Teste 3.1: Outro sistema canônico [7, 3, 1]
    sistema_estranho = [7, 3, 1]
    # 15 = 2x7 + 1x1 = 3 moedas
    assert coin_problem(15, sistema_estranho) == 3, "Falha no Teste 3.1 (Sistema 7,3,1)"
    
    # Teste 3.2: Outro valor no sistema [7, 3, 1]
    # 12 = 1x7 + 1x3 + 2x1 = 4 moedas
    assert coin_problem(12, sistema_estranho) == 4, "Falha no Teste 3.2 (Valor 12)"

    print("\n--- SUCESSO! ---")
    print("Todos os testes passaram.")

# --- Executando os Testes ---
if __name__ == "__main__":
    # Eu já coloquei a solução gulosa correta na função
    # 'coin_problem' para você ver os testes passando.
    # Substitua pelo seu código para testar.
    try:
        test_coin_problem()
    except AssertionError as e:
        print("\n--- ERRO NO TESTE ---")
        print(f"O teste falhou: {e}")
    except Exception as e:
        print(f"\nUm erro inesperado ocorreu: {e}")
