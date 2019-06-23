package com.company;

import java.util.Random;

public class Producent implements Runnable{

    private Buffer buffer;
    Producent(Buffer buffer){
        this.buffer = buffer;
    }
    private static String randomString(){
        Random generator = new Random();
        char[] text = new char[10];
        for(int i = 0; i<10;i++)
            text[i] = (char) generator.nextInt(9);

        return new String(text);
    }

    @Override
    public void run() {
        System.out.println("Producent started");
        synchronized (buffer){
            try{
                buffer.push(randomString());
                buffer.wait();
            }
            catch (InterruptedException e){
                e.printStackTrace();
            }
        }
    }
}
