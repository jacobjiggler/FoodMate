//
//  ShoppingListViewController.swift
//  FoodMate
//
//  Created by Jordan Horwhich on 9/13/14.
//  Copyright (c) 2014 FoodMate. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    // Do any additional setup after loading the view.
    //currently hardcoded, needs to be global app variables:
    var my_name = "jordan"
    var my_objectID = "LYHZxx4KrL"
    
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
        query.whereKey("inStock", equalTo: false)
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
        let objId = foodData[indexPath.row].objectId
        var cell : HomeTableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as HomeTableViewCell
        var query = PFQuery(className:"Food_item")
        query.getObjectInBackgroundWithId(objId) {
        (item: PFObject!, error: NSError!) -> Void in
        if error == nil {
            }
        cell.foodLabel.text = item["name"] as? String
        cell.priceLabel.text = ("$" + String(format: "%.2f", item["price"].floatValue))
        }
        //var cell : HomeTableViewCell! = tableView.dequeueReusableCellWithIdentifier("GreenCell") as HomeTableViewCell
        
        if(cell == nil) {
        //    cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as UITableViewCell;
        cell = HomeTableViewCell()
        }
        
        return cell
    }
    
    
    @IBAction func CheckoutButtonClicked(sender: AnyObject) {
        print("Checkout!")
        var query : PFQuery = PFQuery(className: "User")
      //  query.whereKey("inStock", equalTo: false)
      //  query.whereKey(")
        var all_users:[AnyObject]! = []
        query.findObjectsInBackgroundWithBlock({(objects:[AnyObject]!, NSError error) in
            if (error != nil) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                all_users = objects
            }
            
        })
        /*
        all_receipts = []
        for person in all_people:
        first_line = "Hello " + person.nm + ", here's your receipt from FoodMate! \n"
        lines = []
        lines.append(first_line)
        r = Receipt(person.pn, lines)
        for item in person.fl:
        r.add_line(item.nm, item.pr/item.sh)
        all_receipts.append(r)
*/
    }
    /////////////////
    // New Item Stuff
    /////////////////
    /* @IBAction func manualAddButtonClicked(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil);
    let vc = storyboard.instantiateViewControllerWithIdentifier("manualItem") as ManualItemViewController;
    self.presentViewController(vc, animated: true, completion: nil);
    }
    
    @IBAction func cameraAddButtonClicked(sender: UIBarButtonItem) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil);
    let vc = storyboard.instantiateViewControllerWithIdentifier("scanItem") as ScanItemViewController;
    self.presentViewController(vc, animated: true, completion: nil);
    }
    */
}
