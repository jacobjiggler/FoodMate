//
//  ManualItemViewController.swift
//  FoodMate
//
//  Created by Jordan Horwich on 9/13/14.
//  Copyright (c) 2014 FoodMate. All rights reserved.
//

import UIKit

class ManualItemViewController: UIViewController {
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemPriceTextField: UITextField!

    @IBOutlet weak var barCodeTextField: UITextField!
    
    @IBOutlet weak var daysToExpireTextField: UITextField!
    
    var itemBarcode: String = ""
    var itemName: String = ""
    
    
    var parentView:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        barCodeTextField.text = itemBarcode
        var query : PFQuery = PFQuery(className: "Food_item")
        query.whereKey("barcode", equalTo: itemBarcode)
        query.findObjectsInBackgroundWithBlock({(objects:[AnyObject]!, NSError error) in
            if (error != nil) {
                NSLog("error " + error.localizedDescription)
            }
            else {
                print(objects)
                if objects.count > 0 {
                    var objQuery : PFQuery = PFQuery(className: "Food_item")
                    objQuery.getObjectInBackgroundWithId(objects[0].objectId) {
                        (item: PFObject!, error: NSError!) -> Void in
                        self.itemNameTextField.text = item["name"] as String
                        self.itemPriceTextField.text = String(format: "%.2f", item["price"].floatValue)
                        if item["expiration"] != nil {
                            self.daysToExpireTextField.text = String(item["expiration"] as Int)
                        }
                    }
                }
                //                self.foodData = objects
                //                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initwithBarcode(barcode: String) {
        itemBarcode = barcode
    }
    
    override func viewDidDisappear(animated: Bool) {
        //parentView.dismissViewControllerAnimated(false, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    /////////////////////
    // Button Bar Actions
    /////////////////////
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        // send Parse requests here and then reload the table
        
    }
    
    @IBAction func removeButtonClicked(sender: AnyObject) {
        var query = PFQuery(className: "Food_item")
        query.whereKey("name", equalTo: itemNameTextField.text)
        var item = query.getFirstObject()
        if item == nil {
            var newItem = PFObject(className: "Food_item")
            newItem["name"] = self.itemNameTextField.text
            newItem["price"] = (self.itemPriceTextField.text as NSString).floatValue
            if (self.barCodeTextField.text != "") {
                newItem["barcode"] = self.barCodeTextField.text
            }
            if (self.daysToExpireTextField.text != "") {
                newItem["expiration"] = self.daysToExpireTextField.text.toInt()
            }
            newItem["inStock"] = false
            newItem.saveInBackground()
        } else {
            item["price"] = (self.itemPriceTextField.text as NSString).floatValue
            if (self.barCodeTextField.text != "") {
                item["barcode"] = self.barCodeTextField.text
            }
            if (self.daysToExpireTextField.text != "") {
                item["expiration"] = self.daysToExpireTextField.text.toInt()
            }
            item["inStock"] = false
            item.saveInBackground()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addButtonClicked(sender: AnyObject) {
//        var foobar = PFQuery(className: "_User")
//        foobar.whereKey("username", equalTo: "jordan")
//        foobar.findObjectsInBackgroundWithBlock({(objects:[AnyObject]!, NSError error) in
//            if (error != nil) {
//                NSLog("error " + error.localizedDescription)
//            }
//            else {
//                print("################")
//                print(objects)
//            }
//        })
//        
//        
//        
        var codedObjId = PFQuery(className: "Group").getFirstObject()
        
        var query = PFQuery(className: "Food_item")
        query.whereKey("name", equalTo: itemNameTextField.text)
        var item = query.getFirstObject()

        if item == nil {
            var newItem = PFObject(className: "Food_item")
            newItem["name"] = self.itemNameTextField.text
            newItem["price"] = (self.itemPriceTextField.text as NSString).floatValue
            if !self.barCodeTextField.text.isEmpty {
                newItem["barcode"] = self.barCodeTextField.text
            }
            if !self.daysToExpireTextField.text.isEmpty {
                newItem["expiration"] = self.daysToExpireTextField.text.toInt()
            }
            newItem["inStock"] = true
            newItem["groupId"] = codedObjId
            newItem.saveInBackground()
        } else {
            item["price"] = (self.itemPriceTextField.text as NSString).floatValue
            if (self.barCodeTextField.text != "") {
                item["barcode"] = self.barCodeTextField.text
            }
            if (self.daysToExpireTextField.text != "") {
                item["expiration"] = self.daysToExpireTextField.text.toInt()
            }
            item["inStock"] = true
            item["groupId"] = codedObjId
            item.saveInBackground()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
