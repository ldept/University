package com.company;

public class Sort extends Thread{
    private int[] tab;
    private int first;
    private int last;

     Sort(int[] tab, int first, int last){
        this.tab = tab;
        this.first = first;
        this.last = last;
    }

    @Override
    public void run() {
        Main.mergeSort(tab, first, last);
    }
}
