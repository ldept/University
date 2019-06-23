//
// Created by lukasz on 07.03.18.
//

#include <stdexcept>
#include "prosta.h"
#include <cmath>

Prosta::Prosta(const Punkt &punkt1,const Punkt &punkt2) {
    if(punkt1.x == punkt2.x && punkt1.y == punkt2.y){
        throw std::invalid_argument("Nie mozna utworzyc prostej z 2 takich samych punktow \n");
    }
    if(punkt1.x == punkt2.y){
        throw std::invalid_argument("Nie mozna utworzyc prostej przy takich samych parametrach x \n");
    }
    a = punkt2.y - punkt1.y;
    b = punkt1.x - punkt2.x;
    c = (punkt2.x * punkt1.y) - (punkt1.x * punkt2.y);
    postac_unormowana(a,b,c);
}
Prosta::Prosta(const Prosta &prosta,const Wektor &wektor) {
    a = prosta.get_a();
    b = prosta.get_b();
    c = prosta.get_c() - a * wektor.dx + wektor.dy;
    postac_unormowana(a,b,c);
}
Prosta::Prosta(const double ap,const double bp, const double cp) {
    if(ap == 0 && bp == 0){
        throw std::invalid_argument("Nie mozna utworzyc prostej, gdy a i b = 0 \n");
    }
    a = ap;
    b = bp;
    c = cp;
    postac_unormowana(a,b,c);
}
Prosta::Prosta(const Wektor &wektor) {
    if(wektor.dx == 0 && wektor.dy == 0){
        throw std::invalid_argument("Nie mozna utworzyc prostej z wektora zerowego \n");
    }
    a = wektor.dx;
    b = wektor.dy;
    c = - (a*a + b*b);
    postac_unormowana(a,b,c);
}

bool Prosta::czy_na_prostej(const Punkt &punkt) {


    return (abs(a*punkt.x + b*punkt.y + c) < 0.00000001);
}
bool Prosta::czy_prostopadly(const Wektor &wektor, const Prosta &prosta) {
    return (wektor.dx == prosta.get_c() && wektor.dy == prosta.get_b());
}
bool Prosta::czy_rownolegly(const Wektor &wektor, const Prosta &prosta) {
    return (wektor.dx == - prosta.get_b() && wektor.dy == prosta.get_a());
}

double Prosta::get_a()const { return a; }
double Prosta::get_b()const { return b; }
double Prosta::get_c()const { return c; }

void Prosta::postac_unormowana(double &a, double &b, double &c) {
    double czynnik = (1.0 / (sqrt(a * a + b * b)));
    if(c < 0) czynnik = -czynnik;
    a *= czynnik;
    b *= czynnik;
    c *= czynnik;
}

bool czy_proste_prostopadle(const Prosta &p1, const Prosta &p2){
    return ((p1.get_a()*p2.get_b()) - (p2.get_a() * p1.get_b()) == 0);
}
bool czy_proste_rownolegle(const Prosta &p1, const Prosta &p2){
    return (p1.get_a() * p2.get_b() - p2.get_a() * p1.get_b() == 0);
}
Punkt punkt_przeciecia(const Prosta &p1, const Prosta &p2){
    double mianownik = p1.get_a() * p2.get_b() - p2.get_a() * p1.get_b();
    if(mianownik == 0) throw std::invalid_argument("Dwie proste rownolegle nie maja punktu przeciecia \n");
    const double x = (p1.get_b() * p2.get_c() - p2.get_b() * p1.get_c()) / mianownik;
    const double y = -(p1.get_a() * p2.get_c() - p2.get_a() * p1.get_c()) / mianownik;
    Punkt p = Punkt(x, y);
    return p;
}