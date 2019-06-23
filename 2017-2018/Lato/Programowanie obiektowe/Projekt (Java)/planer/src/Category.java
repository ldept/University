import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class Category implements Serializable {
     String name;
     List<Money> moneyList;
    Category(String name){
        this.name = name;
        moneyList = new ArrayList<>();
    }
    String getName() {
        return name;
    }

    List<Money> getMoneyList() {
        return moneyList;
    }
    void addMoney(String name, float amount, Date date){
        moneyList.add(new Money(name,amount,date));
    }
    void removeMoney(Money money){
        moneyList.remove(money);
    }
    float sumMoney(){
        float sum = 0;
        for (Money money: moneyList) {
            sum += money.getAmount();
        }
        return sum;
    }
    float sumMoneyMonthly(Date date){
        float sum = 0;
        int month = date.getMonth();
        int year = date.getYear();
        Date date1 = new Date(1,month,year);
        Date date2 = new Date(31,month,year);
        for(Money money:moneyList){
            if(date1.isEarlierOrSame(money.getDate()) && money.getDate().isEarlierOrSame(date2)){
                sum += money.getAmount();
            }
        }
        return sum;
    }
    float sumMoneyToDate(Date date){
        float sum = 0;
        for (Money money: moneyList){
            if(money.getDate().isEarlierOrSame(date)){
                sum += money.getAmount();
            }
        }
        return sum;
    }
}

class ExpCategory extends Category {
    private float budget;
    private boolean over_budget;

    ExpCategory(String name, float budget){
        super(name);
        this.budget = budget;
        this.over_budget = false;
    }
    float getBudget() {
        return budget;
    }

    boolean isOver_budget() {
        return over_budget;
    }

    public void setBudget(float budget) {
        this.budget = budget;
    }

    void setOver_budget(boolean over_budget) {
        this.over_budget = over_budget;
    }

    public void alert(){
        if(this.sumMoney() > getBudget()){
            over_budget = true;
        }
    }
    List<Money> getMoneyListNegative(){
        List<Money> moneyList1 = moneyList;
        for(Money money : moneyList1){
            money.setAmount(-money.getAmount());
        }
        return moneyList1;
    }
}
class IncCategory  extends Category{

    IncCategory(String name){
        super(name);
    }

}
