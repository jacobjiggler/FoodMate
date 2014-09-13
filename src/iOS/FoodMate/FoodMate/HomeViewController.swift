//
//  HomeViewController.swift
//  FoodMate
//
//  Created by Jordan Horwich on 9/13/14.
//  Copyright (c) 2014 FoodMate. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var stringArray = ["foo", "bar", "baz"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSectionsInTableView(tableView: UITableView) ->Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int
    {
        //make sure you use the relevant array sizes
        return stringArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : HomeTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as HomeTableViewCell
        if(cell == nil) {
            //cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as UITableViewCell;
            cell = HomeTableViewCell()
        }
        
        cell.foodLabel.text = stringArray[indexPath.row]
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
}
