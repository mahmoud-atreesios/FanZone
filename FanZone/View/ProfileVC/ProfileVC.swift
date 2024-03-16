//
//  ProfileVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 19/02/2024.
//

import UIKit
import SDWebImage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var fanImageView: UIImageView!
    @IBOutlet weak var fanName: UILabel!
    
    @IBOutlet weak var matchTicketsView: UIView!
    @IBOutlet weak var busTicketsView: UIView!
    
    @IBOutlet weak var transportationView: UIView!
    @IBOutlet weak var familyManagmentView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var contactUsView: UIView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUi()
        retriveCurrentFanData()
        
        makeMatchTicketsViewClickable()
        makeBusTicketsViewClickable()
        makeBookTransportationViewClickable()
        makeFamilyManagmentViewClickable()
        makeContactUsViewClickable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

extension ProfileVC{
    func retriveCurrentFanData(){
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID {
            db.collection("Fan").document(userID).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    if let fullname = data?["fullname"] as? String,
                       let phoneNumber = data?["phoneNumber"] as? String,
                       let gender = data?["gender"] as? String,
                       let supportedTeam = data?["supportedTeam"] as? String,
                       let fanImageURL = data?["fanImageURL"] as? String {
                        // Use the retrieved data
                        print("Fullname: \(fullname), Phone Number: \(phoneNumber), Gender: \(gender), Supported Team: \(supportedTeam), Fan Image URL: \(fanImageURL)")
                        
                        // Split the full name into components
                        let nameComponents = fullname.components(separatedBy: " ")
                        if let firstName = nameComponents.first,
                           let lastName = nameComponents.last {
                            // Get the first letter of the last name
                            let firstLetterOfLastName = String(lastName.prefix(1)).uppercased()
                            
                            let shortenedName = "\(firstName) \(firstLetterOfLastName)."
                            self.fanName.text = shortenedName
                            
                            // Inside your code where you want to load the image
                            if let fanImageURL = data?["fanImageURL"] as? String {
                                self.fanImageView.sd_setImage(with: URL(string: fanImageURL), placeholderImage: UIImage(systemName: "square.and.arrow.up.on.square.fill"))
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
}

extension ProfileVC{
    
    //1 match Tickets
    func makeMatchTicketsViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(matchTicketsViewTapped))
        matchTicketsView.addGestureRecognizer(tapGesture)
    }
    @objc func matchTicketsViewTapped(){
        let matchTicketsVC = MatchTicketsVC(nibName: "MatchTicketsVC", bundle: nil)
        navigationController?.pushViewController(matchTicketsVC, animated: true)
    }
    
    
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
