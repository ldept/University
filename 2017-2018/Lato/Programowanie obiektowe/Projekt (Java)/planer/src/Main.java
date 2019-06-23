import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        Budget budget = new Budget();
        if (Files.exists(Paths.get("Budget.ser"))) {
            FileInputStream fis = null;
            ObjectInputStream in = null;
            try {
                fis = new FileInputStream("Budget.ser");
                in = new ObjectInputStream(fis);
                budget = (Budget) in.readObject();
                budget.setCurrent_date();

                in.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        boolean done = false;
       // Budget budget = new Budget();
      /*  budget.addIncome(budget.getExpectedPlan(),"Wypłata",new Date(24,6,2018),2000,"Praca");
        budget.addIncCategory("Praca");
        budget.addExpCategory("Rachunki",500);
        budget.addIncome(budget.getActualPlan(),"Income",budget.getCurrent_date(),200,"Praca");
        budget.addIncome(budget.getActualPlan(),"Income2",budget.getCurrent_date(),200,"Praca");
        budget.removeIncome(budget.getActualPlan(),"Praca","Income");
        budget.addExpense(budget.getActualPlan(),"Gaz",budget.getCurrent_date(), 5500.45f, "Rachunki");
       /* System.out.println(budget.analyze());
        //System.out.println(budget.categoryOverBudget("Rachunki"));
        System.out.println(budget.balance(budget.getActualPlan()));
        boolean done = false;
        */

        while (!done) {
            mainMenu(budget);
            Scanner s = new Scanner(System.in);
            int option = s.nextInt();
            switch (option) {
                case 1:
                    actualPlan();
                    int actOption = s.nextInt();
                    switch (actOption) {
                        case 1:
                            money();
                            int eopt = s.nextInt();
                            s.nextLine();

                            System.out.println("Wydatki");
                            handleExpense(budget,"actual", s, eopt);
                            break;
                        case 2:
                            money();
                            int inopt = s.nextInt();
                            s.nextLine();
                            System.out.println("Dochody");
                            handleIncome(budget,"actual",s,inopt);
                            break;
                        case 3:
                            System.out.println("Podaj date bilansu");
                            int day = s.nextInt();
                            int month = s.nextInt();
                            int year = s.nextInt();
                            System.out.println(budget.balanceTo(new Date(day,month,year),budget.getActualPlan()));
                            break;
                        case 4:
                            for(ExpCategory expCategory : budget.getActualPlan().getExpCategories()){
                                if(expCategory.isOver_budget()){
                                    System.out.print(expCategory.getName() + " " + budget.categoryOverBudget(expCategory.getName()));
                                    System.out.println();
                                }
                            }
                            break;
                        default:
                            break;
                    }

                    break;
                case 2:
                    expectedPlan();
                    int expOption = s.nextInt();
                    switch (expOption) {
                        case 1:
                            money();
                            int eopt = s.nextInt();
                            s.nextLine();

                            handleExpense(budget,"expected",s, eopt);
                            break;
                        case 2:
                            money();
                            int iopt = s.nextInt();
                            s.nextLine();

                            System.out.println("Dochody");
                            handleIncome(budget,"expected",s,iopt);
                            break;
                        case 3:
                            if (budget.analyze()) {
                                System.out.println("Wszystko ok");
                            } else System.out.println("Wydatki przekraczają dochody");
                            break;
                        case 4:
                            for(ExpCategory expCategory : budget.getExpectedPlan().getExpCategories()){
                                if(expCategory.isOver_budget()){
                                    System.out.print(expCategory.getName() + " " + budget.categoryOverBudget(expCategory.getName()));
                                    System.out.println();
                                }
                            }
                        case 5:
                            System.out.println("Podaj date bilansu");
                            int day = s.nextInt();
                            int month = s.nextInt();
                            int year = s.nextInt();
                            System.out.println(budget.balanceTo(new Date(day,month,year),budget.getExpectedPlan()));
                            break;

                        default:
                            break;
                    }

                    break;
                case 3:
                    saveObject(budget);
                    break;
                case 4:
                    done = true;
                    break;
                default:
                    break;
            }
        }
    }


    private static void handleIncome(Budget budget, String plan, Scanner s, int eopt) {
        switch (eopt){
            case 1:
                if(plan.equals("expected")){
                    for(Money money : budget.getExpectedPlan().getIncomesList()){
                        System.out.println(money.toString());
                    }
                }else {
                    for(Money money : budget.getActualPlan().getIncomesList()){
                        System.out.println(money.toString());
                    }
                }

                break;
            case 2:
                System.out.println("Podaj nazwę kategorii");
                String catname = s.nextLine();
                System.out.println("Podaj nazwe");
                String name = s.nextLine();
                System.out.println("Podaj wysokość");
                float amount = s.nextFloat();
                System.out.println("Podaj date: d [enter] m [enter] y [enter] ");
                int day = s.nextInt();
                int month = s.nextInt();
                int year = s.nextInt();
                if(plan.equals("expected")){
                    budget.addIncome(budget.getExpectedPlan(),name,new Date(day,month,year),amount,catname);
                }else budget.addIncome(budget.getActualPlan(),name,new Date(day,month,year),amount,catname);
                break;
            case 3:
                System.out.println("Podaj nazwę kategorii");
                String rcatname = s.nextLine();
                System.out.println("Podaj nazwe");
                String rname = s.nextLine();
                if(plan.equals("expected")){
                    budget.removeIncome(budget.getExpectedPlan(),rcatname,rname);
                }else budget.removeIncome(budget.getActualPlan(),rcatname,rname);
                break;
            case 4:
                if(plan.equals("expected")){
                    for(Category category : budget.getExpectedPlan().getIncCategories()){
                        System.out.println(category.getName());
                    }
                }else
                    for(Category category : budget.getActualPlan().getIncCategories()){
                        System.out.println(category.getName());
                    }
                break;

            case 5:
                System.out.println("Podaj nazwe");
                String cname = s.nextLine();
                budget.addIncCategory(cname);
                break;
            case 6:
                System.out.println("Podaj nazwe kategorii");
                String rcname = s.nextLine();
                budget.removeIncCategory(rcname);
            default:
                break;
        }
    }
    private static void handleExpense(Budget budget, String plan, Scanner s, int eopt) {
        switch (eopt){
            case 1:
                if(plan.equals("expected")){
                    for(Money money : budget.getExpectedPlan().getExpensesList())
                    {
                        System.out.println(money.toString());
                    }
                }else {
                    for(Money money : budget.getActualPlan().getExpensesList())
                    {
                        System.out.println(money.toString());
                    }
                }

                break;
            case 2:
                System.out.println("Podaj nazwę kategorii");
                String catname = s.nextLine();
                System.out.println("Podaj nazwe");
                String name = s.nextLine();
                System.out.println("Podaj wysokość");
                float amount = s.nextFloat();
                System.out.println("Podaj date: d [enter] m [enter] y [enter] ");
                int day = s.nextInt();
                int month = s.nextInt();
                int year = s.nextInt();
                if(plan.equals("expected")){
                    budget.addExpense(budget.getExpectedPlan(),name,new Date(day,month,year),amount,catname);
                }else budget.addExpense(budget.getActualPlan(),name,new Date(day,month,year),amount,catname);
                break;
            case 3:
                System.out.println("Podaj nazwę kategorii");
                String rcatname = s.nextLine();
                System.out.println("Podaj nazwe");
                String rname = s.nextLine();
                if(plan.equals("expected")){
                    budget.removeExpense(budget.getExpectedPlan(),rcatname,rname);
                }else budget.removeExpense(budget.getActualPlan(),rcatname,rname);
                break;
            case 4:
                if(plan.equals("expected")){
                    for(Category category : budget.getExpectedPlan().getExpCategories()){
                        System.out.println(category.getName());
                    }
                }else
                    for(Category category : budget.getActualPlan().getExpCategories()){
                        System.out.println(category.getName());
                    }
                break;

            case 5:
                System.out.println("Podaj nazwe");
                String cname = s.nextLine();
                System.out.println("Podaj budzet");
                float bg = s.nextFloat();
                budget.addExpCategory(cname,bg);
                break;
            case 6:
                System.out.println("Podaj nazwe kategorii");
                String rcname = s.nextLine();
                budget.removeExpCategory(rcname);
                break;
            default:
                break;
        }
    }


    private static void saveObject(Budget budget){
        FileOutputStream fos = null;
        ObjectOutputStream out = null;
        try {
            fos = new FileOutputStream("Budget.ser");
            out = new ObjectOutputStream(fos);
            out.writeObject(budget);
            out.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private static void mainMenu(Budget budget){
        System.out.println();
        System.out.println("Budżet: " + budget.getCurrent_money() + "zł, " + "Data: " + budget.showDate() );
        System.out.println("Co chcesz zrobic?");
        System.out.println("1. Faktyczny budżet");
        System.out.println("2. Planowany budżet");
        System.out.println("3. Zapisz zmiany");
        System.out.println("4. Wyjdź");
    }
    private static void actualPlan(){
        System.out.println();
        System.out.println("1. Wydatki");
        System.out.println("2. Dochody");
        System.out.println("3. Bilans");
        System.out.println("4. Czy kategorie przekraczają budżet");
        System.out.println("5. Wróć");

    }
    private static void expectedPlan(){
        System.out.println();
        System.out.println("1. Wydatki");
        System.out.println("2. Dochody");
        System.out.println("3. Analizuj");
        System.out.println("4. Czy kategorie przekraczaja budżet");
        System.out.println("5. Bilans");
        System.out.println("6. Wróć");
    }
    private static void money(){
        System.out.println();
        System.out.println("1. Pokaż wszystkie");
        System.out.println("2. Dodaj");
        System.out.println("3. Usuń");
        System.out.println("4. Pokaż wszystkie kategorie");
        System.out.println("5. Dodaj kategorie");
        System.out.println("6. Usuń kategorie");
        System.out.println("7. Wróć");
    }
}