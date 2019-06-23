//
// Created by lukasz on 07.03.18.
//

#ifndef PROSTA_WEKTOR_H
#define PROSTA_WEKTOR_H

class Wektor{
public:
    const double dx=0.0;
    const double dy=0.0;
    Wektor() = default;
    Wektor(const Wektor &wektor);
    Wektor(double create_dx, double create_dy);
    Wektor operator = (const Wektor &wektor) = delete;

};

Wektor zloz(const Wektor &x,const Wektor &y);
#endif //PROSTA_WEKTOR_H
