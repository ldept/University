import java.util.Hashtable;

public class Zmienna extends Wyrazenie{

    String str;
    Hashtable<String,Integer> tab;
    // nie wiem jak zrobic zeby konstruktor przyjmowa; tylko stringa
    public Zmienna(String str, Hashtable<String,Integer> tab){
        this.str = str;
        this.tab = tab;
    }

    @Override
    int oblicz() {
        return this.tab.get(str);
    }

    @Override
    public String toString() {
        return this.str;
    }
}
