#include <iostream>
#include "punkt.h"
#include "prosta.h"
#include "wektor.h"

using namespace std;

int main() {

    Punkt domp = Punkt();
    Punkt doubp = Punkt(5.3,4.2);
    Wektor domw = Wektor();
    Punkt wektp = Punkt(doubp,domw);
    Punkt punktp = Punkt(doubp);
    Wektor wektdoub = Wektor(3.3,2.1);
    Wektor wektdom = Wektor();
    Wektor wektprzyp = Wektor(wektdoub);
    Wektor zlozony = zloz(wektdoub,wektprzyp);

    Prosta p1(3,1,0);
    Prosta p2(2,2,12);
    Prosta p3(2,2,4);

    Punkt p12 = punkt_przeciecia(p1,p2);
    Punkt p13 = punkt_przeciecia(p1,p3);

    cout<<"Punkty ==================="<<endl;
    cout<<"Konstruktor domyslny: " << domp.x << " , " << domp.y << endl;
    cout<<"Dwie liczby double: " << doubp.x << " , " << doubp.y << endl;
    cout<<"Punkt i wektor: " << wektp.x << " , " << wektp.y << endl ;
    cout<<"Punkt z punktu: " << punktp.x << " , " << punktp.y << endl;

    cout<<endl;

    cout<<"Wektory ================="<<endl;
    cout<<"Wekt. domyslny: " << wektdom.dx << " , " << wektdom.dy << endl;
    cout<<"Wekt. 2 double: " << wektdoub.dx << " , " << wektdoub.dy << endl;
    cout<<"Wekt. przypisany: " << wektprzyp.dx << " , " << wektprzyp.dy << endl;
    cout<<"Zlozenie wektorow z doubla i przypisania: " << zlozony.dx << " , " << zlozony.dy << endl;

    cout<<endl;

    Prosta prowekt(wektdoub);
    Punkt drugi(3.1,5.8);
    Prosta propunkt(doubp,drugi);
    Prosta prodom;
    Wektor w(3.0,1.0);
    Prosta prostopadla(w);
    Punkt p1p = Punkt (3,-9);
    cout<<"Proste ===================" << endl;
    cout<<"Prosta z trzech double'i: " << p2.get_a() << "*x +" << p2.get_b() << "*y +" << p2.get_c() << endl;
    cout<<"Prosta z wektora: " << prowekt.get_a() << "*x +" << prowekt.get_b() << "*y +" << p2.get_c() << endl;
    cout<<"Prosta z dwoch punktow: " << propunkt.get_a() << "*x +" << propunkt.get_b() << "*y +" << propunkt.get_c() << endl;
    cout<<"Prosta domyslna: " << prodom.get_a() << "*x +" << prodom.get_b() << "*y +" << prodom.get_c() << endl;

    cout<<"Czy prostopadle? : " << czy_proste_prostopadle(p1,p2) << " , " << czy_proste_prostopadle(p1, prostopadla) << endl;
    cout<<"Czy rownolegle? : " << czy_proste_rownolegle(p2, p3) << " , " << czy_proste_rownolegle(p1,prostopadla) << endl;
    cout<<"Punkt przeciecia p1 i p2: "<< p12.x << " , " << p12.y << endl;
    cout<<"Punkt przeciecia p1 i p3: "<< p13.x << " , " << p13.y << endl;
    cout<<"Czy na prostej: "<< p1.czy_na_prostej(p1p);
    return 0;
}