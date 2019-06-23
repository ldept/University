class Stala extends Wyrazenie{

    int x;
    public Stala (int x){
        this.x = x;
    }
    @Override
    int oblicz(){
        return this.x;
    }

    @Override
    public String toString() {
        return "" + this.x;
    }
}

