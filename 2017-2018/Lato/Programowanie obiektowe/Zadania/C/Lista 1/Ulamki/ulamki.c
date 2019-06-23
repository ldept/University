//
// Created by lukasz on 28.02.18.
//
#include "ulamki.h"


int NWD(int a, int b){

    int k;
    if(a<b){
        k = b;
        b = a;
        a = k;
    }
    while(b!=0){
        k = a%b;
        a = b;
        b = k;
    }
    return a;
}
int NWW(int a, int b){

    return ( (a*b) / NWD(a,b) );
}
int skrocenie(Ulamki *nowy){

    int skroc = NWD(nowy->licznik, nowy->mianownik);
    if(skroc < 0) skroc = -skroc;
    nowy->licznik = nowy->licznik / skroc;
    nowy->mianownik = nowy->mianownik / skroc;
    if(nowy->mianownik < 0) {
        nowy->mianownik = - nowy->mianownik;
        nowy->licznik = - nowy->licznik;
    }
}

Ulamki dodawanie_wsk(Ulamki x, Ulamki y){

    Ulamki *nowy = malloc(sizeof(Ulamki));

    if(x.mianownik == y.mianownik){
        nowy->licznik = ( x.licznik + y.licznik ) ;
        nowy->mianownik = x.mianownik;
    }
    else {
        int mian = NWW(x.mianownik,y.mianownik);
        int skalax = mian / x.mianownik;
        int skalay = mian / y.mianownik;
        nowy->licznik = skalax * x.licznik + skalay * y.licznik;
        nowy->mianownik = mian;
    }
    skrocenie(nowy);
    return *nowy;
}
Ulamki odejmowanie_wsk(Ulamki x, Ulamki y){

    Ulamki *nowy = malloc(sizeof(Ulamki));

    if(x.mianownik == y.mianownik){
        nowy->licznik = x.licznik - y.licznik;
        nowy->mianownik = x.mianownik;
    }
    else {
        int mian = NWW(x.mianownik,y.mianownik);
        int skalax = mian / x.mianownik;
        int skalay = mian / y.mianownik;
        nowy->licznik = skalax * x.licznik - skalay * y.licznik;
        nowy->mianownik = mian;
    }
    skrocenie(nowy);
    return *nowy;
}
Ulamki mnozenie_wsk(Ulamki x, Ulamki y){

    Ulamki *nowy = malloc(sizeof(Ulamki));
    nowy->licznik = x.licznik * y.licznik;
    nowy->mianownik = x.mianownik * y.mianownik;
    skrocenie(nowy);
    return *nowy;
}
Ulamki dzielenie_wsk(Ulamki x, Ulamki y){

    Ulamki *nowy = malloc(sizeof(Ulamki));
    nowy->licznik = x.licznik * y.mianownik;
    nowy->mianownik = x.mianownik * y.licznik;
    skrocenie(nowy);
    return *nowy;
}

void dodawanie_mod(Ulamki *x, Ulamki *y){

    if(x->mianownik == y->mianownik){
        y->licznik = y->licznik + x->licznik;
    }
    else{
        int mian = NWW(x->mianownik,y->mianownik);
        int skalax = mian / x->mianownik;
        int skalay = mian / y->mianownik;
        y->licznik = skalax * x->licznik + skalay * y->licznik;
        y->mianownik = mian;
    }
    skrocenie(y);
}
void odejmowanie_mod(Ulamki *x, Ulamki *y){

    if(x->mianownik == y->mianownik){
        y->licznik = x->licznik - y->licznik;
    }
    else{
        int mian = NWW(x->mianownik,y->mianownik);
        int skalax = mian / x->mianownik;
        int skalay = mian / y->mianownik;
        y->licznik = skalax * x->licznik - skalay * y->licznik;
        y->mianownik = mian;
    }
    skrocenie(y);
}
void mnozenie_mod(Ulamki *x, Ulamki *y){

    y->licznik *= x->licznik;
    y->mianownik *= x->mianownik;
    skrocenie(y);
}
void dzielenie_mod(Ulamki *x, Ulamki *y){
    int licznik_h = y->licznik;
    y->licznik = x->licznik * y->mianownik;
    y->mianownik = x->mianownik * licznik_h;
    skrocenie(y);
}