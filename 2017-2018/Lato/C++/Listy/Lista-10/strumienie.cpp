//
// Created by mlody on 31.05.2018.
//

#include "strumienie.h"


std::istream &strumienie::clearline(std::istream &is) {
    int x = is.get();
    while(x != '\n' && x != EOF){
        x = is.get();
    }
    return is;
}

std::ostream &strumienie::colon(std::ostream &os) {
    return os << ": ";
}

std::ostream &strumienie::comma(std::ostream &os) {
    return os << ", ";
}

strumienie::wyjscie::wyjscie(const std::string &str) {
    try {
        ofs.exceptions( std::ofstream::badbit | std::ofstream::failbit);
        ofs = std::ofstream(str.c_str(),std::ios::binary);
    }
    catch (const std::ios_base::failure &e){
        std::cerr << e.what();
    }

}

strumienie::wejscie::wejscie(const std::string &str) {

    try {
        ifs.exceptions( std::ifstream::badbit | std::ifstream::failbit);
        ifs = std::ifstream(str.c_str(),std::ios::binary);


    }
    catch(const std::ios_base::failure &e) {
        std::cerr << e.what();
    }
}
