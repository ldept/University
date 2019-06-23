#include <stdio.h>

int main()
{
    float stala=0;
    int granica=1000;
    for (int n = 0; n < granica; n++)
    {

       int znak = -((n%2)*2-1);
       //if (n%2) znak = 1; else znak = -1;
       stala = stala + znak*(1.0f/((2.0f*n+1.0f)*(2.0f*n+1.0f)));
    }
    printf("%.9f", stala);


}
