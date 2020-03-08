def opt_dist(pic_row_list, block_length):
    min_changes = -1
    ones_in_row = pic_row_list.count("1")
    
    for i in range(len(pic_row_list) - block_length):
        ones_in_block = pic_row_list[i:i+block_length].count("1")
        ones_outside_of_block = ones_in_row - ones_in_block
        
        num_of_changes = ones_outside_of_block + (block_length - ones_in_block)
        if num_of_changes < min_changes or min_changes == -1:
            min_changes = num_of_changes

    return min_changes

input = "0010001000"
blk = 0
print(opt_dist(input,blk))