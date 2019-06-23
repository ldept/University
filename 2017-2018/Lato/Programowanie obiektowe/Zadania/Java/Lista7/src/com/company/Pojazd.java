package com.company;


public class Pojazd implements java.io.Serializable{
    int waga;
    int maks_predkosc;
    boolean benzyna;
    Pojazd(int waga, int maks_predkosc, boolean benzyna){
        this.waga = waga;
        this.maks_predkosc = maks_predkosc;
        this.benzyna = benzyna;
    }
    @Override
    public String toString() {
        return "" + waga + ", " + maks_predkosc + ", " + benzyna;
    }
}
