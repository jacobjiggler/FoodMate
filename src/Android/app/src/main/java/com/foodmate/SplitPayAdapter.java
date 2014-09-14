package com.foodmate;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by Robert Rouhani on 9/14/2014.
 */
public class SplitPayAdapter extends ArrayAdapter<Payee> {
    private final Context context;
    private final ArrayList<Payee> itemsArrayList;

    public SplitPayAdapter(Context context, ArrayList<Payee> itemsArrayList) {

        super(context, R.layout.split_cost_row, itemsArrayList);

        this.context = context;
        this.itemsArrayList = itemsArrayList;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        // 1. Create inflater
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        // 2. Get rowView from inflater
        View rowView = inflater.inflate(R.layout.split_cost_row, parent, false);

        // 3. Get the two text view from the rowView
        TextView labelView = (TextView) rowView.findViewById(R.id.split_cost_label);
        Button buttonView = (Button) rowView.findViewById(R.id.split_cost_button);

        // 4. Set the text for textView
        Payee p = itemsArrayList.get(position);
        labelView.setText(p.getName() + " - $" + p.getAmount());
        buttonView.setText("Pay");
        buttonView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //TODO venmo here
            }
        });

        // 5. retrn rowView
        return rowView;
    }
}
