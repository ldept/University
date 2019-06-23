#include <stdio.h>
#include "figura.h"

int main() {

    Figura f;
    f.typ = TROJKAT;
    //int size = 1;
    inicjuj_figure(&f,f.typ);
    printf("%f", pole(&f) );
    przesun(&f, 0.5, 0.5);
    //printf("%f", sumapol(&f,size) );
    return 0;
}