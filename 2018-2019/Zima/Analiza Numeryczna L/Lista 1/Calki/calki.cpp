#include <iostream>
#include <cmath>
int main(){
  float i[21];
  i[0] = log(1.2);

  for(int n = 1; n < 21; n++){
    //double tmp = n;
    i[n] = (1.0 / n) - (5.0 * i[n - 1]);
  }

  for(int n = 0; n < 21; n++){
    std::cout << n << ": " << i[n] << std::endl;
  }

}
