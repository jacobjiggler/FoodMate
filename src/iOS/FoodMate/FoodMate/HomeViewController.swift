//
//  HomeViewController.swift
//  FoodMate
//
//  Created by Jordan Horwich on 9/13/14.
//  Copyright (c) 2014 FoodMate. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stringArray = ["foo", "bar", "baz"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    //////////////
    // Table Stuff
    //////////////
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
    
    /////////////////
    // New Item Stuff
    /////////////////
    @IBAction func manualAddButtonClicked(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("manualItem") as ManualItemViewController;
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func cameraAddButtonClicked(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("scanItem") as ScanItemViewController;
        self.presentViewController(vc, animated: true, completion: nil);
    }
    
}
