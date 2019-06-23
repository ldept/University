#include <stdio.h>
int main()
{
    float a,b;

    scanf("%f %f", &a, &b);
    for( float y = b; y>=-b;y--)
    {
        if(y==0) y--;
        for(float x = -a; x <= a; x++)
        {

            if(x==0) x++;

            float t = ((x*x)/(a*a))+((y*y)/(b*b));              //punkt w srodku (teraz)
            float p = ((x*x)/(a*a))+(((y-1)*(y-1))/(b*b));      //punkt wyżej (poprzedni)
            float n = ((x*x)/(a*a))+(((y+1)*(y+1))/(b*b));      //punkt niżej (następny)

            if (y<0)                                            //warunek pomocniczy do następnego punktu opisanego w komentarzu
            {

                if( (1 <= p && 1 >= n) || t < 1 )               //jeżeli elipsa jest zarysowana pomiędzy dwoma sprawdzanymi punktami, to wypisuje #
                {
                    printf("#");

                }
                else printf(" ");

            }else if( (1 >= p && 1 <= n) || t < 1 )
                {
                    printf("#");
                }
                else printf(" ");


        }

        printf("\n");                                            //po zapisaniu wiersza przejdź do kolejnej linijki

    }
    return 0;
}
