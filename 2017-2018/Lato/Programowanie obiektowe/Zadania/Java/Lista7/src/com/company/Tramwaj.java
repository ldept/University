package com.company;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Tramwaj extends Pojazd {
    String miasto;
    String trasa;
    int numer;

    Tramwaj(int waga, int maks_predkosc, boolean benzyna, String miasto, String  trasa, int numer) {
        super(waga, maks_predkosc, benzyna);
        this.miasto = miasto;
        this.trasa = trasa;
        this.numer = numer;
    }

    @Override
    public String toString() {
        return "" + miasto + ", " + trasa + ", " + numer;
    }
}
