package com.foodmate;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseRelation;
import com.parse.ParseUser;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link FoodItemDetailFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class FoodItemDetailFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    private FoodItemWrapper selectedItem;

    private boolean inWishlist;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment FoodItemDetailFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static FoodItemDetailFragment newInstance(String param1, String param2) {
        FoodItemDetailFragment fragment = new FoodItemDetailFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }
    public FoodItemDetailFragment() {
        // Required empty public constructor
    }

    public FoodItemDetailFragment(FoodItemWrapper item) {
        this.selectedItem = item;
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
        View v = inflater.inflate(R.layout.fragment_food_item_detail, container, false);

        if (selectedItem == null)
            return v;

        TextView titleTv = (TextView)v.findViewById(R.id.food_detail_title);
        TextView priceTv = (TextView)v.findViewById(R.id.food_detail_price);
        TextView expDateTv = (TextView)v.findViewById(R.id.food_detail_expiration_date);
        TextView lastPurchasedDateTv = (TextView)v.findViewById(R.id.food_detail_last_purchased);
        TextView barcodeTv = (TextView)v.findViewById(R.id.food_detail_barcode);

        titleTv.setText(selectedItem.getObj().get("name").toString());
        priceTv.setText("$" + selectedItem.getObj().getNumber("price").toString());

        SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        Date lastPurchasedDate = selectedItem.getObj().getDate("lastPurchased");
        Calendar cal = Calendar.getInstance();
        cal.setTime(lastPurchasedDate);
        cal.add(Calendar.DATE, selectedItem.getObj().getInt("expiration"));

        expDateTv.setText(dateFormat.format(cal.getTime()));
        lastPurchasedDateTv.setText(dateFormat.format(lastPurchasedDate));

        barcodeTv.setText(selectedItem.getObj().get("barcode").toString());

        Button editPriceBtn = (Button)v.findViewById(R.id.food_detail_edit_button);
        editPriceBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //TODO do this
            }
        });

        final Button wishListBtn = (Button)v.findViewById(R.id.food_detail_wishlist_button);
        wishListBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (selectedItem == null)
                    return;

                Button btn = (Button)v;

                if (inWishlist) {
                    ParseUser user = ParseUser.getCurrentUser();
                    ParseRelation<ParseObject> wishlist = user.getRelation("wishlist");
                    wishlist.remove(selectedItem.getObj());
                    user.saveInBackground();

                    int num = selectedItem.getObj().getInt("shared_by");
                    selectedItem.getObj().put("shared_by", num - 1);
                    selectedItem.getObj().saveInBackground();

                    Toast.makeText(getActivity(), "Removed from wishlist", Toast.LENGTH_LONG).show();
                    inWishlist = false;
                    btn.setText(getString(R.string.food_detail_add));
                }
                else {
                    ParseUser user = ParseUser.getCurrentUser();
                    ParseRelation<ParseObject> wishlist = user.getRelation("wishlist");
                    wishlist.add(selectedItem.getObj());
                    user.saveInBackground();

                    selectedItem.getObj().increment("shared_by");
                    selectedItem.getObj().saveInBackground();

                    Toast.makeText(getActivity(), "Added to wishlist", Toast.LENGTH_LONG).show();
                    inWishlist = true;
                    btn.setText(getString(R.string.food_detail_remove));
                }
            }
        });

        ParseUser user = ParseUser.getCurrentUser();
        ParseRelation<ParseObject> wishlist = user.getRelation("wishlist");
        wishlist.getQuery().whereEqualTo("objectId", selectedItem.getObj().getObjectId()).findInBackground(new FindCallback<ParseObject>() {
            @Override
            public void done(List<ParseObject> parseObjects, ParseException e) {
                if (e != null) {
                    Log.d("FoodMate", e.getMessage());
                    return;
                }
                if (parseObjects.size() == 0)
                    return;

                wishListBtn.setText(getString(R.string.food_detail_remove));
                inWishlist = true;
            }
        });

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

}
