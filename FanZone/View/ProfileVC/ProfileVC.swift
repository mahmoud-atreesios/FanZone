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
import RxSwift

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
    let firebaseViewModel = FireBaseViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUi()
        retriveCurrentFanData()
        bindProfileViewToViewModel()
        
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

// MARK: - retrieve fan data
extension ProfileVC{
    func retriveCurrentFanData(){
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID {
            firebaseViewModel.retriveCurrentFanData(userID: userID)
        }
    }
    
    func bindProfileViewToViewModel(){
        firebaseViewModel.loggedInFanData.subscribe(onNext: { fanData in
            if let fullname = fanData["fullname"],
                let fanImageURL = fanData["fanImageURL"] {
                
                // Split the full name into components
                let nameComponents = fullname.components(separatedBy: " ")
                if let firstName = nameComponents.first,
                   let lastName = nameComponents.last{
                    let firstLetterOfLastName = String(lastName.prefix(1)).uppercased()
                    let shortenedName = "\(firstName) \(firstLetterOfLastName)."
                    self.fanName.text = shortenedName
                }
                self.fanImageView.sd_setImage(with: URL(string: fanImageURL))
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - tabs clickable
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
    @objc func busTicketsViewTapped(){
        let busTicketsVC = BusTicketVC(nibName: "BusTicketVC", bundle: nil)
        navigationController?.pushViewController(busTicketsVC, animated: true)
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

// MARK: - intial setup
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
        let rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func signOutButtonTapped() {
        // Handle edit button tapped
        print("sign outtttttttttt")
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("User signed out successfully")
                if let tabBarController = self.tabBarController as? TabBar {
                    tabBarController.setupTabs()
                }
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
}
