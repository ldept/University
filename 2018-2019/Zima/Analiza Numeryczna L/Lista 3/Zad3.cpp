#include <iostream>
#include <cmath>
using namespace std;
double fun(double x){
    return x*exp(-x) - 0.06064;
}
void bisect(double a, double b, double alfa, double n){
    double mn = (a + b)/2;
    double en = alfa - mn;
    bool isEstimated = abs(en) <= pow(2.0,-n-1.0) * (1.0 - 0.0);
    cout << "e" << n << ": " << en << "    m" << n << ": " << mn << "   isEstimated: " << isEstimated << endl;
    if (n == 15){
        cout<<endl;
    }
    else if(fun(mn) * fun(a) < 0){
        return bisect(a,mn,alfa,n+1);
    }
    else return bisect(mn,b,alfa,n+1);
}
int main(){

    double alfa = 0.0646926359947960;
    double a = 0.0,b = 1.0;
    bisect(a,b,alfa,0);
}

