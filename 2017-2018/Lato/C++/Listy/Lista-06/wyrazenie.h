//
// Created by lukasz on 11.04.18.
//

#ifndef WYRAZENIA_WYRAZENIE_H
#define WYRAZENIA_WYRAZENIE_H

#include <string>
#include <vector>
#include <sstream>
#include <cmath>
#include <iomanip>

class Wyrazenie {

public:
    Wyrazenie(Wyrazenie &a) = default;
    Wyrazenie() = default;
    virtual double oblicz()= 0;
    virtual std::string opis()= 0;
};


#endif //WYRAZENIA_WYRAZENIE_H
