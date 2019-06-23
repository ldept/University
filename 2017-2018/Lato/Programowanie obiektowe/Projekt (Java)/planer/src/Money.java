import java.io.Serializable;

public class Money implements Serializable {

    private String name;
    private float amount;
    private Date  date;
    private boolean ischecked;

    boolean isIschecked() {
        return ischecked;
    }

    Date getDate() {
        return date;
    }

    float getAmount() {
        return amount;
    }

    String getName() {
        return name;
    }

    void setAmount(float amount) {
        this.amount = amount;
    }

    void setDate(Date date) {
        this.date = date;
    }

    void setName(String name) {
        this.name = name;
    }

    void setIschecked(boolean ischecked) {
        this.ischecked = ischecked;
    }
    Money(String name, float amount, Date date){
        this.name = name;
        this.amount = amount;
        this.date = date;
        this.ischecked = false;
    }

    @Override
    public String toString() {
        return name + " " + amount + "zł " + date.toString();
    }
}
