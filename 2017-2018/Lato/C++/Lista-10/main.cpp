#include <iostream>
#include <sstream>
#include <vector>
#include "strumienie.h"
using namespace strumienie;
int main() {
    std::cout << "Hello, World!" << std::endl;
    std::cout << comma;
    std::string str1;
    std::string str2;
    std::string str3;
    std::ostringstream os;
    os << "gora" << std::endl << "dol";
    str3 = os.str();


    std::cout << index(52,5) << std::endl;
   // std::vector<std::string> v;

    std::stringstream(str3) >> clearline >> str2;

    std::cin >> ignore(5) >> str1;
    std::cout << colon << str1 << std::endl;
    //std::cin >>  clearline >> str2 ;


    std::cout << colon << str2;
    return 0;
}