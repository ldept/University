//
// Created by lukasz on 28.02.18.
//

#include "figura.h"
void inicjuj_figure(Figura *f,int typ){

    printf("\n Wpisz wspolrzedne punktow: x1 y1 x2 y2 ... \n");
    int iter = 0;
    switch(typ){
        case TROJKAT:
            iter = 3;
            break;
        case KOLO:
            iter = 2;
            break;
        case KWADRAT:
            iter = 4;
            break;
        default:
            break;
    }
    for(int i = 0; i<iter; i++){
        scanf(" %f ", &f->tabx[i]);

        scanf(" %f", &f->taby[i]);
    }
}
float pole(Figura *f){
    float pol = 0.0;
    float pi = 3.14;
    float odleglosc;
    float x1,x2;
    switch (f->typ){
        case TROJKAT:
            pol = ((f->tabx[1] - f->tabx[0]) * (f->taby[2] - f->taby[0])) - ((f->taby[1] - f->taby[0]) * (f->tabx[2]-f->tabx[0]));
            pol *= 0.5;
            if(pol < 0) pol = -pol;
            break;
        case KOLO:
            odleglosc = ((f->tabx[0] - f->tabx[1]) * (f->tabx[0] - f->tabx[1])) + ((f->taby[0] - f->taby[1])*(f->taby[0] - f->taby[1]));
            pol = pi * odleglosc;
            break;
        case KWADRAT:
            x1,x2;
            x1 = f->tabx[0];
            for(int i = 1;i<4;i++){
                if(f->tabx[i] == x1){
                    x2 = f->tabx[i];
                    break;
                }
            }
            pol = (x1-x2) * (x1-x2);
            break;
    }
    return pol;
}
void przesun(Figura *f, float x, float y){

    int iter = 0;
    switch (f->typ){
        case TROJKAT:
            iter = 3;
            break;
        case KOLO:
            iter = 2;
            break;
        case KWADRAT:
            iter = 4;
            break;
        default:
            break;
    }
    for(int i = 0; i < iter; i++){
        f->tabx[i] += x;
        f->taby[i] += y;
    }
}
float sumapol(Figura *f, int size){
    int wynik = 0;
    for(int i = 0; i < size; i++){
        wynik += pole(&f[i]);
    }
    return wynik;
}