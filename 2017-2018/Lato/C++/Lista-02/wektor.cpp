//
// Created by lukasz on 07.03.18.
//

#include "wektor.h"

Wektor::Wektor(const Wektor &wektor) : dx(wektor.dx), dy(wektor.dy) {

}

Wektor::Wektor(const double create_dx, const double create_dy) : dx(create_dx), dy(create_dy) {

}

Wektor zloz(const Wektor &x,const Wektor &y){
    return Wektor(x.dx + y.dx, x.dy + y.dy);;
}