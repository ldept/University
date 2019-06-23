//
// Created by lukasz on 25.04.18.
//

#ifndef WYMIERNA_WYMIERNA_H
#define WYMIERNA_WYMIERNA_H

#include "Wyjatek_wymierny.h"
#include <ostream>

namespace obliczenia{
    class Wymierna{
        int licz,mian;
        int gcd(int x, int y);
    public:
        Wymierna();
        Wymierna(int licz, int mian);
        explicit Wymierna(int licz);

        int get_licz() const ;
        int get_mian() const ;

        Wymierna operator+ (Wymierna const&);
        Wymierna operator- (Wymierna const&);
        Wymierna operator- ();
        Wymierna operator* (Wymierna const&);
        Wymierna operator/ (Wymierna const&);
        Wymierna operator! ();
        operator double () const;

        explicit operator int () const;

        friend std::ostream& operator<< (std::ostream &wyj, const Wymierna &w);
    };


}

#endif //WYMIERNA_WYMIERNA_H
