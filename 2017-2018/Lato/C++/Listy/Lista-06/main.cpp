#include <iostream>
#include "Operandy.h"
#include "Operatory.h"

int main() {

    Wyrazenie *w1, *w2, *w3, *w4;
    Zmienna *x;
    x = new Zmienna("x");
    x->dodaj_do_zbioru("x",0);

    w1 = new Podziel(
            new Pomnoz(
                new Odejmij(
                        x,
                        new Liczba(1)),
                x),
            new Liczba(2));

    w2 = new Podziel(
            new Dodaj(
                    new Liczba(3),
                    new Liczba(5)
            ),
            new Dodaj(
                    new Liczba(2),
                    new Pomnoz(
                            x,
                            new Liczba(7)

                    )
            )
    );

    w3 = new Odejmij(
            new Dodaj(
                    new Liczba(2),
                    new Pomnoz(x,new Liczba(7))
            ),
            new Dodaj(
                    new Pomnoz(new Zmienna("y"),new Liczba (3)),
                    new Liczba(5)
            )
    );

    w4 = new Podziel(
            new Cos(
                    new Pomnoz(
                            new Dodaj(x,new Liczba(1)),
                            x
                    )
            ),
            new Potega(
                    new Exp(x),
                    new Liczba(2)
            )
    );
    for(int i = 0; i<3; i++){

        x->zmien_wartosc("x",0 + i * 0.5);
        std::cout << w1->opis() << ", wynik: " << w1->oblicz() << std::endl;
        std::cout << w2->opis() << ", wynik: " << w2->oblicz() <<  std::endl;
        std::cout << w3->opis() << ", wynik: " << w3->oblicz() <<  std::endl;
        std::cout << w4->opis() << ", wynik: " << w4->oblicz() <<  std::endl;
        std::cout << std::endl;

    }

    //Stale
    Wyrazenie *pi = new Pi();
    std::cout << "pi: " << pi->opis() << ", wynik: " << pi->oblicz() << std::endl;
    Wyrazenie *e = new E();
    std::cout << "e: " << e->opis() << ", wynik: " << e->oblicz() << std::endl;
    Wyrazenie *fi = new Fi();
    std::cout << "fi: " << fi->opis() << ", wynik: " << fi->oblicz() << std::endl;

    //Pozostale operatory
    Wyrazenie *log = new Logarytm(new Liczba(2),new Liczba(8));
    std::cout << "log: " << log->opis() << ", wynik: " << log->oblicz() << std::endl;
    return 0;
}