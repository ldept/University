#include <stdio.h>
#include <math.h>
int reszta(int m, int n)
{
    int p=2;
    for(p ; p <= n ; p++)
    {
        int j = 2;
        for(j ; j <= p; j++) //czy p nie pierwsza
        {
            if(p%j == 0)
            {
                break;
            }

        }

        if(p == j)  //czy p jest pierwsza
        {
            if(m%p != n%p) //czy p spelnia warunek
            {
                break;
            }
        }
    }
    return p;
}
int main()
{
    float maks=0;
    int maksm=3, maksn=4;

    for(int n=4; n <= 1000; n++)
    {
        for(int m=3; m < n; m++)
        {
          // 3 5 ~3.10
                if(maks < (reszta(m,n) / log(n)))
                {
                    maks = reszta(m,n) / log(n);
                    maksn= n;
                    maksm= m;
                }

        }
    }


    printf("m: %i n: %i\n", maksm,maksn);

}
