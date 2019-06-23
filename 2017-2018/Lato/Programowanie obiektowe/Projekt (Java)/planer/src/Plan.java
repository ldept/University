import java.io.Serializable;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Plan implements Serializable {

    List<IncCategory> incCategories;
    List<ExpCategory> expCategories;

    Plan(){
        incCategories = new ArrayList<>();
        expCategories = new ArrayList<>();
    }

    List<ExpCategory> getExpCategories() {
        return expCategories;
    }

    List<IncCategory> getIncCategories() {
        return incCategories;
    }

    public void setExpCategories(List<ExpCategory> expCategories) {
        this.expCategories = expCategories;
    }

    public void setIncCategories(List<IncCategory> incCategories) {
        this.incCategories = incCategories;
    }
    void addIncCategory(IncCategory incCategory){
        incCategories.add(incCategory);
    }
    void addExpCategory(ExpCategory expCategory){
        expCategories.add(expCategory);
    }
    void removeIncCategory(String name){

        for(IncCategory incCategory : incCategories) {
            if (incCategory.getName().equals(name)) {
                incCategories.remove(incCategory);
            }
        }
    }
    void removeExpCategory(String name){

        for(ExpCategory expCategory : expCategories) {
            if (expCategory.getName().equals(name)) {
                expCategories.remove(expCategory);
            }
        }
    }

    void addIncome(String name, Date date, float amount, String category){
        for(IncCategory incCategory : incCategories){
            if(incCategory.getName().equals(category)){
                incCategory.addMoney(name,amount,date);
            }
            sortList(incCategory.getMoneyList());
        }
    }
    void removeIncome(String name, String category){
        for(IncCategory incCategory : incCategories){
            if(incCategory.getName().equals(category)){
                for(Money money : incCategory.getMoneyList()){
                    if(money.getName().equals(name)){
                        incCategory.removeMoney(money);
                    }
                }
            }
        }
    }

    void removeExpense(String name, String category){
        for(ExpCategory expCategory : expCategories){
            if(expCategory.getName().equals(category)){
                for(Money money : expCategory.getMoneyList()){
                    if(money.getName().equals(name)){
                        if(expCategory.getBudget() > (expCategory.sumMoneyMonthly(money.getDate()) - money.getAmount())){
                            expCategory.setOver_budget(false);
                        }
                        expCategory.removeMoney(money);
                    }
                }
            }
        }
    }

    private void sortList(List<Money> moneyList) {
        moneyList.sort((o1, o2) -> {
            if(o2.getDate().isEarlier(o1.getDate())){
                return -1;
            }else if(o1.getDate().isEarlier(o2.getDate())){
                return 1;
            }else return 0;
        });
    }

    void addExpense(String name, Date date, float amount, String category){
        for(ExpCategory expCategory : expCategories){
            if(expCategory.getName().equals(category)){
                expCategory.addMoney(name,amount,date);
                if(expCategory.getBudget() < expCategory.sumMoneyMonthly(date)){
                    expCategory.setOver_budget(true);
                }
                sortList(expCategory.getMoneyList());
            }
        }
    }
    String categoryOverBudget(String name){
        for(ExpCategory expCategory : expCategories){
            if(expCategory.getName().equals(name)){
                if(expCategory.isOver_budget()){
                    float over = expCategory.sumMoney() - expCategory.getBudget();
                    return over + "over";
                }else return "OK";
            }
        }
        return "Brak takiej kategorii";
    }

    List<Money> getMoneyLists(){
        List<Money> list = new ArrayList<>();
        for(IncCategory incCategory : incCategories){
            list.addAll(incCategory.getMoneyList());
        }
        for(ExpCategory expCategory : expCategories){
            list.addAll(expCategory.getMoneyListNegative());
        }
        sortList(list);
        return list;
    }
    List<Money> getIncomesList(){
        List<Money> list = new ArrayList<>();
        for(IncCategory incCategory : incCategories){
            list.addAll(incCategory.getMoneyList());
        }
        sortList(list);
        return list;
    }
    List<Money> getExpensesList(){
        List<Money> list = new ArrayList<>();
        for(ExpCategory expCategory : expCategories){
            list.addAll(expCategory.getMoneyList());
        }
        sortList(list);
        return list;
    }

}
