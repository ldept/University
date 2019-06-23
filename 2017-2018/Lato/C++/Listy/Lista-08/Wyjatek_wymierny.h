//
// Created by lukasz on 25.04.18.
//

#ifndef WYMIERNA_WYJATEK_WYMIERNY_H
#define WYMIERNA_WYJATEK_WYMIERNY_H

#include <exception>

class Wyjatek_wymierny : public std::exception{

};

class dzielenie_przez_0 : public Wyjatek_wymierny {

public:
    const char * what () const throw (){
        return "Dzielenie przez zero!";
    }
};
class mianownik_0 : public Wyjatek_wymierny {
public:
    const char * what () const throw(){
        return "Mianownik nie może być zerem!";
    }
};
class przekroczenie_zakresu_int : public Wyjatek_wymierny{
public:
    const char * what() const throw(){
        return "Przekroczenie zakresu int";
    }
};

#endif //WYMIERNA_WYJATEK_WYMIERNY_H
