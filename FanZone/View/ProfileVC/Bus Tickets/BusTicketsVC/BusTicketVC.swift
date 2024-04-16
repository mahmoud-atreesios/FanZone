//
//  BusTicketVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 15/04/2024.
//

import UIKit
import Firebase

class BusTicketVC: UIViewController {
    
    @IBOutlet weak var busTicketsTableView: UITableView!
    
    private let db = Firestore.firestore()
    var busTickets: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        busTicketsTableView.register(UINib(nibName: "BusTicketTableViewCell", bundle: nil), forCellReuseIdentifier: "busTicketCell")
        busTicketsTableView.delegate = self
        busTicketsTableView.dataSource = self
        fetchBusTickets()
    }

}

extension BusTicketVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "busTicketCell", for: indexPath) as! BusTicketTableViewCell
        let busTicket = busTickets[indexPath.row]
        
        cell.station.text = busTicket["busStation"] as? String
        cell.destination.text = busTicket["stadiumDestination"] as? String
        cell.date.text = busTicket["travelDate"] as? String
        cell.time.text = busTicket["travelTime"] as? String
        cell.numberOfSeats.text = busTicket["numberOfSeats"] as? String
        cell.busNumber.text = busTicket["busNumber"] as? String
        cell.ticketStatus.text = busTicket["ticketStatus"] as? String
        
        if let userID = busTicket["userID"] as? String {
            let fanID = String(userID.prefix(4))
            cell.fanID.text = fanID
        }
        
        return cell
    }
}

extension BusTicketVC{
    func fetchBusTickets(){
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID {
            db.collection("Bus_Tickets")
                .whereField("userID", isEqualTo: userID)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else {
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        self.busTickets = documents.map { document in
                            var data = document.data()
                            data["documentID"] = document.documentID
                            return data
                        }
                        DispatchQueue.main.async {
                            self.busTicketsTableView.reloadData()
                        }
                    }
                }
        }
    }
}

extension BusTicketVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
