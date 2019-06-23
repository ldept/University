//
// Created by lukasz on 28.02.18.
//

#include <stdio.h>
#ifndef FIGURA_FIGURA_H
#define FIGURA_FIGURA_H
enum typfig{TROJKAT,KOLO,KWADRAT};

typedef struct Figura{

    int typ;
    float tabx[4];
    float taby[4];

}Figura;

void inicjuj_figure(Figura *f, int typ);
float pole(Figura *f);
void przesun(Figura *f, float x, float y);
float sumapol(Figura *f, int size);

#endif //FIGURA_FIGURA_H
