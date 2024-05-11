//
//  TripsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 22/02/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class TripsVC: UIViewController {
    
    @IBOutlet weak var availableTripsTableView: UITableView!
    
    private let db = Firestore.firestore()
    var availableTrips: [[String: Any]] = []
    
    var selectedBusStation: String?
    var selectedStadiumDestination: String?
    var selectedNumberOfSeats: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        availableTripsTableView.register(UINib(nibName: "AvailableTrips", bundle: nil), forCellReuseIdentifier: "availableTripsCell")
        availableTripsTableView.delegate = self
        availableTripsTableView.dataSource = self
        print("This is the station \(selectedBusStation ?? "nil")")
        print("This is the destination \(selectedStadiumDestination ?? "nil")")
        fetchAvailableTripsData()
        
    }
    
}

extension TripsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "availableTripsCell", for: indexPath) as! AvailableTrips
        let availableTrips = availableTrips[indexPath.row]
        
        cell.stationName.text = availableTrips["station"] as? String
        cell.stadiumName.text = availableTrips["destination"] as? String
        cell.travelDate.text = availableTrips["date"] as? String
        cell.travelTime.text = availableTrips["time"] as? String
        cell.tripPrice.text = "\(availableTrips["price"] as? String ?? "0")$"
        cell.availableSeats.text = "avaialable Seats: \(availableTrips["availableSeats"] as? Int ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripDetailsVC = TripDetailsVC(nibName: "TripDetailsVC", bundle: nil)
        tripDetailsVC.modalPresentationStyle = .fullScreen
        let selectedTrip = availableTrips[indexPath.row]
        
        tripDetailsVC.selectedStation = selectedTrip["station"] as? String
        tripDetailsVC.selectedDestination = selectedTrip["destination"] as? String
        tripDetailsVC.travelDate = selectedTrip["date"] as? String
        tripDetailsVC.travelTime = selectedTrip["time"] as? String
        tripDetailsVC.ticketPrice = selectedTrip["price"] as? String
        tripDetailsVC.selectedBusNumber = selectedTrip["busNumber"] as? String
        tripDetailsVC.estimatedArrivalTimee = selectedTrip["estimatedArrivalTime"] as? String
        tripDetailsVC.tripDocumentID = selectedTrip["documentID"] as? String
        tripDetailsVC.availableSeats = selectedTrip["availableSeats"] as? Int
        tripDetailsVC.selectedNumberOfSeats = selectedNumberOfSeats
        
        //present(tripDetailsVC, animated: true)
        navigationController?.pushViewController(tripDetailsVC, animated: true)
    }
}

extension TripsVC{
    func fetchAvailableTripsData(){
        if let station = selectedBusStation, let destination = selectedStadiumDestination {
            db.collection("Trips")
                .whereField("station", isEqualTo: station)
                .whereField("destination", isEqualTo: destination)
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
                        DispatchQueue.main.async {
                            self.availableTripsTableView.reloadData()
                        }
                    }
                }
        }
    }
}


extension TripsVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
