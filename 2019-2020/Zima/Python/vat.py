def vat_faktura(lista):
    suma = sum(lista)
    return suma * 0.23


def vat_paragon(lista):
    lista_vat = [item * 0.23 for item in lista]
    return sum(lista_vat)

zakupy = [0.2, 0.5, 4.59, 6]
print(vat_paragon(zakupy))
print(vat_faktura(zakupy))
print(vat_faktura(zakupy) == vat_paragon(zakupy))