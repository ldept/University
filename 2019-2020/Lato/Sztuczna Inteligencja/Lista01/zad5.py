import random
from zad4 import opt_dist

def print_nonogram(nonogram):
    print(" ", end='')
    for i in range(len(nonogram)):
        print(col_numbers[i], end='')
    print()
    for index, row in enumerate(nonogram):
        print(row_numbers[index], end='')
        for col in row:
            print("#" if col==1 else ".", end='')
        print()

def print_nonogram_to_output(nonogram):
    with open("zad5_output.txt", "w") as output_file:
        for row in nonogram:
            for col in row:
                print("#" if col==1 else ".", end='', file=output_file)
            print("", file=output_file)

row_numbers = []
col_numbers = []

with open("zad5_input.txt") as file:
    row_size, col_size = [int(x) for x in next(file).split()]
    row_break = row_size
    for line in file:
        row_numbers.append(int(line.split()[0]))
        row_break-=1
        if(row_break == 0):
            break
    for line in file:
        col_numbers.append(int(line.split()[0]))

def init_ready_rows_cols(rows,cols):
    ready_rows = [(0,-1)] * len(rows)
    ready_cols = [(0,-1)] * len(cols)
    for index, row in enumerate(rows):
        dist = opt_dist(row, row_numbers[index])
        if dist == 0:
            ready_rows[index] = (1,dist)
        else:
            ready_rows[index] = (0,dist)
    for index, col in enumerate(cols):
        dist = opt_dist(col, col_numbers[index])
        if dist == 0:
            ready_cols[index] = (1,dist)
        else:
            ready_cols[index] = (0,dist)
    return ready_rows, ready_cols

def update_ready_rows_cols(rows, ready_rows, cols, ready_cols, row_index, col_index):
    # for i in range(len(rows)):
    #     row_dist = opt_dist(rows[row_index], row_numbers[row_index])  
    #     ready_rows[row_index] = (1, row_dist) if row_dist == 0 else (0, row_dist)
    # for i in range(len(cols)):
    #     col_dist = opt_dist(cols[col_index], col_numbers[col_index])
    #     ready_cols[col_index] = (1, col_dist) if col_dist == 0 else (0, col_dist)
    row_dist = opt_dist(rows[row_index], row_numbers[row_index])
    col_dist = opt_dist(cols[col_index], col_numbers[col_index])
    ready_rows[row_index] = (1, row_dist) if row_dist == 0 else (0, row_dist)
    ready_cols[col_index] = (1, col_dist) if col_dist == 0 else (0, col_dist)   

def get_populated_grid():
    return [[random.randint(0,1) for i in range(col_size)] for j in range(row_size)]
    #return [[0]*(col_size-1) for i in range(row_size)]

def transpose(rows):
    return [list(x) for x in zip(*rows)]

def find_best_index(ready_rows, ready_cols, rows, cols, row_index):
    (col_index, max_dist) = (-1,-1)
    row_dist =  ready_rows[row_index][1]
    cols_to_change = []
    for index, (ready, col_dist) in enumerate(ready_cols):
        test_col = cols[index].copy() #copy
        test_col[row_index] =  int(not test_col[row_index]) #change of that one (i,j) spot
        prev_dist = col_dist + row_dist
        if prev_dist == 0:
            continue
        test_row = rows[row_index].copy()
        test_row[index] = int(not test_row[index])
        new_dist = opt_dist(test_row, row_numbers[row_index]) + opt_dist(test_col, col_numbers[index]) #sum change in match level
        if max_dist == -1 or prev_dist - new_dist > max_dist: #if new best then flush the list
            cols_to_change = [index]
            max_dist = prev_dist - new_dist
        elif prev_dist - new_dist == max_dist and max_dist != -1: #if as good as previously checked - add to potential outcome
            cols_to_change.append(index)

    col_index = cols_to_change[random.randint(0,len(cols_to_change)-1)] #pick random col to change as outcome
    return (col_index, max_dist) #every column in cols_to_change has the same dist difference

def init_grid():
    rows = get_populated_grid()
    cols = transpose(rows)
    ready_rows, ready_cols = init_ready_rows_cols(rows, cols)
    return rows,cols,ready_rows, ready_cols
        
def get_random_bad(bad_rows_or_cols):
    if len(bad_rows_or_cols) == 0:
        return -1, -1
    random_bad = random.randint(0,len(bad_rows_or_cols-1))
    for index, elem in enumerate(bad_rows_or_cols):
        if elem[0] == 0:
            random_bad -= 1
        if random_bad <= 0 and elem[0] == 0:
            return index, elem[1]

def find_best_col(ready_rows, ready_cols, rows, cols, index):
    row_dist = ready_rows[index][1]
    best = 0
    idx = 0
    idx_to_change = []
    for j in range(len(cols)):
        col_dist = ready_cols[j][1]
        
        test_col = cols[j].copy()
        test_col[index] = int(not test_col[index])
        test_row = rows[index].copy()
        test_row[j] = int(not test_row[j])
        
        new_row_dist = opt_dist(test_row, row_numbers[index])
        new_col_dist = opt_dist(test_col, col_numbers[j])
        
        #higher == better
        change_indicator = (row_dist - new_row_dist) + (col_dist - new_col_dist)
        if change_indicator > best:
            best = change_indicator 
            idx_to_change = [j]
        elif change_indicator == best:
            idx_to_change.append(j)
    return idx_to_change[random.randint(0,len(idx_to_change)-1)]

def find_best_row(ready_rows, ready_cols, rows, cols, index):
    col_dist = ready_cols[index][1]
    best = 0
    idx = 0
    idx_to_change = []
    for i in range(len(rows)):
        row_dist = ready_rows[i][1]
        test_row = rows[i].copy()
        test_row[index] = int(not test_row[index])
        test_col = cols[index].copy()
        test_col[i] = int(not test_col[i])
        new_row_dist = opt_dist(test_row, row_numbers[i])
        new_col_dist = opt_dist(test_col, col_numbers[index])
        
        #higher == better
        change_indicator = (row_dist - new_row_dist) + (col_dist - new_col_dist)
        if change_indicator > best:
            best = change_indicator
            idx_to_change = [i]
        elif change_indicator == best:
            idx_to_change.append(i)
  
    return idx_to_change[random.randint(0,len(idx_to_change)-1)]


def solve():
    global row_numbers
    global col_numbers
    max_changes = row_size * col_size * 2

    while True:
        rows, cols, ready_rows, ready_cols = init_grid() #start again
        print("STARTING NONOGRAM:")
        print_nonogram(rows)

        for i in range(max_changes):
            bad_rows = [(index, "row") for index in range(len(ready_rows)) if ready_rows[index][0] == 0]
            bad_cols = [(index, "col") for index in range(len(ready_cols)) if ready_cols[index][0] == 0]
            bad_rows_and_cols = bad_cols + bad_rows
            if len(bad_rows_and_cols) == 0:
                print("ENDING NONOGRAM:")
                print_nonogram(rows)
                print_nonogram_to_output(rows)
                return 0
            #First fix all rows
            if len(bad_rows) != 0:
                (index, row_or_col) = bad_rows[random.randint(0,len(bad_rows)-1)]
            else: #if no rows left to fix start fixing columns
                (index, row_or_col) = bad_rows_and_cols[random.randint(0, len(bad_rows_and_cols) - 1)]

            if(row_or_col == "col"):
                row = find_best_row(ready_rows,ready_cols,rows,cols,index)# (row, dist) = find_best_index(ready_cols, ready_rows, cols, rows, index)
                cols[index][row] = int(not cols[index][row])
                rows[row][index] = int(not rows[row][index])
                update_ready_rows_cols(rows, ready_rows, cols, ready_cols, row, index)
            else:
                col = find_best_col(ready_rows,ready_cols,rows,cols,index)#(col, dist) = find_best_index(ready_rows, ready_cols, rows, cols, index)
                rows[index][col] = int(not rows[index][col])
                cols[col][index] = int(not cols[col][index])
                update_ready_rows_cols(rows, ready_rows, cols, ready_cols, index, col)
        print("At least i tried")
        print_nonogram(rows)
solve()
