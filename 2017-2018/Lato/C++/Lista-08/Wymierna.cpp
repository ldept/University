//
// Created by lukasz on 25.04.18.
//

#include "Wymierna.h"
using namespace obliczenia;

Wymierna::Wymierna(){
    licz = 1;
    mian = 1;
}
Wymierna::Wymierna(int licz, int mian) {
    if (mian < 0){
        mian = - mian;
        licz = - licz;
    }
    if(mian == 0) throw mianownik_0();
    this->licz = licz / gcd(licz,mian);
    this->mian = mian / gcd(licz,mian);
}
//Wymierna::Wymierna(int licz) : Wymierna(licz,1) {
//}

int Wymierna::gcd(int x, int y) {
    while(y != 0){
        int temp = x % y;
        x = y;
        y = temp;
    }
    return x;
}

Wymierna::Wymierna(int licz) : Wymierna(licz,1){}

int Wymierna::get_mian() const{
    return mian;
}

int Wymierna::get_licz() const {
    return licz;
}

Wymierna Wymierna::operator+(Wymierna const &wymierna) {
    int nww = ( get_mian() * wymierna.get_mian() ) / gcd(get_mian(),wymierna.get_mian()); //nww mianownikow
    int normx = nww / get_mian();
    int normy = nww / wymierna.get_mian();
    if((INTMAX_MAX - normx * get_licz()) < (normy * wymierna.get_licz())) throw przekroczenie_zakresu_int();
    Wymierna tmp((normx * get_licz()) + (normy * wymierna.get_licz()),
                 normy * wymierna.get_mian());
    return tmp;
}
Wymierna Wymierna::operator-(Wymierna const &wymierna) {
    int nww = ( get_mian() * wymierna.get_mian() ) / gcd(get_mian(),wymierna.get_mian()); //nww mianownikow
    int normx = nww / get_mian();
    int normy = nww / wymierna.get_mian();
    Wymierna tmp((normx * get_licz()) - (normy * wymierna.get_licz()),
                 normy * wymierna.get_mian());
    return tmp;
}
Wymierna Wymierna::operator-() {
    return {-get_licz(),get_mian()};
}
Wymierna Wymierna::operator*(Wymierna const &wymierna) {
    if((INTMAX_MAX / get_licz()) < wymierna.get_licz()) throw przekroczenie_zakresu_int();
    Wymierna tmp(get_licz() * wymierna.get_licz(), get_mian() * wymierna.get_mian());
    return tmp;
}

Wymierna Wymierna::operator/(Wymierna const &wymierna) {
    if(wymierna.get_licz() == 0) throw dzielenie_przez_0();
    if(((INTMAX_MAX / get_licz()) < wymierna.get_mian()) ||
       ((INTMAX_MAX / wymierna.get_licz()) < get_mian())) throw przekroczenie_zakresu_int();
    Wymierna tmp(get_licz()*wymierna.get_mian(),get_mian()*wymierna.get_licz());
    return tmp;
}
Wymierna::operator double() const{
    return (double) get_licz() / get_mian();;
}

Wymierna::operator int() const {
    return get_licz() / get_mian();
}

Wymierna Wymierna::operator!() {
    Wymierna tmp(get_mian(),get_licz());
    return tmp;
}
namespace obliczenia{
    std::ostream &operator<<(std::ostream &wyj, const Wymierna &w) {
        double wynik;
        wynik = (double) w.get_licz() / w.get_mian();
        wyj << wynik;
        return wyj;
    }

}


