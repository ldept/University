//
// Created by lukasz on 07.03.18.
//

#ifndef PROSTA_PUNKT_H
#define PROSTA_PUNKT_H

#include "wektor.h"
#include <iostream>

class Punkt{

public:
    const double x=0.0;
    const double y=0.0;
    Punkt() = default;
    Punkt( double create_x,  double create_y);
    Punkt(const Punkt &punkt, const Wektor &wektor);
    Punkt(const Punkt &a);

    Punkt &operator = (const Punkt&a) = delete;
};

#endif //PROSTA_PUNKT_H
