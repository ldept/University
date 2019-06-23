#include <iostream>
#include <cmath>
int main(){
  float x0 = 1, x1 = - 1.0/7.0;

  std::cout << x0 << std::endl << x1 <<std::endl;
  for(int j = 1; j < 200; j++){
    float tmp = (13 * x1 + 2 * x0) / 7;
    std::cout << tmp << std::endl;
    x0 = x1;
    x1 = tmp;
  }

}
