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
    @IBOutlet weak var transportationView: UIView!
    @IBOutlet weak var familyManagmentView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var contactUsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUi()
        makeContactUsViewClickable()
        makeTransportationViewClickable()
    }
}

extension ProfileVC{
    func makeContactUsViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contactUsViewTapped))
        contactUsView.addGestureRecognizer(tapGesture)
    }
    @objc func contactUsViewTapped(){
        let contactUsVC = ContactUsVC(nibName: "ContactUsVC", bundle: nil)
        present(contactUsVC, animated: true, completion: nil)
    }
    
    func makeTransportationViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TransportationViewTapped))
        transportationView.addGestureRecognizer(tapGesture)
    }
    @objc func TransportationViewTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transportationVC = storyboard.instantiateViewController(withIdentifier: "TransportationVC") as? TransportationVC {
            navigationController?.pushViewController(transportationVC, animated: true)
        }
    }

}

extension ProfileVC{
    func setUpUi(){
        fanImageView.makeRounded()
        matchTicketsView.layer.cornerRadius = 10
        matchTicketsView.layer.masksToBounds = true
        transportationView.layer.cornerRadius = 10
        transportationView.layer.masksToBounds = true
        familyManagmentView.layer.cornerRadius = 10
        familyManagmentView.layer.masksToBounds = true
        settingsView.layer.cornerRadius = 10
        settingsView.layer.masksToBounds = true
        contactUsView.layer.cornerRadius = 10
        contactUsView.layer.masksToBounds = true
    }
}
