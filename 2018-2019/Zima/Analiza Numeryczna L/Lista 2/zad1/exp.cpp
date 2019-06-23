#include <iostream>
#include <cmath>
using namespace std;

int main(){

    float x = 1/pow(3,1.0/3.0)+0.00000000001;
    float wynik = exp(pow(x,2.0)) - exp(3.0 * pow(x,5));
    cout<< wynik <<endl;
}
