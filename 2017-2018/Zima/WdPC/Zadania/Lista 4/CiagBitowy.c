#include <stdio.h>

int main()
{
    int c; //znak
    int maxJedynki = 0;
    int maxZera = 0;
    int jedynki = 0;
    int zera = 0;
    int sumaZer = 0;
    int sumaJedynek = 0;
    while((c=getchar())!=EOF)
    {
        /*int reszta [8];

        for(int i=7;i>=0;i--)
        {
            reszta[i] = c % 2;
            c /= 2;



        }*/

      for(int i=0;i<8;i++)
        {
            if((c >> (7-i)) % 2)
            {
                if(zera>maxZera)
                {
                    maxZera = zera;
                }
                sumaJedynek++;
                zera = 0;
                jedynki++;
            }
            else
            {
                if(jedynki>maxJedynki)
                {
                    maxJedynki=jedynki;
                }
                sumaZer++;
                jedynki = 0;
                zera++;
            }

          //  printf("%d",reszta[i]);


        }

    }
    printf("\n");
    printf("najdluzsze jedynki: %d najdluzsze zera: %d Suma jedynek: %d Suma zer: %d",maxJedynki,maxZera,sumaJedynek,sumaZer);

    return 0;
}
