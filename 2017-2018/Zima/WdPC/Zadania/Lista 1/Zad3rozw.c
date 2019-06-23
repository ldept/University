#include <stdio.h>
int main()
{
    int n;
    scanf("%d", &n);
    if(n <= 2 || n % 2 == 1)
    {
        printf("NIEPOPRAWNA LICZBA");
        return 1;
    }
    int licznik = 0;
    int p,q = 2;
    for(q = 2 ; q <= n ; q++)
    {

        int j = 2;
        for(j = 2; j * j <= q; j++) //czy q nie pierwsza
        {
            if(q%j == 0)
            {
                j = 2;
                break;
            }

        }

        if(j != 2 || q == 2 || q == 3)  //czy q jest pierwsza
        {
            p = n - q;
            if(p <= q)
                {
                    int i = 2;
                    for( i = 2; i * i <= p; i++)
                    {
                        if(p%i == 0)
                        {
                            i = 2;
                            break;
                        }
                    }
                    if(i != 2 || p == 2 || p == 3)
                    {
                        licznik = licznik + 1;
                    }
                }
        }
    }

    printf("%d", licznik);
    return 0;
}
