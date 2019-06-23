//
// Created by lukasz on 11.04.18.
//

#ifndef WYRAZENIA_OPERANDY_H
#define WYRAZENIA_OPERANDY_H


#include "wyrazenie.h"

class Liczba : public Wyrazenie{

    double x;

public:
    Liczba(double x);
    double oblicz() override;
    std::string opis() override;
};
class Stala : public Wyrazenie{
public:
    double x;
    double oblicz() override;
    std::string opis() override;
};

class Pi : public Stala{
public:
    Pi();
};
class E : public Stala{
public:
    E();
};

class Fi : public Stala{
public:
    Fi();
};

class Zmienna : public Wyrazenie{
private:
    static std::vector<std::pair<std::string,double>> zbior;
public:
    std::string zmienna;
    Zmienna(std::string zmienna);
    static void dodaj_do_zbioru(std::string str, double d);
    static void zmien_wartosc(std::string str,double d);
    static void usun_ze_zbioru(std::string str);
    static double znajdz_w_zbiorze(std::string str);
    static bool czy_jest(std::string str);
    double oblicz() override;
    std::string opis() override;

};
#endif //WYRAZENIA_OPERANDY_H
