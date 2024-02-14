//
//  ProfileVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 01/02/2024.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var fanIdTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uiSetUp()
    }
}

extension ProfileVC{
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
}
