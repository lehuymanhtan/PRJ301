package models;

import java.time.LocalDate;

/**
 * Represents aggregated income data for a single day.
 * Populated from the vw_DailyIncome view.
 */
public class DailyIncome {

    private LocalDate incomeDate;
    private double completedIncome;
    private double pendingIncome;

    public DailyIncome() {}

    public DailyIncome(LocalDate incomeDate, double completedIncome, double pendingIncome) {
        this.incomeDate      = incomeDate;
        this.completedIncome = completedIncome;
        this.pendingIncome   = pendingIncome;
    }

    public LocalDate getIncomeDate()                  { return incomeDate; }
    public void setIncomeDate(LocalDate incomeDate)   { this.incomeDate = incomeDate; }

    public double getCompletedIncome()                      { return completedIncome; }
    public void setCompletedIncome(double completedIncome)  { this.completedIncome = completedIncome; }

    public double getPendingIncome()                    { return pendingIncome; }
    public void setPendingIncome(double pendingIncome)  { this.pendingIncome = pendingIncome; }

    public double getTotalIncome() {
        return completedIncome + pendingIncome;
    }
}
