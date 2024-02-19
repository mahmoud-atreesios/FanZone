//
//  ProfileVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 19/02/2024.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var fanImageView: UIImageView!
    @IBOutlet weak var fanName: UILabel!
    
    @IBOutlet weak var matchTicketsView: UIView!
    @IBOutlet weak var busTicketsView: UIView!
    @IBOutlet weak var familyManagmentView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var contactUsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fanImageView.makeRounded()
        
        matchTicketsView.layer.cornerRadius = 10
        matchTicketsView.layer.masksToBounds = true
        busTicketsView.layer.cornerRadius = 10
        busTicketsView.layer.masksToBounds = true
        familyManagmentView.layer.cornerRadius = 10
        familyManagmentView.layer.masksToBounds = true
        settingsView.layer.cornerRadius = 10
        settingsView.layer.masksToBounds = true
        contactUsView.layer.cornerRadius = 10
        contactUsView.layer.masksToBounds = true
        
    }
}
