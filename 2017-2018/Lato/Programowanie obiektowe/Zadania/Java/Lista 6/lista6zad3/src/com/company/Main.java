package com.company;

import java.util.ArrayList;

public class Main {

    public static void main(String[] args) {
        Buffer <String> buffer = new Buffer<String>(10);
        Producent producent = new Producent(buffer);
        Konsument konsument = new Konsument(buffer);
        Thread t1 = new Thread(producent,"producent");
        Thread t2 = new Thread(konsument,"konsument");
        t1.start();
        t2.start();
        System.out.println(buffer.tab.get(0));

    }
}
