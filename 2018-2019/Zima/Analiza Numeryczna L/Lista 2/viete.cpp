#include <iostream>
#include <cmath>
using namespace std;

int main(){

    double a,b,c;
    cin>>a>>b>>c;
    double x1 = (-b + sqrt(b*b - 4.0*a*c))/(2.0*a);
    double x2 = (-b - sqrt(b*b - 4.0*a*c))/(2.0*a);
    /*
    float x1,x2;
    if(c==0){
        x1 = 0;
        x2 = -b/a;
    }
    else if(b>0){
        x1 = (-b - sqrt(b*b - 4.0*a*c))/(2.0*a);
        x2 = c/(a*x1);
    }
    else {
        x1 = (-b + sqrt(b*b - 4.0*a*c))/(2.0*a);
        x2 = c/(a*x1);
    }
    */
    cout<<x1<<endl<<x2<<endl;

}
