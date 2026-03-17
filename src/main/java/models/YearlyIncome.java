package models;

/**
 * Represents aggregated income data for a single calendar year.
 */
public class YearlyIncome {

    private int year;
    private double completedIncome;
    private double pendingIncome;

    public YearlyIncome() {}

    public YearlyIncome(int year, double completedIncome, double pendingIncome) {
        this.year            = year;
        this.completedIncome = completedIncome;
        this.pendingIncome   = pendingIncome;
    }

    public int    getYear()  { return year; }
    public void   setYear(int year) { this.year = year; }

    public double getCompletedIncome()                       { return completedIncome; }
    public void   setCompletedIncome(double completedIncome) { this.completedIncome = completedIncome; }

    public double getPendingIncome()                     { return pendingIncome; }
    public void   setPendingIncome(double pendingIncome) { this.pendingIncome = pendingIncome; }

    public double getTotalIncome() { return completedIncome + pendingIncome; }
}
