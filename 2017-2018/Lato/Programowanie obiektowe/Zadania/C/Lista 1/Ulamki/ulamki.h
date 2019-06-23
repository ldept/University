//
// Created by lukasz on 28.02.18.
//

#ifndef UNTITLED_ULAMKI_H
#define UNTITLED_ULAMKI_H

#include <stdlib.h>



typedef struct Ulamki {

    int licznik;
    int mianownik;

} Ulamki;

int NWW(int a, int b);
int skrocenie(Ulamki *nowy);
Ulamki dodawanie_wsk(Ulamki x, Ulamki y);
Ulamki odejmowanie_wsk(Ulamki x, Ulamki y);
Ulamki mnozenie_wsk(Ulamki x, Ulamki y);
Ulamki dzielenie_wsk(Ulamki x, Ulamki y);
void dodawanie_mod(Ulamki *x, Ulamki *y);
void odejmowanie_mod(Ulamki *x, Ulamki *y);
void mnozenie_mod(Ulamki *x, Ulamki *y);
void dzielenie_mod(Ulamki *x, Ulamki *y);


#endif //UNTITLED_ULAMKI_H
