def compress(text):
    last_char = current_char = text[0]
    last_space_index = 0

    for index in range(1,len(text)):
        current_char = text[index]
        char_occurances = 0
        if 