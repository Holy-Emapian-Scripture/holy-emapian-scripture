def string_problem(string1, string2):
    str1 = list(string1)
    str2 = list(string2)
    len_str1 = len(str1)
    len_str2 = len(str2)
    M = [[0] * (len_str1 + 1) for _ in range(len_str2 + 1)]
    
    for j in range (1, len_str2 + 1):
        for i in range (1, len_str1 + 1):
            if str1[i - 1] == str2[j - 1]:
                M[j][i] = 1 + M[j-1][i-1]
            else:
                M[j][i] = max(M[j][i - 1], M[j - 1][i])
            
    return M[len_str2][len_str1]

def test_string_problem():
    assert string_problem('banana', 'banda') == 4  # LCS é "bana"
    assert string_problem('AGGTAB', 'GXTXAYB') == 4  # LCS é "GTAB"
    assert string_problem('abc', 'xyz') == 0  # LCS é ""
    assert string_problem('abcde', 'ace') == 3  # LCS é "ace"
    assert string_problem('abcdef', 'axbyczf') == 4 # LCS é "abcf"
    assert string_problem('hello', 'hello') == 5  # LCS é "hello"
    assert string_problem('', '') == 0
    assert string_problem('', 'abcde') == 0
    assert string_problem('abcde', '') == 0
    assert string_problem('jaj', 'jbj') == 2  # LCS é "jj"
    assert string_problem('aaaaa', 'baba') == 2  # LCS é "aaa"

    print("Todos os testes passaram com sucesso!")

test_string_problem()