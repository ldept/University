def romb(n):
    row = '#'
    for _ in range(1, n+1):
        print(row.center(2*n + 2))
        row += '##'
    
    print(row.center(2*n + 2))
    
    for _ in range(1, n+1):
        row = row[2:]
        print(row.center(2*n + 2))


romb(4)