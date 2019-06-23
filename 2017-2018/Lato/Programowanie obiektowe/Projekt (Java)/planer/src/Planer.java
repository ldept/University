import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

public class Planer {
    private JPanel MainPanel;
    private JTabbedPane tabbedPane1;
    private JPanel Actual;
    private JPanel Expected;
    private JTabbedPane tabbedPane2;
    private JTabbedPane tabbedPane3;
    private JPanel ActIncome;
    private JPanel ActExpense;
    private JPanel ExpIncome;
    private JPanel ExpExpense;
    private JList CatList;
    private JList IncList;

    public Planer() {
        CatList.addListSelectionListener(new ListSelectionListener() {
            @Override
            public void valueChanged(ListSelectionEvent e) {
                
            }
        });
    }

    private void createUIComponents() {
        // TODO: place custom component creation code here
    }
}
