//
// Created by lukasz on 07.03.18.
//

#include "punkt.h"

Punkt::Punkt(const double create_x, const double create_y) : x(create_x), y(create_y){

}
Punkt::Punkt(const Punkt &punkt, const Wektor &wektor) : x(punkt.x + wektor.dx), y(punkt.y + wektor.dy) {

}
Punkt::Punkt(const Punkt &punkt) : x(punkt.x), y(punkt.y) {

}
