#include <stdio.h>
#include "ulamki.h"

int main() {
    Ulamki x = {1,2};
    Ulamki y = {-1,3};

    Ulamki wynik = dodawanie_wsk(x,y);
    printf("%i / %i \n", wynik.licznik,wynik.mianownik );

    wynik = odejmowanie_wsk(x,y);
    printf("%i / %i \n", wynik.licznik,wynik.mianownik );

    wynik = mnozenie_wsk(x,y);
    printf("%i / %i \n", wynik.licznik,wynik.mianownik );

    wynik = dzielenie_wsk(x,y);
    printf("%i / %i \n", wynik.licznik,wynik.mianownik );

    dodawanie_mod(&x,&y);
    printf("%i / %i \n",y.licznik,y.mianownik);

    y.licznik = -1;
    y.mianownik = 3;
    odejmowanie_mod(&x,&y);
    printf("%i / %i \n",y.licznik,y.mianownik);

    y.licznik = -1;
    y.mianownik = 3;
    mnozenie_mod(&x,&y);
    printf("%i / %i \n",y.licznik,y.mianownik);

    y.licznik = -1;
    y.mianownik = 3;
    dzielenie_mod(&x,&y);
    printf("%i / %i \n", y.licznik, y.mianownik);
}