#include <iostream>
#include <cmath>

int main(){

  double suma = 0.0;

  for(int k = 0; k < 100000; k++){
      suma += pow(-1.0,k) / (2.0 * k + 1.0);
  }
  double moje_pi = 4.0 * suma;
  double roznica = moje_pi - M_PI;
  std::cout<< "Roznica: " << roznica << ", moje pi: " << moje_pi << std::endl;

}
