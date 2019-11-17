def square_root(n):
    k_squared = 0
    i = 0
    while k_squared <= n:
        i += 1
        k_squared += 2 * i - 1
    k = i-1
    return k

print(square_root(16))

