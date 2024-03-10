//
//  ProfileVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 01/02/2024.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var fanEmail: UITextField!
    @IBOutlet weak var fanPassword: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var hidePasswordImageView: UIImageView!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uiSetUp()
        makeHidePasswordImageViewClickable()
        makeSignUpLabelClickable()
        
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let email = fanEmail.text, !email.isEmpty else {
            showAlert(title: "Email Required", message: "Please enter your email.")
            return
        }
        guard let password = fanPassword.text, !password.isEmpty else {
            showAlert(title: "Password Required", message: "Please enter your password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if error != nil{
                self.showAlert(title: "Error!", message: "The email or password is not correct")
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
                    profileVC.navigationItem.hidesBackButton = true
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
    }
}

extension SignInVC{
    func makeSignUpLabelClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func signUpLabelTapped() {
        let stepOneVC = StepOneVC(nibName: "StepOneVC", bundle: nil)
        navigationController?.pushViewController(stepOneVC, animated: true)
    }
}

extension SignInVC{
    func uiSetUp(){
        backgroundImageView.image = UIImage(named: "stad2")
        backgroundImageView.applyGradient(colors: [UIColor.white.withAlphaComponent(0), UIColor.white.withAlphaComponent(1)])
        signInButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
        
        fanEmail.layer.cornerRadius = 10.0
        fanEmail.layer.borderWidth = 1.0
        fanEmail.layer.borderColor = UIColor.lightGray.cgColor
        
        fanPassword.layer.cornerRadius = 10.0
        fanPassword.layer.borderWidth = 1.0
        fanPassword.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func makeHidePasswordImageViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        hidePasswordImageView.isUserInteractionEnabled = true
        hidePasswordImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func togglePasswordVisibility() {
        fanPassword.isSecureTextEntry.toggle()
        hidePasswordImageView.image = fanPassword.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
    }
}
