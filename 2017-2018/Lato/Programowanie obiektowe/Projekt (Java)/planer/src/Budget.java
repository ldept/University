import java.io.Serializable;
import java.util.List;

public class Budget implements Serializable {
    private float current_money;
    private Date current_date;
    private Plan actualPlan;
    private Plan expectedPlan;
    private static final long serialVersionUID = 1L;

    Budget(){
        current_money = 0;
        current_date = new Date();
        actualPlan = new Plan();
        expectedPlan = new Plan();
    }

    float getCurrent_money() {
        current_money = current_balance();
        return current_money;
    }
    Date getCurrent_date() {
        return current_date;
    }
    String showDate(){
        return this.current_date.toString();
    }
    Plan getActualPlan() { return this.actualPlan; }
    Plan getExpectedPlan() { return this.expectedPlan; }
    void setCurrent_date(){
        current_date = new Date();
    }

    float balanceTo(Date date, Plan plan){
        float balance = 0;
        for (IncCategory incCategory:
                plan.incCategories) {
            balance += incCategory.sumMoneyToDate(date);
        }
        for(ExpCategory expCategory: plan.expCategories){
            balance -= expCategory.sumMoneyToDate(date);
        }
        return balance;
    }

    private float current_balance(){
        return balanceTo(current_date,actualPlan);
    }
    float balance(Plan plan){
        float balance = 0;
        for (IncCategory incCategory:
             plan.incCategories) {
            balance += incCategory.sumMoney();
        }
        for(ExpCategory expCategory: plan.expCategories){
            balance -= expCategory.sumMoney();
        }
        return balance;
    }

    void addIncCategory(String name){
        IncCategory newIC = new IncCategory(name);
        actualPlan.addIncCategory(newIC);
        expectedPlan.addIncCategory(newIC);
    }
    void addExpCategory(String name, float budget){
        ExpCategory newEC = new ExpCategory(name, budget);
        actualPlan.addExpCategory(newEC);
        expectedPlan.addExpCategory(newEC);
    }
    void addIncome(Plan plan, String name, Date date, float amount, String category){
        plan.addIncome(name,date,amount,category);
    }
    void addExpense(Plan plan, String name, Date date, float amount, String category){
        plan.addExpense(name,date,amount,category);
    }
    void removeExpCategory(String name){
        actualPlan.removeExpCategory(name);
        expectedPlan.removeExpCategory(name);
    }
    void removeIncCategory(String name){
        actualPlan.removeIncCategory(name);
        expectedPlan.removeIncCategory(name);
    }
    void removeIncome(Plan plan, String category, String income){
        plan.removeIncome(income,category);
    }

    void removeExpense(Plan plan, String category, String expense){
        plan.removeExpense(expense,category);
    }
    public String categoryOverBudget(String name){
        return actualPlan.categoryOverBudget(name);
    }
    boolean analyze(){
        float sum = 0;
        for(Money money : expectedPlan.getMoneyLists()){
            sum += money.getAmount();
            if(sum < 0){
                return false;
            }
        }
        return true;
    }
    void resetExpectedPlan(){
        for(Money money : expectedPlan.getMoneyLists()){
            if(money.getDate().getMonth() < current_date.getMonth()){
                expectedPlan.getMoneyLists().remove(money);
            }
        }
    }
}
