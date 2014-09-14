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
    class Person {
        //name, phone #, food list
        var name: String?
        var phone: String?
        var food_list: [Food] = []
    }
    
    class Food {
        var name: String?
        var price: Float?
        var shared_by: Float?
    }
    
    class Receipt
    {
        var all_lines:[String] = []
        var recipient: String?
        var total: Float = 0
        func add_line(name: String, price: Float){
            self.all_lines.append(name + " : $ " + "\(price)" + "\n")
            self.total+=price
        }
    }
    
    @IBAction func CheckoutButtonClicked(sender: AnyObject) {
        print("Checkout! \n")
        var all_people: [Person] = []
        
        //hard coded data stuff, replace with database
        var malk = Food()
        malk.name = "malk"
        malk.price = 2
        var bred = Food()
        bred.name = "bred"
        bred.price = 4
        var food_jl : [Food] = [malk, bred]
        var jazmine = Person()
        jazmine.name = "Jazmine"
        jazmine.phone = "8134282970"
        jazmine.food_list = food_jl
        all_people.append(jazmine)
        var all_receipts: [Receipt] = []
        
        //get shared_by counts
        var occurred_food = ""
        for person in all_people
        {
            var current : Person = person
            for food_item in current.food_list
            {
                var current_name:String = food_item.name!
                if occurred_food.rangeOfString(current_name) != nil{
                        food_item.shared_by = food_item.shared_by! + 1
                }
                else{
                        food_item.shared_by = 1
                }
            }
        }
        for person in all_people
        {
            var first_line = "Hello " + person.name! + ", here's your receipt from FoodMate! \n"
            var lines : [String] = []
            lines.append(first_line)
            var r = Receipt()
            r.all_lines = lines
            r.recipient = person.phone
            for food in person.food_list
            {
                var food_price = food.price!
                var food_shared = food.shared_by!
                var cost = food_price / food_shared
                var food_name = food.name!
                r.add_line(food_name, price: cost)
            }
            r.all_lines.append("Total: $" + "\(r.total)" + "\n")
            all_receipts.append(r)
            
        }
            //twilio output
            for r in all_receipts
            {
                var output = ""
                print("send text to : " + r.recipient! + "\n")
                for line in r.all_lines
                {
                    output = output + line
                }
                print(output)
            }
        
        
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