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

    /////////////////////
    // Button Bar Actions
    /////////////////////
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        // send Parse requests here and then reload the table
        var newItem = PFObject(className: "Food_item")
        newItem["name"] = self.itemNameTextField.text
        newItem["price"] = (self.itemPriceTextField.text as NSString).floatValue
        if (self.barCodeTextField.text != "") {
            newItem["barcode"] = self.barCodeTextField.text
        }
        if (self.daysToExpireTextField.text != "") {
            newItem["expiration"] = self.daysToExpireTextField.text.toInt()
        }
        newItem.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
