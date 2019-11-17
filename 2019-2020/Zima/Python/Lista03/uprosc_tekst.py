import string
from random import randint #sample

def uprosc_zdanie(tekst,max_dl_slowa,max_liczba_slow):
    # lista_slow = tekst.split()
    # remove = []
    # for index in range(len(lista_slow)):
    #     if len(lista_slow[index]) > dl_slowa:
    #         remove.append(index)
    # for index in range(len(remove)):
    #     del lista_slow[remove[index]]
    #     remove = [x - 1 for x in remove]

    lista_slow = [slowo for slowo in tekst.split() if len(slowo) <= max_dl_slowa]

    difference = len(lista_slow) - max_liczba_slow
    
    while difference > 0:
        del lista_slow[randint(0,len(lista_slow)-1)]
        difference -= 1
    
    #lista_slow = sample(lista_slow,max_liczba_slow)

    print(' '.join(lista_slow))


tekst = "Podział peryklinalny inicjałów wrzecionowatych kambium charakteryzuje się ścianą podziałową inicjowaną w płaszczyźnie maksymalnej."
uprosc_zdanie(tekst,10,5)
