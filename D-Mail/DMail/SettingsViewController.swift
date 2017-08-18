//
//  SettingsViewController.swift
//  D-Mail
//
// Created by Josh Prier on 7/20/17.
//  Copyright © 2017 Prier. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var toEmailText: UITextField!
    @IBOutlet weak var providerText: UITextField!
    @IBOutlet weak var CCtext: UITextField!
    @IBOutlet weak var subjectText: UITextField!
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toEmailText.text = defaults.object(forKey: "toEmail") as? String
        providerText.text = defaults.object(forKey: "provider") as? String
        CCtext.text = defaults.object(forKey: "CC") as? String
        subjectText.text = defaults.object(forKey: "subject") as? String
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsViewController.back(sender: )))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    func back(sender: UIBarButtonItem) {
        
        let toEmail = defaults.object(forKey: "toEmail") as? String
        
        if (toEmailText.text != nil && toEmailText.text != toEmail) {
            defaults.set(toEmailText.text, forKey: "toEmail")
        }
        
        let provider = defaults.object(forKey: "provider") as? String
        
        if (providerText.text != nil && providerText.text != provider) {
            defaults.set(providerText.text, forKey: "provider")
        }
        
        let CC = defaults.object(forKey: "CC") as? String
        
        if(CCtext.text != nil && CCtext.text != CC) {
            defaults.set(CCtext.text, forKey: "CC")
        }
        
        let subject = defaults.object(forKey: "subject") as? String
        
        if(subjectText.text != nil && subjectText.text != subject) {
            defaults.set(subjectText.text, forKey: "subject")
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    //dismisses the keyboard if touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //dismisses the keyboard when hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }


}
