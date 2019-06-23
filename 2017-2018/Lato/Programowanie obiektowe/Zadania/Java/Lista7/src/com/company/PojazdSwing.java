package com.company;
import javax.swing.*;
import java.io.*;
import java.awt.event.*;


public class PojazdSwing implements ActionListener{
    JLabel waga_label, maks_predkosc_label, benzyna_label;
    JTextField waga_text, maks_predkosc_text,benzyna_text;
    JButton save,load;
    JFrame f;

    PojazdSwing(){
        f = new JFrame("Ewidencja Pojazdów");
    }
    public PojazdSwing(Pojazd p){
        f = new JFrame("Ewidencja Pojazdów");

        waga_label = new JLabel("Waga");
        waga_label.setBounds(18,48,120,48);
        maks_predkosc_label = new JLabel("Maks predkosc");
        maks_predkosc_label.setBounds(18,114,120,48);
        benzyna_label = new JLabel("Benzyna?");
        benzyna_label.setBounds(18,178,120,48);
        waga_text = new JTextField(Integer.toString(p.waga));
        waga_text.setBounds(156,48,120,48);
        maks_predkosc_text = new JTextField(Integer.toString(p.maks_predkosc));
        maks_predkosc_text.setBounds(156,114,120,48);
        benzyna_text = new JTextField(Boolean.toString(p.benzyna));
        benzyna_text.setBounds(156,178,120,48);
        save = new JButton(new AbstractAction("Zapisz") {
            @Override
            public void actionPerformed(ActionEvent e) {
                String w,mp,ben;
                w = waga_text.getText();
                mp = maks_predkosc_text.getText();
                ben = benzyna_text.getText();

                int wi = Integer.parseInt(w);
                int mpi = Integer.parseInt(mp);
                boolean benb = Boolean.parseBoolean(ben);

                Pojazd pojazd = new Pojazd(wi,mpi,benb);
                save_object(pojazd);
            }
        });
        save.setBounds(18, 242,120,48);
        //save.addActionListener(this);

        load = new JButton(new AbstractAction("Wczytaj") {
            @Override
            public void actionPerformed(ActionEvent e) {
                Pojazd pojazd = null;
                try{
                    FileInputStream fileIn = new FileInputStream("Pojazd.ser");
                    ObjectInputStream in = new ObjectInputStream(fileIn);
                    pojazd = (Pojazd) in.readObject();
                    in.close();
                    fileIn.close();
                    waga_text.setText(Integer.toString(pojazd.waga));
                    maks_predkosc_text.setText(Integer.toString(pojazd.maks_predkosc));
                    benzyna_text.setText(Boolean.toString(pojazd.benzyna));

                }catch(IOException i) {
                    i.printStackTrace();
                }catch (ClassNotFoundException c) {
                    System.out.println("Pojazd class not found");
                    c.printStackTrace();
                }
            }
        });
        load.setBounds(156,242,120,48);
        //load.addActionListener(this);

        f.add(this.waga_text);f.add(this.waga_label);f.add(this.maks_predkosc_text);f.add(this.maks_predkosc_label);
        f.add(this.benzyna_label);f.add(this.benzyna_text);f.add(this.save); f.add(this.load);

        f.setSize(1280,720);
        f.setLayout(null);
        f.setVisible(true);

    }

    @Override
    public void actionPerformed(ActionEvent e) {

    }
    static void save_object(Pojazd pojazd) {
        try{
            FileOutputStream fileOut = new FileOutputStream("Pojazd.ser");
            ObjectOutputStream out = new ObjectOutputStream(fileOut);
            out.writeObject(pojazd);
            out.close();
            fileOut.close();
            System.out.println("Zserowano pojazd");

        } catch (IOException i){
            i.printStackTrace();
        }
    }
}
class SamochodSwing extends PojazdSwing{
    JLabel marka_label, model_label, cena_label;
    JTextField marka_text, model_text,cena_text;

    SamochodSwing(Samochod p){
        //super(p);
        super();
        //f = new JFrame("Ewidencja Pojazdów");

        waga_label = new JLabel("Waga");
        waga_label.setBounds(18,48,120,48);
        maks_predkosc_label = new JLabel("Maks predkosc");
        maks_predkosc_label.setBounds(18,114,120,48);
        benzyna_label = new JLabel("Benzyna?");
        benzyna_label.setBounds(18,178,120,48);
        waga_text = new JTextField(Integer.toString(p.waga));
        waga_text.setBounds(156,48,120,48);
        maks_predkosc_text = new JTextField(Integer.toString(p.maks_predkosc));
        maks_predkosc_text.setBounds(156,114,120,48);
        benzyna_text = new JTextField(Boolean.toString(p.benzyna));
        benzyna_text.setBounds(156,178,120,48);

        marka_label = new JLabel("Marka");
        model_label = new JLabel("Model");
        cena_label = new JLabel("Cena");
        marka_label.setBounds(312,48,120, 48);
        model_label.setBounds(312,114,120,48);
        cena_label.setBounds(312, 178,120,48);

        marka_text = new JTextField(p.marka);
        model_text = new JTextField(p.model);
        cena_text = new JTextField(Integer.toString(p.cena));
        marka_text.setBounds(450,48,120,48);
        model_text.setBounds(450,114,120,48);
        cena_text.setBounds(450,178,120,48);
        save = new JButton(new AbstractAction("Zapisz") {
            @Override
            public void actionPerformed(ActionEvent e) {
                String w,mp,ben;
                w = waga_text.getText();
                mp = maks_predkosc_text.getText();
                ben = benzyna_text.getText();

                int wi = Integer.parseInt(w);
                int mpi = Integer.parseInt(mp);
                boolean benb = Boolean.parseBoolean(ben);

                String ma = marka_text.getText();
                String mr = model_text.getText();
                String ce = cena_text.getText();
                int cei = Integer.parseInt(ce);
                Pojazd pojazd = new Samochod(wi,mpi,benb,ma,mr,cei);
                PojazdSwing.save_object(pojazd);
            }
        });
        load = new JButton(new AbstractAction("Wczytaj") {
            @Override
            public void actionPerformed(ActionEvent e) {
                Samochod pojazd = null;
                try{
                    FileInputStream fileIn = new FileInputStream("Pojazd.ser");
                    ObjectInputStream in = new ObjectInputStream(fileIn);
                    pojazd = (Samochod) in.readObject();
                    in.close();
                    fileIn.close();
                    waga_text.setText(Integer.toString(pojazd.waga));
                    maks_predkosc_text.setText(Integer.toString(pojazd.maks_predkosc));
                    benzyna_text.setText(Boolean.toString(pojazd.benzyna));
                    model_text.setText(pojazd.model);
                    marka_text.setText(pojazd.marka);
                    cena_text.setText(Integer.toString(pojazd.cena));

                }catch(IOException i) {
                    i.printStackTrace();
                }catch (ClassNotFoundException c) {
                    System.out.println("Pojazd class not found");
                    c.printStackTrace();
                }
            }
        });
        save.setBounds(18, 242,120,48);
        load.setBounds(156,242,120,48);

        f.add(this.cena_text); f.add(this.cena_label); f.add(this.save); f.add(this.load);
        f.add(this.model_text); f.add(this.model_label); f.add(this.marka_text); f.add(this.marka_label);
        f.add(this.waga_text);f.add(this.waga_label);f.add(this.maks_predkosc_text);f.add(this.maks_predkosc_label);
        f.add(this.benzyna_label);f.add(this.benzyna_text);f.add(this.save); f.add(this.load);

        f.setSize(1280,720);
        f.setLayout(null);
        f.setVisible(true);
    }

}
class TramwajSwing extends PojazdSwing{
    JLabel miasto_label, trasa_label, numer_label;
    JTextField miasto_text, trasa_text,numer_text;

    TramwajSwing(Tramwaj p){
        super(p);
        miasto_label = new JLabel("miasto");
        trasa_label = new JLabel("trasa");
        numer_label = new JLabel("numer");
        miasto_label.setBounds(450,48,120, 48);
        trasa_label.setBounds(450,114,120,48);
        numer_label.setBounds(450, 178,120,48);

        miasto_text = new JTextField(p.miasto);
        trasa_text = new JTextField(p.trasa);
        numer_text = new JTextField(Integer.toString(p.numer));
        miasto_text.setBounds(558,48,120,48);
        trasa_text.setBounds(558,114,120,48);
        numer_text.setBounds(558,178,120,48);
        save = new JButton(new AbstractAction("Zapisz") {
            @Override
            public void actionPerformed(ActionEvent e) {
                String w,mp,ben;
                w = waga_text.getText();
                mp = maks_predkosc_text.getText();
                ben = benzyna_text.getText();

                int wi = Integer.parseInt(w);
                int mpi = Integer.parseInt(mp);
                boolean benb = Boolean.parseBoolean(ben);

                String ma = miasto_text.getText();
                String mr = trasa_text.getText();
                String ce = numer_text.getText();
                int cei = Integer.parseInt(ce);
                Pojazd pojazd = new Samochod(wi,mpi,benb,ma,mr,cei);
                PojazdSwing.save_object(pojazd);
            }
        });
        load = new JButton(new AbstractAction("Wczytaj") {
            @Override
            public void actionPerformed(ActionEvent e) {
                Tramwaj pojazd = null;
                try{
                    FileInputStream fileIn = new FileInputStream("Pojazd.ser");
                    ObjectInputStream in = new ObjectInputStream(fileIn);
                    pojazd = (Tramwaj) in.readObject();
                    in.close();
                    fileIn.close();
                    waga_text.setText(Integer.toString(pojazd.waga));
                    maks_predkosc_text.setText(Integer.toString(pojazd.maks_predkosc));
                    benzyna_text.setText(Boolean.toString(pojazd.benzyna));
                    trasa_text.setText(pojazd.trasa);
                    miasto_text.setText(pojazd.miasto);
                    numer_text.setText(Integer.toString(pojazd.numer));

                }catch(IOException i) {
                    i.printStackTrace();
                }catch (ClassNotFoundException c) {
                    System.out.println("Pojazd class not found");
                    c.printStackTrace();
                }
            }
        });
        save.setBounds(18, 242,120,48);
        load.setBounds(156,242,120,48);
        f.add(this.numer_text); f.add(this.numer_label); f.add(this.save); f.add(this.load);
        f.add(this.trasa_text); f.add(this.trasa_label); f.add(this.miasto_text); f.add(this.miasto_label);
        f.add(this.waga_text);f.add(this.waga_label);f.add(this.maks_predkosc_text);f.add(this.maks_predkosc_label);
        f.add(this.benzyna_label);f.add(this.benzyna_text);f.add(this.save); f.add(this.load);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        String w,mp,ben;
        w = waga_text.getText();
        mp = maks_predkosc_text.getText();
        ben = benzyna_text.getText();

        int wi = Integer.parseInt(w);
        int mpi = Integer.parseInt(mp);
        boolean benb = Boolean.parseBoolean(ben);

        String ma = miasto_text.getText();
        String mr = trasa_text.getText();
        String ce = numer_text.getText();
    }
    
}
