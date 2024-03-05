//
//  StepOneVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/03/2024.
//

import UIKit

class StepOneVC: UIViewController {
    
    
    @IBOutlet weak var fanEmail: UITextField!
    @IBOutlet weak var fanPassword: UITextField!
    @IBOutlet weak var fanConfirmPassword: UITextField!
    
    @IBOutlet weak var hidePassword: UIImageView!
    @IBOutlet weak var hideConfirmPassword: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
    }
    
}
