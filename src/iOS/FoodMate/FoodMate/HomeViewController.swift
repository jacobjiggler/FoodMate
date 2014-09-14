//
//  HomeViewController.swift
//  FoodMate
//
//  Created by Jordan Horwich on 9/13/14.
//  Copyright (c) 2014 FoodMate. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var foodData:[AnyObject]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var query : PFQuery = PFQuery(className: "Food_item")
        query.findObjectsInBackgroundWithBlock({(objects:[AnyObject]!, NSError error) in
            if (error != nil) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                self.foodData = objects
                self.tableView.reloadData()
            }
        })
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
        return foodData.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : HomeTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as HomeTableViewCell
        if(cell == nil) {
            //cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as UITableViewCell;
            cell = HomeTableViewCell()
        }
        
        let objId = foodData[indexPath.row].objectId
        var query = PFQuery(className:"Food_item")
        query.getObjectInBackgroundWithId(objId) {
            (item: PFObject!, error: NSError!) -> Void in
            if error == nil {
                cell.foodLabel.text = item["name"] as? String
                cell.priceLabel.text = ("$" + String(format: "%.2f", item["price"].floatValue))
            }
        }
        
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
