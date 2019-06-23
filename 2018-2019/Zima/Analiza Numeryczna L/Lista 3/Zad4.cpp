#include <iostream>
#include <iomanip>
#include <cmath>
using namespace std;
double fun(double x){
    return x*x - log(x+2);
}
double bisect(double a, double b, double alfa){
    double mn = (a + b)/2;
    double en = alfa - mn;
    bool isGood = abs(en) <= pow(10.0,-10.0);
    if(isGood){
        return mn;
    }
    if(fun(mn) * fun(a) < 0){
        return bisect(a,mn,mn);
    }
    else return bisect(mn,b,mn);
}
int main(){

    double a = -2.0,b = 0.0;
    double w1 = bisect(a,b,0);
    a = 0.0; b = 2.0;
    double w2 = bisect(a,b,0);
    cout << setprecision(10) << fixed << w1 << endl << w2 << endl << fun(w1) << endl << fun(w2) << endl;
}

