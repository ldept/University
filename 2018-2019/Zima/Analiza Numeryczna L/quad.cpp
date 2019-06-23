#include <iostream>
#include <math.h>
using namespace std;
double sum(int n, double w[], double fi[]){
  double wynik = 0.;
  for(int i = 0; i < n; i++){
    wynik += w[i] * fi[i];
  }
  return wynik;
}
double f(double x){
  return (1. / (1. + pow(x,2.)));
}

int main() {

  int n = 4;
  int a = -4, b=4;
  double h = double (b-a) / n;
  double w[n+1] = {7.,32.,12.,32.,7.};
  double fi[n+1] = {f(4.),f(2.),1,f(2.),f(4.)};
  double alfa = 2./45.;

  /*
  double w[n+1] = {41.,216.,27.,272.,27.,216.,41.};
  double fi[n+1] = {1./17.,9./73.,9./25.,1,9./25.,9./73.,1./17.};
  double alfa = 1./140.;

  double w[n+1] = {989.,5888.,-928.,10496.,-4540.,10496.,-928.,5888.,989.};
  double fi[n+1] = {1./17., 1./10., 1./5., 1./2., 1, 1./2., 1./5., 1./10., 1./17.};
  double alfa = 4./14175.;

  /*

  double w[n+1] = {16067.,106300.,-48525.,272400.,-260550.,427368.,-260550.,272400.,-48525.,106300.,16067.};
  double fi[n+1] = {f(4.),f(16./5.),f(12./5.),f(8./5.),f(4./5.),1.,f(4./5.),f(8./5.),f(12./5.),f(16./5.),f(4)};
  double alfa = 5./299376.;
*/

  double wynik = alfa * h * sum(n,w,fi);
  cout<<"wynik: "<<wynik<<endl;
  return 0;
}
