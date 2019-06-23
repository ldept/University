import java.util.Hashtable;

public class Main {
    public static void main(String[] args){

        Hashtable<String,Integer> tab = new Hashtable<String, Integer>();
        tab.put("x", 10);
        tab.put("y", 3);

        Wyrazenie wyrazenie = new Dodaj(new Stala(4), new Stala(2));
        Wyrazenie wyrazenie1 = new Pomnoz(new Stala(12), new Stala(4));
        Wyrazenie wyrazenie2 = new Podziel(new Stala (24), new Zmienna("y", tab));
        Wyrazenie wyrazenie3 = new Odejmij(new Stala(34), new Zmienna("x", tab));
        System.out.println(wyrazenie.toString() + ", " + wyrazenie1.toString() + ", " + wyrazenie2.toString() + ", " + wyrazenie3.toString());
        System.out.println(wyrazenie.oblicz() + ", " + wyrazenie1.oblicz() + ", " + wyrazenie2.oblicz() + ", " + wyrazenie3.oblicz());

    }

}
