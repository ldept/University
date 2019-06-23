#include "stos.hpp"
#include <iostream>



int main()
{
    int flag = 0;
    Stos moj_stos(5);
    std::string temp;
    system("clear");
    while(flag!=4)
    {
        std::cout << "Wybierz odpowiednia opcje!"<< std::endl;
        std::cout << "1. Wyswietl stos!"<< std::endl;
        std::cout << "2. Zdejmij element ze stosu!"<< std::endl;
        std::cout << "3. Dodaj element na stos!"<< std::endl;
        std::cout << "4. Zakoncz program!"<< std::endl;
        std::cin >> flag;
        std::getchar();
        switch(flag)
        {
            case 1:
                system("clear");
                moj_stos.wyswietl();
                std::cout << std::endl;
                break;
            case 2:
                system("clear");
                std::cout << "Sciagnieto element: " << moj_stos.sciagnij() << " ze stosu!" << std::endl << std::endl;
                break;
            case 3:
                system("clear");
                std::cout << "Podaj nowy element stosu: ";
                std::getline(std::cin, temp);
                std::cout<<std::endl;
                moj_stos.wloz(temp);
                std::cout << "Dodano element " << temp << " do stosu!" << std::endl << std::endl;
                break;
            case 4:
                system("clear");
                std::cout << "Do zobaczenia!"<< std::endl;
                break;
            default:
                std::cout << "BLEDNE POLECENIE!"<< std::endl << std::endl;

                break;
        }

    }

    //testy konstruktorow

    Stos a{"a","b","c"};
    Stos b{"b","b","b"};
    b.wyswietl();
    Stos c{"c","c","c"};
    Stos d(Stos{"D"});
    d.wyswietl();
    c=b;
    c.wyswietl();

}