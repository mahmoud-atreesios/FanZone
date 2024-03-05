//
//  StepTwoVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/03/2024.
//

import UIKit
import iOSDropDown

class StepTwoVC: UIViewController {
    
    
    @IBOutlet weak var fanImage: UIImageView!
    @IBOutlet weak var fanFullName: UITextField!
    @IBOutlet weak var fanPhoneNumber: UITextField!
    
    @IBOutlet weak var fanGender: DropDown!
    @IBOutlet weak var fanSupportedTeam: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
    }
    
}
