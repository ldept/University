package com.company;

import java.util.ArrayList;
import java.util.List;

public class Buffer <T> {
    private int size;
    private int elem;
    public ArrayList tab;

    Buffer(int size){
        this.size = size;
        this.elem = 0;
        this.tab = new ArrayList(size);
    }
    public void pop(){

        if(elem > 0){
            T temp = (T) tab.get(0);
            elem--;
            int i = 1;
            while(i < elem){
                tab.set(i-1,tab.get(i));
                i++;
                System.out.println("Popped: "+ temp);
            }
        }
        //else {
        //    System.out.println("Buffer empty");
        //}

    }
    public void push(T thing){

        if(elem < tab.size()){
            System.out.println("Pushed: " + thing);
                tab.set(elem,thing);
            elem++;
        }
    }

            // System.out.println("Buffer full");
}


