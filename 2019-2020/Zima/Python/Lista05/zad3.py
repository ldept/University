import itertools


def image_col(H,V):
    H_possibilities = list(itertools.product([1,0], repeat=len(H)))

    column_possibilities = []
    for i in range(len(H)):
        column_possibilities.append(list(filter(lambda x : sum(x) == H[i],H_possibilities)))    
    
    #total has all possible columns
    total = itertools.product(*column_possibilities)
    for columns in total:
        rows = [sum(x) for x in zip(*columns)]
        if rows == V:
            return columns

    return []

def image_row(H,V):
    return image_col(V,H)
    
def to_image(ls):
    return ['#' if x == 1 else ' ' for x in ls]
H = [2,1,3,1]
V = [1,3,1,2]
columns = image_col(H,V)
print(columns)


rows = image_row(H,V)

for i in rows:
    print(*to_image(i))
#print(list(itertools.product(*[[1,2,3], [4,5,6]])))