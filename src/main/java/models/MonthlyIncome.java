package models;

import java.time.Month;
import java.time.format.TextStyle;
import java.util.Locale;

/**
 * Represents aggregated income data for a single calendar month.
 */
public class MonthlyIncome {

    private int year;
    private int month; // 1–12
    private double completedIncome;
    private double pendingIncome;

    public MonthlyIncome() {}

    public MonthlyIncome(int year, int month, double completedIncome, double pendingIncome) {
        this.year            = year;
        this.month           = month;
        this.completedIncome = completedIncome;
        this.pendingIncome   = pendingIncome;
    }

    public int    getYear()  { return year; }
    public void   setYear(int year)   { this.year = year; }

    public int    getMonth() { return month; }
    public void   setMonth(int month) { this.month = month; }

    public double getCompletedIncome()                       { return completedIncome; }
    public void   setCompletedIncome(double completedIncome) { this.completedIncome = completedIncome; }

    public double getPendingIncome()                     { return pendingIncome; }
    public void   setPendingIncome(double pendingIncome) { this.pendingIncome = pendingIncome; }

    public double getTotalIncome() { return completedIncome + pendingIncome; }

    /** Short month label, e.g. "Mar 2026". */
    public String getLabel() {
        return Month.of(month).getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + year;
    }
}
