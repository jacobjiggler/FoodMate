package com.foodmate;

import com.parse.ParseObject;

/**
 * Created by Robert Rouhani on 9/13/2014.
 */
public class FoodItemWrapper {
    private ParseObject obj;
    private boolean forShopping;

    public FoodItemWrapper(ParseObject obj) {
        if (!obj.getClassName().equals("Food_item"))
            throw new ClassCastException();

        this.obj = obj;
    }

    public FoodItemWrapper(ParseObject obj, boolean forShopping) {
        this(obj);
        this.forShopping = forShopping;
    }

    public ParseObject getObj() {
        return obj;
    }

    @Override
    public String toString() {
        if (!forShopping) {
            return (String) obj.get("name");
        }
        else {
            int num = obj.getInt("shared_by");
            return ((String)obj.get("name")).concat(" x" + Integer.toString(num));
        }
    }
}
