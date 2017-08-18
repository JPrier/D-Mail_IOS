//
//  ViewController.swift
//  D-Mail


import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, popTableDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    //Mark: Properties
    
    //E2 and E1
    @IBOutlet weak var e1Switch: UISwitch!
    @IBOutlet weak var E2: UITextField!
    
    //text fields
    @IBOutlet weak var MRNtext: UITextField!
    @IBOutlet weak var Accttext: UITextField!
    @IBOutlet weak var notesText: UITextField!
    
    //table buttons and the selections
    @IBOutlet weak var conButton: UIButton!
    var conButtonTitle: String!
    //@IBOutlet weak var hosButton: UIButton!
    var conLevel: String?
    //var hosLevel: String?
    
    //settings
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        conLevel = nil
        //hosLevel = nil
        
        self.MRNtext.delegate = self
        self.Accttext.delegate = self
        self.E2.delegate = self
        
        conButtonTitle = conButton.title(for: .normal)
        
        //set settings if they haven't been set yet (first time opening only -- could be done better)
        if ((defaults.object(forKey: "isSet") == nil)){
            defaults.set("YES", forKey: "isSet")
            defaults.set("JoshKPrier@gmail.com", forKey: "toEmail")
        }
        
    }
    
    //Mark: Mail Action
    
    @IBAction func SendButton(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            //self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        var emailBody = ""
        
        func createAlert (message: String) {
            //create UIAlertController
            let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
            //Create Action to close the alert
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            //add the action to the alert
            alert.addAction(alertAction)
            //show the alert
            self.present(alert, animated: true, completion: nil)

        }
       
        if (conLevel == nil) && (MRNtext.text == "" && Accttext.text == "") {
            //show all alerts in one
            createAlert(message: "- No Care Level selected\n - MRN and Account number are both empty")
        
        }
            
        else if (MRNtext.text == "" && Accttext.text == "") {
            //show text field alerts
            createAlert(message: "MRN and Account number are both empty")
        }
        
        else if (conLevel == nil) {
            //show table selection alerts
            createAlert(message: "No Care Level selected")
            
        }
        
        else if conLevel == nil {
            //show alert with message if no consulation level was selected
            createAlert(message: "No Consulation Level selected")
        }
        
        else if MRNtext.text == "" {
            //show alert if MRNText is empty
            createAlert(message: "MRN is empty")
        }
        
        else if Accttext.text == "" {
            //show alert if AcctText is empty
            createAlert(message: "Account number is empty")
        }
        
        else if (defaults.object(forKey: "provider") as! String) == "" {
            //show alert if there is no provider set
            createAlert(message: "No provider in settings, go to settings and set the provider")
        }
 
        else {
            //set Body if no errors are shown
            let mrn = "MRN: " + MRNtext.text!
            let acct = "\nAccount Number: " + Accttext.text!
            let con = "\nCare Level: " + conLevel!
            //let hos = "\nHospital Care: " + hosLevel!
            
            var E1 = "false"
            if e1Switch.isSelected {
                E1 = "true"
            }
            let e = "\nE1: " + E1 + "\nE2: " + E2.text!
            let provider = "\nProvider: " + (defaults.object(forKey: "provider") as! String)
            
            let date1  = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let dateS = "\nDate: " + formatter.string(from: date1)
            
            emailBody = mrn + acct + con + e + provider + dateS
            
            if notesText.text != "" {
                emailBody += "\n" + notesText.text!
            }
            
        }
        
        
        mailComposerVC.setToRecipients([defaults.object(forKey: "toEmail") as! String])
        
        if (defaults.object(forKey: "CC") as! String) != "" {
            //add the CC's if there is one set
            mailComposerVC.setCcRecipients([defaults.object(forKey: "CC") as! String])
        }
        
        let subject = defaults.object(forKey: "subject") as? String
        
        if subject != "" && subject != nil {
            
            mailComposerVC.setSubject(subject!)
            
        } else {
            
            mailComposerVC.setSubject("")
        }

        mailComposerVC.setMessageBody(emailBody, isHTML: false)
        
        return mailComposerVC
    }
    
    //sends alerts when things go wrong with sending the email
    func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "Send mail error", message: "could not send email, check settings and try again", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) in let fields = alertController.textFields!;
            print("Yes we can: "+fields[0].text!);
        })
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
    }
    
    //Mark: MFMailComposeViewContollerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //Mark: Actions
    
    
    //sets delegates for the table views so that we can save the data in this class
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PopTableViewController {
            destination.delegate = self
        }
        /*if let destination = segue.destination as? HosTableViewController {
            destination.delegate = self
        }*/
    }
    
    //Gets the table selections
    func finishPassing(string: [String]) {
        
        if string[0] == "con" {
            conLevel = string[1]
            
            //changes the button name to that of the selection
            conButton.setTitle(conLevel, for: .normal)
        } else {
            //hosLevel = string[1]
            
            //changes the button name to that of the selection
            //hosButton.setTitle(hosLevel, for: .normal)
        }
    }
    
    @IBAction func refreshInfo(_ sender: UIBarButtonItem) {
        MRNtext.text = ""
        Accttext.text = ""
        conButton.setTitle(conButtonTitle, for: .normal)
        //hosButton.setTitle("Select Hospital Care Level", for: .normal)
        E2.text = ""
        conLevel = nil
        //hosLevel = nil
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


