
def pairwise(arr, max_local, min_local, max_global, min_global):
    for i in range(0, len(arr) - 1, 2):
        if arr[i] >= arr[i+1]:
            max_local = arr[i]
            min_local = arr[i + 1]
        else: 
            max_local = arr[i + 1]
            min_local = arr[i]
            
        
        if max_local > max_global:
            max_global = max_local
        if min_local < min_global:
            min_global = min_local

    return min_global, max_global

def comparation_problem(arr):
    max_global = -float('inf')
    min_global = float('inf')
    max_local = 0
    min_local = 0

    if len(arr) % 2 == 0:
        min_global, max_global = pairwise(arr, max_local, min_local, max_global, min_global)
    else:
        min_global, max_global = pairwise(arr, max_local, min_local, max_global, min_global)
        
        k = len(arr) - 1 
        max_local = arr[k]
        min_local = arr[k]
    
        if max_local > max_global:
            max_global = max_local
        if min_local < min_global:
            min_global = min_local

    return (min_global, max_global)

def test_comparation_problem():
    assert comparation_problem([42]) == (42, 42)
    assert comparation_problem([1, 10]) == (1, 10)
    assert comparation_problem([10, 1]) == (1, 10)
    assert comparation_problem([1, 2, 3, 4, 5, 6]) == (1, 6)
    assert comparation_problem([9, 8, 7, 6, 5]) == (5, 9)
    assert comparation_problem([7, 7, 7, 7, 7]) == (7, 7)
    assert comparation_problem([-5, -1, -9, 0, 3]) == (-9, 3)
    assert comparation_problem([10, 3, 5, 8, 1, 7]) == (1, 10)
    assert comparation_problem([2, 9, 1, 4, 6]) == (1, 9)
    assert comparation_problem([100, -50, 0, 25]) == (-50, 100)
    assert comparation_problem(list(range(1000))) == (0, 999)

    print("Todos os testes passaram com sucesso!")

if __name__ == "__main__":
    test_comparation_problem()
