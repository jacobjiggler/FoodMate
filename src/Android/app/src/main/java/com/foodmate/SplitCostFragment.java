package com.foodmate;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import java.util.ArrayList;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link SplitCostFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class SplitCostFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    private ArrayList<Payee> splitAmounts;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment SplitCostFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static SplitCostFragment newInstance(String param1, String param2) {
        SplitCostFragment fragment = new SplitCostFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }
    public SplitCostFragment() {
        // Required empty public constructor
    }

    public SplitCostFragment(ArrayList<Payee> amounts) {
        splitAmounts = amounts;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        final ListView v = (ListView)inflater.inflate(R.layout.fragment_split_cost, container, false);

        ArrayAdapter<Payee> adapter = new SplitPayAdapter(v.getContext(), splitAmounts);
        v.setAdapter(adapter);

        return v;
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (OnFragmentInteractionListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

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
            final Payee p = itemsArrayList.get(position);
            labelView.setText(p.getName() + " - $" + p.getAmount());
            buttonView.setText("Pay");
            buttonView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    try {
                        Intent venmoIntent = VenmoLibrary.openVenmoPayment("1965", "FoodMate", p.getId(), p.getAmount().toString(), "test", "charge");
                        startActivityForResult(venmoIntent, 1); //1 is the requestCode we are using for Venmo. Feel free to change this to another number.
                    }
                    catch (android.content.ActivityNotFoundException e) //Venmo native app not install on device, so let's instead open a mobile web version of Venmo in a WebView
                    {
                        Intent venmoIntent = new Intent(SplitCostFragment.this.getActivity(), VenmoWebViewActivity.class);
                        String venmo_uri = VenmoLibrary.openVenmoPaymentInWebView("1965", "FoodMate", p.getId(), p.getAmount().toString(), "test", "charge");
                        venmoIntent.putExtra("url", venmo_uri);
                        startActivityForResult(venmoIntent, 1);
                    }

                }
            });

            // 5. retrn rowView
            return rowView;
        }
    }
}
