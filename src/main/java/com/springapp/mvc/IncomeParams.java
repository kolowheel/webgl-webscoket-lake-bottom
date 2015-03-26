package com.springapp.mvc;

/**
 * @author Yaroslav.Gryniuk
 */
public class IncomeParams {
    private int id;
    private double soundSpeed;

    public IncomeParams(){}
    public IncomeParams(int id,double soundSpeed){

        this.id = id;
        this.soundSpeed = soundSpeed;
    }
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getSoundSpeed() {
        return soundSpeed;
    }

    public void setSoundSpeed(double soundSpeed) {
        this.soundSpeed = soundSpeed;
    }
}
