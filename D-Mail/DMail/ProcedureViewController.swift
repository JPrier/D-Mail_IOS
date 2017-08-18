//
//  ProcedureViewController.swift
//  D-Mail
//
//  Created by Lauren Cataldo on 7/31/17.
//  Copyright © 2017 Prier. All rights reserved.
//

import UIKit
import MessageUI

class ProcedureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    //text fields
    @IBOutlet weak var mrnText: UITextField!
    @IBOutlet weak var acctText: UITextField!
    @IBOutlet weak var notesText: UITextField!
    
    //photo items
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIImageView!
    
    //settings
    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //immediately opens camera
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    //changes the view to be a preview of the added photo (gives confirmation that it worked for the user)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        //opens camera and takes photo
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
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
        
        var emailBody = ""
        var provider = ""
        
        if (defaults.object(forKey: "provider") as! String) == "" {
            //show alert if there is no provider set
            createAlert(message: "No provider in settings, go to settings and set the provider")
        } else {
            provider = "Provider: " + (defaults.object(forKey: "provider") as! String) + "\n"
        }
        
        if mrnText.text != "" {
            emailBody += "MRN: " + mrnText.text! + "\n"
            
        } else {
            createAlert(message: "MRN is Empty")
        }
        
        if acctText.text != "" {
            emailBody += "Account Number: " + acctText.text! + "\n"
            
        } else {
            createAlert(message: "Account Number is Empty")
        }
        
        if notesText.text != "" {
            emailBody += notesText.text! + "\n"
        }
        
        let date1  = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateS = "Date: " + formatter.string(from: date1)
        
        emailBody += provider + dateS
        
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
            createAlert(message: "No Subject in settings")
        }
        
        mailComposerVC.setMessageBody(emailBody, isHTML: false)
        
        if let image =  imageView.image {
            let data = UIImageJPEGRepresentation(image, 1)
            mailComposerVC.addAttachmentData(data!, mimeType: "image/jpeg", fileName: "image.jpeg")
        }
        
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
