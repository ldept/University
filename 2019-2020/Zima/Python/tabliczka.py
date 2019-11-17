def tabliczka(x1,x2,y1,y2):
    start_padding = len(str(x2)) + 2
    padding = len(str(x2*y2)) + 2

    print(''.rjust(start_padding+1), end='')
    
    for y in range(y1,y2+1):
        print(repr(y).rjust(padding), end='')
    print('')
    for x in range(x1,x2+1):
        print(repr(x).rjust(padding), end='')
        for y in range(y1,y2+1):
            print(repr(y*x).rjust(padding), end='')
        print('')


tabliczka(3,5,2,4)
tabliczka(1,10,1,10)
tabliczka(1,10,20,30)
tabliczka(10,20,20,30)
