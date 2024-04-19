//
//  BusTicketVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 15/04/2024.
//

import UIKit
import Firebase

class BusTicketVC: UIViewController, BusTicketTableViewCellDelegate {
    
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
        cell.ticketID = busTicket["documentID"] as? String
        cell.delegate = self
        
        if let userID = busTicket["userID"] as? String {
            let fanID = String(userID.prefix(4))
            cell.fanID.text = fanID
        }
        
        // Disable refundedButton if ticket status is "Refunded"
        if let ticketStatus = busTicket["ticketStatus"] as? String, ticketStatus == "Refunded" {
            cell.refundedButton.isUserInteractionEnabled = false
        } else {
            cell.refundedButton.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    func refundTicket(withID ticketID: String) {
            let confirmAlert = UIAlertController(title: "Do you want to refund the ticket?",
                                                 message: nil,
                                                 preferredStyle: .alert)

            confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                // Update ticket status to "Refunded" in Firestore
                let ticketRef = self.db.collection("Bus_Tickets").document(ticketID)
                ticketRef.updateData(["ticketStatus": "Refunded"]) { error in
                    if let error = error {
                        print("Error updating ticket status: \(error.localizedDescription)")
                    } else {
                        print("Ticket status updated successfully to refunded")
                        let successAlert = UIAlertController(title: "Ticket refunded successfully",
                                                             message: nil,
                                                             preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                            // Reload the tab bar
                            if let tabBarController = self.tabBarController as? TabBar {
                                tabBarController.setupTabs()
                            }
                        }))
                        self.present(successAlert, animated: true, completion: nil)
                    }
                }
            }))

            confirmAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(confirmAlert, animated: true, completion: nil)
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
