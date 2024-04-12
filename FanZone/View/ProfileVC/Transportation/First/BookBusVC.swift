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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showTripsButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
        setUpStationDropList()
        setUpStadiumDropList()
        setUpNumberOfSeatsDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
        
        let tripsVC = TripsVC(nibName: "TripsVC", bundle: nil)
        navigationController?.pushViewController(tripsVC, animated: true)
        //print("selected bus station \(selectedBusStation ?? "nothing yet")")
        //print("selected bus station \(selectedStadiumDestination ?? "nothing yet")")
    }
}

extension BookBusVC{
    func setUpStationDropList(){
        
        busStationDropList.isSearchEnable = false
        busStationDropList.optionArray = ["Ain Shames","Tahrir Square","Haram","Alexandria","5th settlement","Giza"]
        busStationDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        busStationDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedBusStation = selectedText
        }
    }
    
    func setUpStadiumDropList(){
        
        stadiumDestinationDropList.isSearchEnable = false
        stadiumDestinationDropList.optionArray = ["We Salam Stad","Ismalia Stadium","Cairo Stadium","Alexandria Stadium","Borg El Arab Stad"]
        stadiumDestinationDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        stadiumDestinationDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedStadiumDestination = selectedText
        }
    }
    
    func setUpNumberOfSeatsDropDown(){
        
        numberOfSeatsDropList.isSearchEnable = false
        numberOfSeatsDropList.optionArray = ["1","2","3"]
        numberOfSeatsDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        numberOfSeatsDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
        }
    }
}
