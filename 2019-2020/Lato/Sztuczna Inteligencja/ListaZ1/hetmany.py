import random
import time
N = 6







def place_queens():
    # board NxN filled with zeroes - later 1 means that we can't put a queen in this place
    board = [ [0 for col in range(N)] for row in range(N)]
    
    current_row = 0

    #for every queen
    for i in range(N):
        
        empty_in_col = board[i].count(0)

        #if there is no empty place - restart 
        if empty_in_col == 0:
            return False
            #pick a position at random 
            random_free_pos = random.randint(1, board[i].count(0))
        
        nth_free_pos = 0
        for position_in_row in range(N):
            if board[current_row][position_in_row] == 0:
                nth_free_pos += 1
                if nth_free_pos == random_free_pos:
                    # col and row ain't free
                    for n in range(N):
                        board[n][position_in_row] = 1
                        board[current_row][n] = 1
                    # diagonals
                    # diag_max = max( N - 1 - current_row, N - 1 - position_in_row )
                    diag_max = N
                    for diag_down_right   in range(1, diag_max):
                        if current_row + diag_down_right >= N or position_in_row + diag_down_right >= N:
                            break  
                        board[current_row + diag_down_right][position_in_row + diag_down_right] = 1

                    for diag_down_left in range(1, diag_max):
                        if current_row + diag_down_left >= N or position_in_row - diag_down_left < 0:
                            break
                        board[current_row + diag_down_left][position_in_row - diag_down_left] = 1
                    
                    break
        current_row+=1
    
    return True



sum=0
# for i in range(50):
#     start = time.time()
#     place_queens()
#     end = time.time()
#     print(end - start)

for i in range(50):
   c = 0

   for i in range(100):
       if place_queens():
           c+=1
   sum+=c
   print(c / 100*100,"%")
print("srednia",sum/100*100/50)