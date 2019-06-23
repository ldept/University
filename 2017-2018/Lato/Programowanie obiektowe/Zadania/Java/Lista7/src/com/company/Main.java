package com.company;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Main {

    public static void main(String[] args) {
        
        Pojazd p = new Pojazd(500,50,true);
        Samochod s = new Samochod(500,50,true,"Opel","Insignia",40000);
        Tramwaj t = new Tramwaj(500,50,true,"Wrocław", "OL",356);
        //  PojazdSwing ps = new PojazdSwing(p);
        SamochodSwing ss = new SamochodSwing(s);
        TramwajSwing ts = new TramwajSwing(t);

    }
}
