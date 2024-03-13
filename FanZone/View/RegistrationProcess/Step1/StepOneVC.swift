//
//  StepOneVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/03/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class StepOneVC: UIViewController {
    
    @IBOutlet weak var fanEmail: UITextField!
    @IBOutlet weak var fanPassword: UITextField!
    @IBOutlet weak var fanConfirmPassword: UITextField!
    
    @IBOutlet weak var hidePassword: UIImageView!
    @IBOutlet weak var hideConfirmPassword: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        makeHideConfirmPasswordImageViewClickable()
        makeHidePasswordImageViewClickable()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard let email = fanEmail.text, !email.isEmpty else {
            showAlert(title: "Email Required", message: "Please enter your email.")
            return
        }
        guard let password = fanPassword.text, !password.isEmpty else {
            showAlert(title: "Password Required", message: "Please enter your password.")
            return
        }
        guard let confirmPassword = fanConfirmPassword.text, !confirmPassword.isEmpty else {
            showAlert(title: "Confirm Password Required", message: "Please confirm your password.")
            return
        }
        
        if fanPassword.text == fanConfirmPassword.text{
            if let fanEmail = fanEmail.text , let fanPassword = fanPassword.text{
                Auth.auth().createUser(withEmail: fanEmail, password: fanPassword) { authResult, error in
                    if let e = error{
                        self.showAlert(title: "Error!", message: "\(e.localizedDescription)")
                    }else {
                        let stepTwoVC = StepTwoVC(nibName: "StepTwoVC", bundle: nil)
                        self.navigationController?.pushViewController(stepTwoVC, animated: true)
                    }
                }
            }
        }else {
            showAlert(title: "Error!", message: "Password and Confirm Password doesn't Match")
        }
        
    }
}

extension StepOneVC{
    func makeHideConfirmPasswordImageViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleePasswordVisibility))
        hideConfirmPassword.isUserInteractionEnabled = true
        hideConfirmPassword.addGestureRecognizer(tapGesture)
    }
    
    @objc func toggleePasswordVisibility() {
        fanConfirmPassword.isSecureTextEntry.toggle()
        hideConfirmPassword.image = fanConfirmPassword.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
    }
    
    func makeHidePasswordImageViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        hidePassword.isUserInteractionEnabled = true
        hidePassword.addGestureRecognizer(tapGesture)
    }
    
    @objc func togglePasswordVisibility() {
        fanPassword.isSecureTextEntry.toggle()
        hidePassword.image = fanPassword.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
    }
}

extension StepOneVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

extension StepOneVC{
    func setUp(){
        nextButton.tintColor = UIColor(red: 87/255, green: 149/255, blue: 154/255, alpha: 1.0)
        nextButton.layer.cornerRadius = 10
        nextButton.layer.masksToBounds = true
    }
}

// MARK: HIDE KEYBOARD
extension StepOneVC{
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddMemberVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
