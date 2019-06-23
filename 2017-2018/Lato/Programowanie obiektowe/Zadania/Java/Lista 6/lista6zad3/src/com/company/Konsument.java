package com.company;

public class Konsument implements  Runnable{
    private Buffer buffer;
    public Konsument(Buffer buffer){
        this.buffer = buffer;
    }

    @Override
    public void run() {
        System.out.println("Konsument started");
        synchronized (buffer){
            try{
                Thread.sleep(1000);
                buffer.pop();
                buffer.notifyAll();
            }
            catch (InterruptedException e){
                e.printStackTrace();
            }
        }
    }
}
