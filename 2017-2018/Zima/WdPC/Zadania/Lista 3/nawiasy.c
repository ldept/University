#include <stdio.h>
int czyNawias(int z)
{
    if( z == '(' || z == ')' || z == '[' || z == ']' || z == '{' || z == '}' )
    return 1;
    else return 0;
}
int main()
{
    int z;                             // znak
    char n[5000];                        //nawiasy
    int i = 0;
    char typZamkniecia;



    while((z=getchar())!=EOF)
    {
        if(czyNawias(z) == 1)
        {
            if( z == '(' || z == '[' || z == '{'  )
            {
                n[i] = z;

                i++;
            }
            else
            {
                if( z == ')') typZamkniecia = '(';
                else if( z == ']') typZamkniecia = '[';
                else if( z == '}') typZamkniecia = '{';

                if ( n[i-1] == typZamkniecia )      //Czy nie ma konfliktu np. " [} "
                {
                    i--;
                }
                else                               //Jezeli jest konflikt zakoncz program
                {
                    printf("Zle zamknales nawias");
                    return 1;
                }

            }

        }


    }

    if( i != 0)
    {
        printf("Nie zamknales nawiasu");
    }
    else
    {
        printf("Wszystko OK");
        return 0;
    }
}
