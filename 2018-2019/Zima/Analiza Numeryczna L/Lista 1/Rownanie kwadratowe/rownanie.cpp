#include "iostream"
#include "cmath"

int main(){
  float a,b,c;
  a = pow(10,7);
  b = pow(10,7);
  c = 1.0;
  float w1 = (-b + sqrt(pow(b,2) - 4 * a * c)) / (2 *a );
  float w2 = (-b - sqrt(pow(b,2) - 4 * a * c)) / (2 *a );
  //cin>>a>>b>>c;
  std::cout << "w1: " << w1 << ", w2: " << w2 << ", pow: " << pow(10,-9) << std::endl;
}
