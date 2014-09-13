package com.foodmate;

import com.parse.ParseObject;

/**
 * Created by Robert Rouhani on 9/13/2014.
 */
public class FoodItemWrapper {
    private ParseObject obj;

    public FoodItemWrapper(ParseObject obj) {
        if (!obj.getClassName().equals("Food_item"))
            throw new ClassCastException();

        this.obj = obj;
    }

    public ParseObject getObj() {
        return obj;
    }

    @Override
    public String toString() {
        return (String)obj.get("name");
    }
}
