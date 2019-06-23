package com.company;

import java.util.Random;

public class Main {

    public static void mergeSort(int[] tab, int first, int last){
        if(first != tab.length && first !=last){
            int mid = (first + last) / 2;
            mergeSort(tab,first, mid);
            mergeSort(tab,mid + 1, last);
            merge(tab,first,mid,last);
        }
    }
    private static void finalMerge(int[] tab, int[] tab1, int[] tab2){
        int left = 0;
        int right = 0;
        int i = 0;
        while(left < tab1.length && right < tab2.length){
            tab[i++] = (tab1[left] < tab2[right]) ? tab1[left++] : tab2[left++];
        }
        while(left<tab1.length){
            tab[i++] = tab1[left++];
        }
        while(right<tab2.length){
            tab[i++] = tab2[right++];
        }
    }
    private static void merge(int[] tab, int first, int mid, int last){
        int[] tempTab = new int[tab.length];
        int left = first;
        int right = mid + 1;
        int i = first;
        while(left < mid+1 && right <= last){
            tempTab[i++] = (tab[left] < tab[right]) ? tab[left++] : tab[right++];
        }
        while(left < mid + 1){
            tempTab[i++] = tab[left++];
        }
        while(right <= last){
            tempTab[i++] = tab[right++];
        }



        System.arraycopy(tempTab, first, tab, first, last + 1 - first);
    }
    private static void randomNumbers (int[] data)
    {
        Random generator = new Random();

        for ( int i = 0; i < data.length; i++)
            data[i] = generator.nextInt(50);
    }

    public static void main(String[] args) {

        int tab[] = new int[10];
        randomNumbers(tab);
        int tabCopy[] = new int[tab.length];
        long startSingle = 0;
        long endSingle = 0;
        long startDual = 0;
        long endDual = 0;

        System.arraycopy(tab,0,tabCopy,0, tab.length);
        System.out.println();

        //int[] tabThread1 = new int[tab.length / 2];
        //int[] tabThread2 = new int[tab.length - tab.length/2];
        //for(int i = 0; i<tab.length/2){
        //    tabThread1[i] = tab[i];
        //}
        //for(int i = tab.length/2;i<tab.length;i++){
        //    tabThread2[i - tab.length/2] = tab[i];
        //}
        //Sort t1 = new Sort(tabThread1,0,tabThread1.length);
        //Sort t2 = new Sort(tabThread2,0,tabThread2.length);

        for(int i = 0; i<tab.length;i++){
            System.out.print(tab[i]+ " ");
        }
        System.out.println();
        Sort thread1 = new Sort(tab,0, (tab.length - 1) / 2);
        Sort thread2 = new Sort(tab, (tab.length - 1)/ 2 + 1, tab.length - 1);

        startDual = System.currentTimeMillis();
        thread1.start();
        thread2.start();
        try {
            thread1.join();
            thread2.join();
        } catch (InterruptedException e) {

            e.printStackTrace();
        }
        merge(tab,0,(tab.length - 1) / 2, tab.length - 1);
        endDual = System.currentTimeMillis();

        for(int i = 0;i<tab.length;i++){
            System.out.print(tab[i]+ " ");
        }
        startSingle = System.currentTimeMillis();
        mergeSort(tabCopy,0,tabCopy.length - 1);
        endSingle = System.currentTimeMillis();


        System.out.print(endDual - startDual);
        System.out.println();

        System.out.print(endSingle - startSingle);

        boolean sorted = true;
        for(int i = 0; i < tabCopy.length; i++){
            for(int j = i+1;j<tabCopy.length; j++){
                if(tabCopy[j] < tabCopy[i]){
                    sorted = false;
                }
            }

        }
        for(int i = 0; i < tabCopy.length; i++){
            for(int j = i+1;j<tabCopy.length; j++){
                if(tab[j] < tab[i]){
                    sorted = false;
                }
            }

        }
        if(!sorted){
            System.out.println("cos sie nie posortowalo");
        }

    }

}
