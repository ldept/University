#include <iostream>
#include "Wymierna.h"
int main() {
    std::cout << "Hello, World!" << std::endl;
    obliczenia::Wymierna p(12,4);
    std::cout << p.get_licz() << " " << p.get_mian()<<std::endl;
    obliczenia::Wymierna q(3,5);
    obliczenia::Wymierna pq;
    try{
        pq = p / q;
    }
    catch(Wyjatek_wymierny &e){
        std::cerr<<e.what()<<"\n";
    }
    catch (...){
        std::cerr<<"Unknown error" << "\n";
    }
    double x = pq;

    obliczenia::Wymierna qcopy = q;

    auto y = (int)qcopy;

    obliczenia::Wymierna intw(5);

    std::cout << pq.get_licz() << "/" << pq.get_mian()<< ", pq jako double: " << x << ", qcopy jako int: " << y <<std::endl;
    std::cout << "Ujemne pq jako double: " << -pq <<std::endl;
    std::cout << "Odwrotna do pq (jako double): " << !pq;

}