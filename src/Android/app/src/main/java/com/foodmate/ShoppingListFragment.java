package com.foodmate;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseRelation;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import java.util.ArrayList;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link ShoppingListFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class ShoppingListFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment ShoppingListFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static ShoppingListFragment newInstance(String param1, String param2) {
        ShoppingListFragment fragment = new ShoppingListFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }
    public ShoppingListFragment() {
        // Required empty public constructor
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
        View v = inflater.inflate(R.layout.fragment_shopping_list, container, false);

        generateShoppingList();

        final Button split = (Button)v.findViewById(R.id.split_cost_shop_button);
        split.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final ParseUser user = ParseUser.getCurrentUser();
                ParseQuery<ParseObject> groupQuery = ParseQuery.getQuery("Group");
                groupQuery.whereEqualTo("objectId", "T0WP5gBwTF");
                ParseObject group = null;

                try {
                    group = groupQuery.find().get(0);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

                ParseQuery<ParseUser> userQuery = new ParseQuery<ParseUser>("_User");
                userQuery.whereEqualTo("groupId", group);
                userQuery.findInBackground(new FindCallback<ParseUser>() {
                    @Override
                    public void done(List<ParseUser> parseUsers, ParseException e) {
                        ArrayList<Payee> payees = new ArrayList<Payee>();
                        Log.d("FoodMate", "IN SPLIT COST");
                        for (ParseUser u : parseUsers) {
                            Log.d("FoodMate", "PARSING USER " + u.getUsername());

                            float total = 0;
                            ParseRelation<ParseObject> wishlist = u.getRelation("wishlist");
                            ParseQuery<ParseObject> wishlistQuery = wishlist.getQuery();
                            List<ParseObject> foodItems = null;
                            try {
                                foodItems = wishlistQuery.find();
                            } catch (ParseException e1) {
                                e1.printStackTrace();
                            }

                            if (foodItems == null)
                                continue;

                            for (ParseObject food : foodItems) {
                                int sharedBy = food.getInt("shared_by");
                                if (sharedBy == 0)
                                    continue;

                                Log.d("FoodMate", "ADDING VALUE FOR " + food.get("name"));
                                total += food.getNumber("price").floatValue() / sharedBy;
                            }

                            if (total == 0 || u.getObjectId() == user.getObjectId())
                                continue;

                            //TODO Venmo ID?
                            Payee p = new Payee(u.getUsername(), u.getEmail(), total);
                            payees.add(p);
                        }

                        Log.d("FoodMate", "SETTING FRAGMENT");
                        SplitCostFragment splitCostFragment = new SplitCostFragment(payees);
                        getFragmentManager().beginTransaction().replace(R.id.container, splitCostFragment).commit();
                    }
                });
            }
        });

        return v;
    }

    private void generateShoppingList()
    {
        ParseUser user = ParseUser.getCurrentUser();
        final ParseObject group = (ParseObject)user.get("groupId");

        final ParseObject receipt = new ParseObject("Receipt");
        receipt.put("groupId", group);
        receipt.put("isShoppingList", true);

        receipt.saveEventually(new SaveCallback() {
            @Override
            public void done(ParseException e) {
                final ParseRelation<ParseObject> relation = receipt.getRelation("foodItems");

                ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("Food_item");
                query.whereEqualTo("groupId", group);
                query.findInBackground(new FindCallback<ParseObject>() {
                    @Override
                    public void done(List<ParseObject> parseObjects, ParseException e) {
                        for (ParseObject p : parseObjects) {
                            if (p.getInt("shared_by") != 0) {
                                relation.add(p);
                            }
                        }

                        try {
                            receipt.save();
                        } catch (ParseException e1) {
                            e1.printStackTrace();
                        }

                        receipt.getRelation("foodItems").getQuery().findInBackground(new FindCallback<ParseObject>() {
                            @Override
                            public void done(List<ParseObject> parseObjects, ParseException e) {
                                if (e != null) {
                                    Log.d("FoodMate", e.getMessage());
                                    return;
                                }

                                List<FoodItemWrapper> convertedList = new ArrayList<FoodItemWrapper>();
                                for (int i = 0; i < parseObjects.size(); i++) {
                                    convertedList.add(new FoodItemWrapper(parseObjects.get(i), true));
                                }

                                ListView v = (ListView) getActivity().findViewById(R.id.shopping_list);
                                ArrayAdapter<FoodItemWrapper> arrayAdapter = new ArrayAdapter<FoodItemWrapper>(v.getContext(), android.R.layout.simple_list_item_1, android.R.id.text1, convertedList);
                                v.setAdapter(arrayAdapter);
                            }
                        });
                    }
                });
            }
        });
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
