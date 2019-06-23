package com.company;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;


public class Samochod extends Pojazd {
    String marka;
    String model;
    int cena;

    Samochod(int waga, int maks_predkosc, boolean benzyna,String marka,String model, int cena) {
        super(waga, maks_predkosc, benzyna);
        this.marka = marka;
        this.model = model;
        this.cena = cena;
    }

    @Override
    public String toString() {
        return "" + marka + ", " + model + ", " + cena + "PLN";
    }
}
