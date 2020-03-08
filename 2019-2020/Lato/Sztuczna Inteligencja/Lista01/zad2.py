#TODO: How variables are passed in python functions
dictionary = set()

with open("polish_words.txt") as file:
    for row in file: #line.split to get the whole line (one word), [0] to unpack from list
        dictionary.add(row[:-1]) 


def find_words_in_line(line, mem):
    if len(line) == 0:
        return (0, [])
    
    if line in mem:
        return mem[line]
    
    else:
        sum_in_line = -1
        words_in_line = []

        for i in range(1, len(line) + 1):
            
            word = line[:i]
            tail = line[i:]

            if word in dictionary:
                #check if a sentence exists, and how "good" it is
                (sum_in_tail, words_in_tail) = find_words_in_line(tail, mem) 
                sum_tail_plus_word = sum_in_tail + i**2
                
                #if sentence with this word exists and is better than what we currently have, then take it as current best
                if sum_tail_plus_word > sum_in_line and sum_in_tail > -1: 
                    sum_in_line = sum_tail_plus_word
                    words_in_line = [word] + words_in_tail
        
        #memory is filled from the end (last word first) so we don't have to calculate the same thing several times
        mem[line] = (sum_in_line, words_in_line)
        return (sum_in_line, words_in_line)


# print("".join(word + ' ' for word in find_words_in_line("tamatematykapustkinieznosi",{})[1]))

with open("zad2_output.txt", "w") as output_file:
    with open("zad2_input.txt", "r") as input_file:
        for line in input_file:
            print("".join(word + ' ' for word in find_words_in_line(line[:-1],{})[1]), file=output_file)

        