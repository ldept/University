//
// Created by mlody on 31.05.2018.
//

#ifndef STRUMIENIE_STRUMIENIE_H
#define STRUMIENIE_STRUMIENIE_H

#include <istream>
#include <ostream>
#include <fstream>
#include <iostream>

namespace strumienie{
    //istream - zad1
    std::istream& clearline (std::istream& is);

    class ignore{
        int x;
        friend std::istream& operator >> (std::istream& is, const ignore &ig){
            int num = ig.x;
            while(num){
                num--;
                is.get();
            }
            return is;
        }

    public:
        ignore(int num) : x(num){}
    };


    //ostream - zad2
    std::ostream& comma (std::ostream &os);
    std::ostream& colon (std::ostream &os);

    class index{
        int x;
        int w;
        friend std::ostream& operator << (std::ostream& os, const index &i) {
            int digits = 0;
            int num = i.x;

            while(num){
                digits++;
                num /= 10;
            }
            int dist = i.w - digits;
            if(dist < 0){
                return os << "[" << i.x << "]";
            }else {
                os << "[";
                while(dist){
                    dist--;
                    os << " ";
                }
                os << i.x;
                os << "]";
                return os;
            }
        }
    public:
        index(int val, int space) : x(val), w(space){}
    };


    class wejscie{
    std::ifstream ifs;

    public:
        wejscie(const std::string &str);
        friend int operator >> (std::ifstream ifs){
            char *temp = nullptr;
            ifs.read(temp,1);
            return (int)temp;
        }
        ~wejscie(){
            ifs.close();
        }
    };

    class wyjscie{
    std::ofstream ofs;
    public:
        wyjscie(const std::string &str);
        friend std::ofstream operator<< (int a,std::ofstream ofs){
            ofs.write((char*)a,1);
            return ofs;
        }
        ~wyjscie(){
            ofs.close();
        }
    };

}

#endif //STRUMIENIE_STRUMIENIE_H
