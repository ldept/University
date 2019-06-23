//
// Created by lukasz on 11.04.18.
//

#include "Operatory.h"

Odejmij::Odejmij(Wyrazenie *a, Wyrazenie *b) {
    this->a = a;
    this->b = b;
}

double Odejmij::oblicz() {
    return this->a->oblicz() - this->b->oblicz();
}

std::string Odejmij::opis() {
    std::ostringstream os;
    os << "(" << this->a->opis() << ")" << " - " << "( " << this->b->opis() << " )";
    return os.str();
}

Sin::Sin(Wyrazenie *a) {
    this->a = a;
}

double Sin::oblicz() {
    return sin(a->oblicz());
}

std::string Sin::opis() {
    std::ostringstream os;
    os << "sin(" << this->a->opis() << ")";
    return os.str();
}

Cos::Cos(Wyrazenie *a) {
    this->a = a;
}

double Cos::oblicz() {
    return cos(this->a->oblicz());
}

std::string Cos::opis() {
    std::ostringstream os;
    os << "cos(" << this->a->opis() << ")";
    return os.str();
}

Bezwzgl::Bezwzgl(Wyrazenie *a) {
    this->a = a;
}

double Bezwzgl::oblicz() {
    if(this->a->oblicz() < 0){
        return - this->a->oblicz();
    }
    else return this->a->oblicz();
}

std::string Bezwzgl::opis() {
    std::ostringstream os;
    if(this->a->oblicz() < 0){
        os << this->a->opis();
    }
    else os << "|" << this->a->opis() << "|";

    return os.str();
}

Przeciw::Przeciw(Wyrazenie *a) {
    this->a = a;
}

double Przeciw::oblicz() {
    return - this->a->oblicz();
}

std::string Przeciw::opis() {
    std::ostringstream os;
    os << "-(" << this->a->opis() << ")";
    return os.str();
}

Odwrot::Odwrot(Wyrazenie *a) {
    this->a = a;
}

double Odwrot::oblicz() {
    return 1 / this->a->oblicz();
}

std::string Odwrot::opis() {
    std::ostringstream os;
    os <<"( " << 1 << " / " << this->a->opis() << " )";
    return os.str();
}

Exp::Exp(Wyrazenie *a) {
    this->a = a;
}

double Exp::oblicz() {
    E *e = new E();
    return pow(e->oblicz(),this->a->oblicz());
}

std::string Exp::opis() {
    std::ostringstream os;
    os << "exp(" << this->a->opis() << ")";
    return os.str();
}

Ln::Ln(Wyrazenie *a) {
    this->a = a;
}

double Ln::oblicz() {
    return log(this->a->oblicz());
}

std::string Ln::opis() {
    std::ostringstream os;
    os << "ln(" << this->a->opis() << ")";
    return os.str();
}

double Dodaj::oblicz() {
    return this->a->oblicz() + this->b->oblicz();
}

std::string Dodaj::opis() {
    std::ostringstream os;
    os<< this->a->opis() <<" + "<< this->b->opis();
    return os.str();
}

Dodaj::Dodaj(Wyrazenie *a, Wyrazenie *b) {
    this->a = a;
    this->b = b;
}

Pomnoz::Pomnoz(Wyrazenie *a, Wyrazenie *b) {
    this->a = a;
    this->b = b;
}

double Pomnoz::oblicz() {
    return this->a->oblicz() * this->b->oblicz();
}

std::string Pomnoz::opis() {
    std::ostringstream os;
    os<< "(" <<  this->a->opis() << ") * (" << this->b->opis() << ")";
    return os.str();
}

Podziel::Podziel(Wyrazenie *a, Wyrazenie *b) {
    this->a = a;
    this->b = b;
}

double Podziel::oblicz() {
    return this->a->oblicz() / this->b->oblicz();
}

std::string Podziel::opis() {
    std::ostringstream os;
    os << "(" << this->a->opis() << ") / ("<< this->b->opis() << ")";
    return os.str();
}

Potega::Potega(Wyrazenie *a, Wyrazenie *b) {
    this->a = a;
    this->b = b;
}

double Potega::oblicz() {
    return pow(this->a->oblicz(),this->b->oblicz());
}

std::string Potega::opis() {
    std::ostringstream os;
    os<< "pow(" << this->a->opis() << ", " << this->b->opis() << ")";
    return os.str();
}

Modulo::Modulo(Wyrazenie *a, Wyrazenie *b) {
    this->a = a;
    this->b = b;
}

double Modulo::oblicz() {
    return fmod(this->a->oblicz(), this->b->oblicz());
}

std::string Modulo::opis() {
    std::ostringstream os;
    os << "(" << this->a->opis() << " % " << this->b->opis() << ")";
    this->b->oblicz();
    return os.str();
}

Logarytm::Logarytm(Wyrazenie *a, Wyrazenie *b) {
    this->a = a;
    this->b = b;
}

double Logarytm::oblicz() {
    return log(this->b->oblicz()) / log(this->a->oblicz());

}

std::string Logarytm::opis() {
    std::ostringstream os;
    os<< "log" << this->a->opis() << "(" << this->b->opis() << ")";
    return os.str();
}
