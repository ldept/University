#include "stos.hpp"
#include <stdexcept>
#include <iostream>
#include <utility>
Stos::Stos() : pojemnosc(1), rozmiar(0)
{
    stos = new std::string[1];
}

Stos::Stos(const int k) : pojemnosc(k), rozmiar(0){
    stos = new std::string[k];
}

Stos::Stos(std::initializer_list<std::string> l) :  pojemnosc(l.size()), rozmiar(0){
    stos = new std::string[l.size()];
    for(auto x : l)
    {
        wloz(x);
    }

}

Stos::Stos(Stos&& x) : pojemnosc(x.pojemnosc), rozmiar(x.rozmiar), stos(x.stos) {
    x.stos = nullptr;
}

Stos::Stos(const Stos& x) :
   pojemnosc(x.pojemnosc),
   rozmiar(0),
   stos(new std::string[pojemnosc]) {
     for(int i=0 ;i<x.rozmiar;i++)
    {  
        stos[i]=*(x.stos+i);
        rozmiar++;
    }
}

Stos & Stos::operator=(const Stos& x){
    return *this = Stos(x);
}

Stos & Stos::operator=(Stos&& x){


    if(pojemnosc < x.rozmiar) throw std::range_error("ZA MAŁA POJEMNOŚĆ STOSU!"); 
    rozmiar = x.rozmiar;
    pojemnosc = x.pojemnosc;
    for(int i=0 ;i<rozmiar;i++)
    {  
        *(stos+i) = *(x.stos+i);
    }
    //x.stos=nullptr;
    return *this;
}


void Stos::wloz(const std::string &x){
    rozmiar++;
    if(rozmiar-1 == pojemnosc) throw std::range_error("STOS PEŁNY!");
    stos[rozmiar-1] = x;
    

}

std::string Stos::sciagnij(){
    if(rozmiar == 0) throw std::range_error("STOS PUSTY!");
    rozmiar--;
    return stos[rozmiar];
}

void Stos::wyswietl() const
{
    if(rozmiar ==0) 
    {
        std::cout << "STOS JEST PUSTY!" << std::endl << std::endl;
        return;
    }
    std::cout << "Stos:" << std::endl;
    for(int i=0 ;i<rozmiar;i++)
    {
        std::cout << *(stos + i) << std::endl;
    }
}