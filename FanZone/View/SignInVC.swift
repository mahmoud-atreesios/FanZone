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
    
    var isSavingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uiSetUp()
        makeHidePasswordImageViewClickable()
        makeSignUpLabelClickable()
        hideKeyboardWhenTappedAround()
        LoaderManager.shared.setUpBallLoader(in: view)
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard !isSavingData else { return }
        signIn()
    }
}

extension SignInVC{
    func signIn(){
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.5
        view.addSubview(blurEffectView)

        LoaderManager.shared.showBallLoader()
        view.addSubview(LoaderManager.shared.ballLoader)

        isSavingData = true
        signInButton.isEnabled = false
        
        guard let email = fanEmail.text, !email.isEmpty else {
            LoaderManager.shared.hideBallLoader()
            blurEffectView.removeFromSuperview()
            self.isSavingData = false
            self.signInButton.isEnabled = true
            showAlert(title: "Email Required", message: "Please enter your email.")
            return
        }
        guard let password = fanPassword.text, !password.isEmpty else {
            LoaderManager.shared.hideBallLoader()
            blurEffectView.removeFromSuperview()
            self.isSavingData = false
            self.signInButton.isEnabled = true
            showAlert(title: "Password Required", message: "Please enter your password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if error != nil{
                LoaderManager.shared.hideBallLoader()
                blurEffectView.removeFromSuperview()
                self.isSavingData = false
                self.signInButton.isEnabled = true
                self.showAlert(title: "Error!", message: "The email or password is not correct")
            }else{
                if let tabBarController = self.tabBarController as? TabBar {
                    tabBarController.setupTabs()
                }
                self.signInButton.isEnabled = true
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

// MARK: - HIDE KEYBOARD
extension SignInVC{
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
