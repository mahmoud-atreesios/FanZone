//
//  ProfileVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 01/02/2024.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var fanIdTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
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
        print("Button pressed")
        let RegisterationDoneVC = RegisterationDoneVC(nibName: "RegisterationDoneVC", bundle: nil)
        navigationController?.pushViewController(RegisterationDoneVC, animated: true)
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
        
        fanIdTxtField.layer.cornerRadius = 10.0
        fanIdTxtField.layer.borderWidth = 1.0
        fanIdTxtField.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordTxtField.layer.cornerRadius = 10.0
        passwordTxtField.layer.borderWidth = 1.0
        passwordTxtField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func makeHidePasswordImageViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        hidePasswordImageView.isUserInteractionEnabled = true
        hidePasswordImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func togglePasswordVisibility() {
        passwordTxtField.isSecureTextEntry.toggle()
        hidePasswordImageView.image = passwordTxtField.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
    }
}
