package com.foodmate;

/**
 * Created by Robert Rouhani on 9/14/2014.
 */
public class Payee {
    private String name;
    private String id;
    private Number amount;

    public Payee(String name, String id, Number amount) {
        this.name = name;
        this.id = id;
        this.amount = amount;
    }

    public String getName() {
        return name;
    }

    public String getId() {
        return id;
    }

    public Number getAmount() {
        return amount;
    }
}
