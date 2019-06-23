import java.io.Serializable;
import java.util.Calendar;

public class Date implements Serializable {
    private int day;
    private int month;
    private int year;
    private boolean isLeap(int year){
        return ((year%4 == 0 && year%100 != 0) || year%400 == 0);
    }
    Date(){
       Calendar cal = Calendar.getInstance();
       day = cal.get(Calendar.DAY_OF_MONTH);
       month = cal.get(Calendar.MONTH) + 1;
       year = cal.get(Calendar.YEAR);

    }
    Date(int day, int month, int year){
        this.day = day;
        this.month = month;
        this.year = year;
    }
    public Date(Date date){
        this.day = date.day;
        this.month = date.month;
        this.year = date.year;
    }

    private int getDay() {
        return day;
    }

    int getMonth() {
        return month;
    }

    int getYear() {
        return year;
    }

    void setDay(int day) {
        this.day = day;
    }

    void setMonth(int month) {
        this.month = month;
    }

    void setYear(int year) {
        this.year = year;
    }

    boolean isSameDate(Date date){
        return (this.day == date.day && this.month == date.month && this.year == date.year);
    }

    boolean isEarlier(Date date){

        if(year < date.getYear()){
            return true;
        }
        if(year == date.getYear()){
            if(month < date.getMonth()){
                return true;

            }else return month == date.getMonth() && day < date.getDay();
        }
        return false;
    }
    boolean isEarlierOrSame(Date date){
        if(year < date.getYear()){
            return true;
        }
        if(year == date.getYear()){
            if(month < date.getMonth()){
                return true;

            }else return month == date.getMonth() && day <= date.getDay();
        }
        return false;
    }
    @Override
    public String toString() {
        return String.format("%d/%d/%d", day, month, year);
    }
}
