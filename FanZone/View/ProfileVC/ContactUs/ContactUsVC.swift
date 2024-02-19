//
//  ContactUsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 19/02/2024.
//

import UIKit
import MessageUI

class ContactUsVC: UIViewController {
    
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUi()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let email = emailAddressTextField.text, !email.isEmpty else {
            showAlert(title: "Email Required", message: "Please enter your email address.")
            return
        }
        
        guard let message = messageTextView.text, !message.isEmpty else {
            showAlert(title: "Message Required", message: "Please enter your message.")
            return
        }
        
        // All fields are valid, compose and send the email
        sendEmail(email: email, message: message)
    }
}

extension ContactUsVC: MFMailComposeViewControllerDelegate{
    func sendEmail(email: String, message: String) {
        // Configure the email
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["tazkarti5@gmail.com"])
            mail.setSubject("Contact Us")
            mail.setMessageBody("From: \(email)\n\n\(message)", isHTML: false)
            present(mail, animated: true, completion: nil)
            
        } else {
            showAlert(title: "Email Not Configured", message: "Please configure your email in the device settings to send email.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                self.showAlert(title: "Email has been submitted", message: "We will respond as soon as possible")
                self.emailAddressTextField.text = ""
                self.messageTextView.text = "Message!"
            }
        }
    }
}

extension ContactUsVC{
    func setUpUi(){
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.cornerRadius = 5.0
        messageTextView.layer.masksToBounds = true
        
        emailAddressTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailAddressTextField.layer.borderWidth = 1
        emailAddressTextField.layer.cornerRadius = 5.0
        emailAddressTextField.layer.masksToBounds = true
    }
}

extension ContactUsVC {
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(ContactUsVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
