//
//  BookBusVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/02/2024.
//

import UIKit
import iOSDropDown

class BookBusVC: UIViewController {
    
    @IBOutlet weak var showTripsButton: UIButton!
    
    @IBOutlet weak var busStationDropList: DropDown!
    @IBOutlet weak var stadiumDestinationDropList: DropDown!
    @IBOutlet weak var numberOfSeatsDropList: DropDown!
    
    var selectedBusStation: String?
    var selectedStadiumDestination: String?
    var selectedNumberOfSeats: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setUpStationDropList()
        setUpStadiumDropList()
        setUpNumberOfSeatsDropDown()
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
        tripsVC.selectedNumberOfSeats = selectedNumberOfSeats
        navigationController?.pushViewController(tripsVC, animated: true)
    }
}

extension BookBusVC{
    func setUpStationDropList(){
        busStationDropList.isSearchEnable = false
        busStationDropList.optionArray = ["Ain Shames","Tahrir Square","helwan","Alexandria","5th settlement","Giza","shobra"]
        busStationDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        busStationDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedBusStation = selectedText
        }
    }
    
    func setUpStadiumDropList(){
        stadiumDestinationDropList.isSearchEnable = false
        stadiumDestinationDropList.optionArray = ["We Salam Stad","Ismalia Stadium","Cairo International Stadium (al-Qāhirah (Cairo))","Alexandria Stadium","Borg El Arab Stadium (Al-Iskandarîah (Alexandria))"]
        stadiumDestinationDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        stadiumDestinationDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedStadiumDestination = selectedText
        }
    }
    
    func setUpNumberOfSeatsDropDown(){
        numberOfSeatsDropList.isSearchEnable = false
        numberOfSeatsDropList.optionArray = ["1","2","3","4"]
        numberOfSeatsDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        numberOfSeatsDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedNumberOfSeats = selectedText
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
