class Dodaj extends Wyrazenie{

    Wyrazenie x;
    Wyrazenie y;
    public Dodaj (Wyrazenie x, Wyrazenie y){
        this.x = x;
        this.y = y;
    }

    @Override
    int oblicz() {
        return this.x.oblicz() + this.y.oblicz();
    }

    @Override
    public String toString() {

        return this.x + "+" + this.y;
    }
}
class Odejmij extends Wyrazenie{
    Wyrazenie x;
    Wyrazenie y;

    public Odejmij(Wyrazenie x, Wyrazenie y){
        this.x = x;
        this.y = y;
    }
    @Override
    int oblicz() {
        return this.x.oblicz() - this.y.oblicz();
    }

    @Override
    public String toString() {
        return this.x + "-" + this.y;
    }
}
class Pomnoz extends Wyrazenie{
    Wyrazenie x;
    Wyrazenie y;

    public Pomnoz(Wyrazenie x, Wyrazenie y){
        this.x = x;
        this.y = y;
    }

    @Override
    int oblicz() {
        return this.x.oblicz() * this.y.oblicz();
    }

    @Override
    public String toString() {
        return x + "*" + y;
    }
}
class Podziel extends Wyrazenie{

    Wyrazenie x;
    Wyrazenie y;

    public Podziel(Wyrazenie x, Wyrazenie y){
        this.x = x;
        this.y = y;
    }

    @Override
    int oblicz() {
        return this.x.oblicz() / this.y.oblicz();
    }

    @Override
    public String toString() {
        return this.x + "/" + this.y;
    }
}
