//
//  BookBusVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/02/2024.
//

import UIKit
import iOSDropDown
import Firebase

class BookBusVC: UIViewController {
    
    @IBOutlet weak var showTripsButton: UIButton!
    
    @IBOutlet weak var busStationDropList: DropDown!
    @IBOutlet weak var stadiumDestinationDropList: DropDown!
    @IBOutlet weak var numberOfSeatsDropList: DropDown!
    
    var selectedBusStation: String?
    var selectedStadiumDestination: String?
    var selectedNumberOfSeats: String?
    var selectedTicketTo: String?
    
    private let db = Firestore.firestore()
    var availableTrips: [[String: Any]] = []
    var members: [[String: Any]] = []
    var stationNames: [String] = []
    var destinationNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        fetchFamilyMembers()
        fetchAvailableTripsData()
    }
    
    @IBAction func showTripsButtonPressed(_ sender: UIButton) {
        guard let station = busStationDropList.text, !station.isEmpty else {
            showAlert(title: "Station Required", message: "Please select bus station.")
            return
        }
        
        guard let stadium = stadiumDestinationDropList.text, !stadium.isEmpty else {
            showAlert(title: "Stadium Required", message: "Please select the stadium destination.")
            return
        }
        
        guard let numberOfSeats = numberOfSeatsDropList.text, !numberOfSeats.isEmpty else {
            showAlert(title: "Number os seats Required", message: "Please select number of seats.")
            return
        }
        
        let tripsVC = TripsVC(nibName: "TripsVC", bundle: nil)
        tripsVC.selectedBusStation = selectedBusStation
        tripsVC.selectedStadiumDestination = selectedStadiumDestination
        tripsVC.selectedTicketTo = selectedTicketTo
        //tripsVC.selectedNumberOfSeats = selectedNumberOfSeats
        navigationController?.pushViewController(tripsVC, animated: true)
    }
}

extension BookBusVC{
    func setUpStationDropList(){
        busStationDropList.isSearchEnable = false
        busStationDropList.optionArray = stationNames
        busStationDropList.itemsTintColor = .black
        
        busStationDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedBusStation = selectedText
        }
    }
    
    func setUpStadiumDropList(){
        stadiumDestinationDropList.isSearchEnable = false
        stadiumDestinationDropList.optionArray = destinationNames
        stadiumDestinationDropList.itemsTintColor = .black
        
        stadiumDestinationDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedStadiumDestination = selectedText
        }
    }
    
    func setUpNumberOfSeatsDropDown(){
        numberOfSeatsDropList.isSearchEnable = false
        numberOfSeatsDropList.placeholder = "Ticket To"
        numberOfSeatsDropList.optionArray = ["Myself"] + members.compactMap { $0["depName"] as? String }
        numberOfSeatsDropList.itemsTintColor = .black
        
        // The Closure returns Selected Index and String
        numberOfSeatsDropList.didSelect{(selectedText , index ,id) in
            if index > 0 {
                let depId = self.members[index - 1]["depID"] as? String ?? ""
                print("Selected DepId for \(selectedText) is \(depId)")
                self.selectedTicketTo = depId
            }else{
                if let userID = Auth.auth().currentUser?.uid{
                    print("Selected DepId for \(selectedText) is \(userID)")
                    self.selectedTicketTo = userID
                }
            }
        }
    }
}

extension BookBusVC{
    func fetchFamilyMembers(){
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID {
            db.collection("Family_Members")
                .whereField("userID", isEqualTo: userID)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else {
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        self.members = documents.map { document in
                            var data = document.data()
                            data["documentID"] = document.documentID
                            return data
                        }
                        self.setUpNumberOfSeatsDropDown()
                        
                    }
                }
        }
    }
}

extension BookBusVC{
    func fetchAvailableTripsData(){
        db.collection("Trips")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    var tempTrips: [[String: Any]] = []
                    tempTrips = documents.map { document in
                        var data = document.data()
                        data["documentID"] = document.documentID
                        return data
                    }
                    // Filter the temporary array to include trips with availableSeats > 0
                    self.availableTrips = tempTrips.filter { trip in
                        return trip["availableSeats"] as? Int ?? 0 > 0
                    }
                    
                    self.stationNames = Array(Set(self.availableTrips.compactMap { $0["station"] as? String }))
                    self.destinationNames = Array(Set(self.availableTrips.compactMap { $0["destination"] as? String }))
                    
                    self.setUpStationDropList()
                    self.setUpStadiumDropList()
                }
            }
    }
}

extension BookBusVC{
    func setupUI(){
        showTripsButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
