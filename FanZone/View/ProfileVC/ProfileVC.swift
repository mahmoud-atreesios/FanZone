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
    
    @IBOutlet weak var transportationView: UIView!
    @IBOutlet weak var familyManagmentView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var contactUsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUi()
        makeContactUsViewClickable()
        makeBusTicketsViewClickable()
        makeBookTransportationViewClickable()
        makeFamilyManagmentViewClickable()
    }
}

extension ProfileVC{
    
    //2 bus tickets
    func makeBusTicketsViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(busTicketsViewTapped))
        busTicketsView.addGestureRecognizer(tapGesture)
    }
    @objc func busTicketsViewTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let busTicketsVC = storyboard.instantiateViewController(withIdentifier: "BusTicketsVC") as? BusTicketsVC {
            navigationController?.pushViewController(busTicketsVC, animated: true)
        }
    }
    
    //3 book transportation
    func makeBookTransportationViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bookTransportationViewTapped))
        transportationView.addGestureRecognizer(tapGesture)
    }
    
    @objc func bookTransportationViewTapped(){
        let BookBusVC = BookBusVC(nibName: "BookBusVC", bundle: nil)
        navigationController?.pushViewController(BookBusVC, animated: true)
    }
    
    //4 family managment
    func makeFamilyManagmentViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(familyManagmentViewTapped))
        familyManagmentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func familyManagmentViewTapped(){
        let FamilyMembersVC = FamilyMembersVC(nibName: "FamilyMembersVC", bundle: nil)
        navigationController?.pushViewController(FamilyMembersVC, animated: true)
    }
    
    //6 contact us
    func makeContactUsViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contactUsViewTapped))
        contactUsView.addGestureRecognizer(tapGesture)
    }
    @objc func contactUsViewTapped(){
        let contactUsVC = ContactUsVC(nibName: "ContactUsVC", bundle: nil)
        present(contactUsVC, animated: true, completion: nil)
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
