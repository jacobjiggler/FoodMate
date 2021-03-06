package com.foodmate;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseRelation;
import com.parse.ParseUser;

import java.util.ArrayList;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link PantryFragment#newInstance} factory method to
 * create an instance of this fragment.
 *
 */
public class PantryFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private FoodItemWrapper longPressedItem;

    private OnFragmentInteractionListener mListener;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment PantryFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static PantryFragment newInstance(String param1, String param2) {
        PantryFragment fragment = new PantryFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }
    public PantryFragment() {
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

        final ListView lv = (ListView)inflater.inflate(R.layout.fragment_pantry, container, false);

        ParseQuery<ParseObject> groupQuery = ParseQuery.getQuery("Group");
        groupQuery.whereEqualTo("objectId", "T0WP5gBwTF");

        groupQuery.findInBackground(new FindCallback<ParseObject>() {
            @Override
            public void done(List<ParseObject> parseObjects, ParseException e) {
                if (e != null) {
                    Log.d("FoodMate", e.getMessage());
                    return;
                }

                ParseObject userGroup = null;

                if (parseObjects.size() > 0)
                    userGroup = parseObjects.get(0);
                else
                    return;

                ParseQuery<ParseObject> query = ParseQuery.getQuery("Food_item");
                query.whereEqualTo("groupId", userGroup);
                query.findInBackground(new FindCallback<ParseObject>() {
                    @Override
                    public void done(List<ParseObject> parseObjects, ParseException e) {
                        if (e != null) {
                            Log.d("FoodMate", e.getMessage());
                            return;
                        }

                        List<FoodItemWrapper> convertedList = new ArrayList<FoodItemWrapper>();
                        for (int i = 0; i < parseObjects.size(); i++) {
                            convertedList.add(new FoodItemWrapper(parseObjects.get(i)));
                        }

                        ArrayAdapter<FoodItemWrapper> arrayAdapter = new ArrayAdapter<FoodItemWrapper>(lv.getContext(), android.R.layout.simple_list_item_1, android.R.id.text1, convertedList);
                        lv.setAdapter(arrayAdapter);
                    }
                });
            }
        });

        registerForContextMenu(lv);

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                FoodItemWrapper item = (FoodItemWrapper)parent.getItemAtPosition(position);
                FoodItemDetailFragment detailFragment = new FoodItemDetailFragment(item);
                getFragmentManager().beginTransaction().replace(R.id.container, detailFragment).commit();
                //view.showContextMenu();
                /*ListView clv = new ListView();*/
            }
        });

        return lv;
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
        super.onCreateContextMenu(menu, v, menuInfo);
        ListView list = (ListView)v;
        AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo)menuInfo;
        int position = info.position;

        longPressedItem = (FoodItemWrapper)list.getItemAtPosition(position);

        menu.setHeaderTitle("Action");
        menu.add(0, v.getId(), 0, "Add to Wishlilst");
        menu.add(0, v.getId(), 1, "Cancel");
    }

    @Override
    public boolean onContextItemSelected(MenuItem item) {
        if (item.getOrder() == 0) {
            if (longPressedItem != null) {
                ParseUser user = ParseUser.getCurrentUser();
                ParseRelation<ParseObject> wishlist = user.getRelation("wishlist");
                wishlist.add(longPressedItem.getObj());
                user.saveInBackground();

                longPressedItem.getObj().increment("shared_by");
                longPressedItem.getObj().saveInBackground();

                Toast.makeText(this.getActivity(), "Added to wishlist", Toast.LENGTH_LONG).show();
            }
        }
        else if (item.getOrder() == 1) {

        }

        return false;
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
