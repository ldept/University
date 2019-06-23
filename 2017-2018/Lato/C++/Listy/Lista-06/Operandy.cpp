//
// Created by lukasz on 11.04.18.
//

#include "Operandy.h"

Liczba::Liczba(double x) {
    this->x = x;
}

double Liczba::oblicz() {
    return this->x;
}

std::string Liczba::opis() {

    std::stringstream ss;
    ss << std::setprecision(3) << this->x;
    return ss.str();
}

double Stala::oblicz() {
    return this->x;
}

std::string Stala::opis() {
    std::stringstream ss;
    ss << std::setprecision(3) << this->x;
    return ss.str();}

Pi::Pi() {
    this->x = 3.14;
}

E::E() {
    this->x = 2.71;
}

Fi::Fi() {
    this->x = 1.61;
}

std::vector <std::pair <std::string, double>> Zmienna::zbior;

Zmienna::Zmienna(std::string zmienna) {
    this->zmienna = zmienna;
}

void Zmienna::dodaj_do_zbioru(std::string str, double d) {
    zbior.push_back(std::make_pair(str,d));
}

void Zmienna::usun_ze_zbioru(std::string str) {
    for(int i = 0; i < zbior.size();i++){
        if(str == zbior[i].first){
            zbior.erase(zbior.begin() + i);
        }
    }
}
bool Zmienna::czy_jest(std::string str){
    for(int i = 0; i<zbior.size(); i++){
        if(str == zbior[i].first){
            return true;
        }
    }
    return false;
}

double Zmienna::znajdz_w_zbiorze(std::string str) {
    for(int i = 0; i<zbior.size(); i++){
        if(str == zbior[i].first){
            return zbior[i].second;
        }
    }
    return 0;
}
void Zmienna::zmien_wartosc(std::string str, double d) {
    for(int i = 0; i<zbior.size(); i++){
        if(str == zbior[i].first){
            zbior[i].second = d;
        }
    }
}
double Zmienna::oblicz() {
    if(czy_jest(this->zmienna)){
        return znajdz_w_zbiorze(this->zmienna);
    }

}

std::string Zmienna::opis() {
    return this->zmienna;
}