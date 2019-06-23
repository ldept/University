//Łukasz Deptuch
//300771
//KPI
#include <stdio.h>

int main(){
    int a,b;
    scanf("%i %i", &a, &b);
    int l = a / 2018;
    if(l*2018 < a){
        l += 1;
    }
    for(int i = l; i<= b/2018; i++){
        if(i == b/2018){
            printf("%i",i*2018);
        }
        else {
            printf("%i ",i*2018);
        }
    }

}