//
// Created by lukasz on 11.04.18.
//

#ifndef WYRAZENIA_OPERATORY_H
#define WYRAZENIA_OPERATORY_H

#include "wyrazenie.h"
#include "Operandy.h"

class Operator1Arg : public Wyrazenie{

public:
    Wyrazenie *a;
};
class Sin : public Operator1Arg{
public:
    Sin(Wyrazenie *a);
    double oblicz() override;
    std::string opis() override;

};
class Cos : public Operator1Arg{
public:
    Cos(Wyrazenie *a);
    double oblicz() override;
    std::string opis() override;
};
class Bezwzgl : public Operator1Arg {
public:
    Bezwzgl(Wyrazenie *a);
    double oblicz() override;
    std::string opis() override;
};
class Przeciw : public Operator1Arg {
public:
    Przeciw(Wyrazenie *a);
    double oblicz() override;
    std::string opis() override;

};
class Odwrot : public Operator1Arg {
public:
    Odwrot(Wyrazenie *a);
    double oblicz() override;
    std::string opis() override;
};
class Exp : public Operator1Arg{
public:
    Exp(Wyrazenie *a);
    double oblicz() override;
    std::string opis() override;
};
class Ln : public Operator1Arg{
public:
    Ln(Wyrazenie *a);
    double oblicz() override;
    std::string opis() override;
};
class Operator2Arg : public Operator1Arg{
public:
    Wyrazenie *b;
};

class Odejmij : public Operator2Arg {
public:
    int priorytet = 1;

    double oblicz() override;
    std::string opis() override;
    Odejmij(Wyrazenie *a, Wyrazenie *b);
};

class Dodaj : public Operator2Arg {
public:
    int priorytet = 1;

    double oblicz() override;
    std::string opis() override;
    Dodaj(Wyrazenie *a, Wyrazenie *b);
};

class Pomnoz : public Operator2Arg{
public:
    int priorytet = 2;
    Pomnoz(Wyrazenie *a,Wyrazenie *b);
    double oblicz() override;
    std::string opis() override;
};
class Podziel : public Operator2Arg{
public:
    int priorytet = 2;
    Podziel(Wyrazenie *a,Wyrazenie *b);
    double oblicz() override;
    std::string opis() override;
};
class Potega : public Operator2Arg{
public:

    Potega(Wyrazenie *a, Wyrazenie*b);
    double oblicz() override;
    std::string opis() override;
};
class Modulo : public Operator2Arg {
public:

    Modulo(Wyrazenie *a, Wyrazenie *b);
    double oblicz() override;
    std::string opis() override;
};
class Logarytm : public Operator2Arg{
public:
    Logarytm(Wyrazenie *a, Wyrazenie*b);
    double oblicz() override;
    std::string opis() override;};


#endif //WYRAZENIA_OPERATORY_H
