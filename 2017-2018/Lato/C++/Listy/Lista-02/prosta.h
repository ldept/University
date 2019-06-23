//
// Created by lukasz on 07.03.18.
//

#ifndef PROSTA_PROSTA_H
#define PROSTA_PROSTA_H

#include "punkt.h"
#include "wektor.h"

class Prosta{
private:
    double a;
    double b;
    double c;
    void postac_unormowana(double &a, double &b, double &c);

public:

    Prosta(const Punkt &punkt1,const Punkt &punkt2);
    Prosta(const Wektor &wektor);
    Prosta(double ap, double bp, double cp);
    Prosta(const Prosta &prosta,const Wektor &wektor);

    Prosta()= default;
    Prosta &operator=(const Prosta& prosta) = delete;
    Prosta(const Prosta& ) = delete;

    bool czy_prostopadly(const Wektor &wektor, const Prosta &prosta);
    bool czy_rownolegly(const Wektor &wektor, const Prosta &prosta);
    bool czy_na_prostej(const Punkt &punkt);

    double get_a()const;
    double get_b()const;
    double get_c()const;

};

bool czy_proste_prostopadle(const Prosta &p1, const Prosta &p2);
bool czy_proste_rownolegle(const Prosta &p1, const Prosta &p2);
Punkt punkt_przeciecia(const Prosta &p1, const Prosta &p2);

#endif //PROSTA_PROSTA_H
