#ifndef STOS_HPP
#define STOS_HPP

#include <string>

class Stos{
    private:
        int pojemnosc;
        int rozmiar;
        std::string* stos=nullptr;
    public:
        Stos();
        Stos(int);
        Stos(std::initializer_list<std::string>);
        Stos(Stos&&);
        Stos(const Stos&);

        Stos & operator=(const Stos&);
        Stos & operator=(Stos&&);

        void wloz(const std::string&);
        std::string sciagnij();
        void wyswietl()const;

        ~Stos(){delete [] stos;}
    protected:  




};




#endif