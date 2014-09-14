//
//  SettingsViewController.swift
//  FoodMate
//
//  Created by Jordan Horwich on 9/14/14.
//  Copyright (c) 2014 FoodMate. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
        //sender.resignFirstResponder()
    }
    
    @IBAction func nextButtonPressed(sender: UITextField) {
        var next_responder = sender.superview?.viewWithTag(sender.tag + 1)
        if next_responder != nil {
            next_responder?.becomeFirstResponder()
        } else {
            sender.resignFirstResponder()
        }
    }
    
    @IBAction func groupNameChanged(sender: AnyObject) {
//        var query : PFQuery = PFQuery(className: "Group")
//        query.whereKey("name", equalTo: groupNameTextField.text)
//        
//        var tb = self.tabBarController?.tabBar as MainTabBar
//        tb.objId = query.getFirstObject().objectId
    }
    
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

}
