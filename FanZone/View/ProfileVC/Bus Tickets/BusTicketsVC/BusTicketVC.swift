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
        if let ticketStatus = busTicket["ticketStatus"] as? String, ticketStatus == "Refunded" || ticketStatus == "Expired" {
            cell.refundedButton.isUserInteractionEnabled = false
        } else {
            cell.refundedButton.isUserInteractionEnabled = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let matchDateString = busTicket["travelDate"] as? String,
           let matchDate = dateFormatter.date(from: matchDateString),
           let appLaunchDate = UserDefaults.standard.object(forKey: "appLaunchDate") as? Date {
            if matchDate < appLaunchDate && busTicket["ticketStatus"] as! String == "Activated"  {
                let ticketID = busTicket["documentID"] as? String ?? ""
                let ticketRef = db.collection("Bus_Tickets").document(ticketID)
                ticketRef.updateData(["ticketStatus": "Expired"]) { error in
                    if let error = error {
                        print("Error updating ticket status: \(error.localizedDescription)")
                    } else {
                        cell.ticketStatus.text = busTicket["ticketStatus"] as? String
                    }
                }
            } else {
                cell.ticketStatus.text = busTicket["ticketStatus"] as? String
            }
        }
        
        return cell
    }
    
    func refundTicket(withID ticketID: String) {
        let confirmAlert = UIAlertController(title: "Do you want to refund the ticket?",
                                             message: nil,
                                             preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            // Get travel date for the ticket
            self.getTravelDate(forTicketID: ticketID) { travelDate in
                if let travelDate = travelDate {
                    // Get the launch date
                    let launchDate = UserDefaults.standard.object(forKey: "appLaunchDate") as? Date ?? Date()
                    
                    // Calculate the difference in days
                    let calendar = Calendar.current
                    if let days = calendar.dateComponents([.day], from: launchDate, to: travelDate).day, days > 1 {
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
                    } else {
                        // Show alert that ticket cannot be refunded
                        let cannotRefundAlert = UIAlertController(title: "Ticket cannot be refunded",
                                                                  message: "Sorry, The ticket cannot be refunded as our policy says you cannot refund a ticket before the ticket date by 24h, if you have further questions you can contact us.",
                                                                  preferredStyle: .alert)
                        cannotRefundAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(cannotRefundAlert, animated: true, completion: nil)
                    }
                } else {
                    print("Failed to retrieve travel date")
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
                        
                        self.busTickets.sort { (ticket1, ticket2) -> Bool in
                            guard let status1 = ticket1["ticketStatus"] as? String,
                                  let status2 = ticket2["ticketStatus"] as? String else {
                                return false
                            }
                            // Define order based on status: Activated -> Refunded -> Expired
                            if status1 == "Activated" {
                                return true
                            } else if status1 == "Expired" && status2 != "Activated" {
                                return true
                            } else if status1 == "Refunded" && status2 != "Activated" && status2 != "Expired" {
                                return true
                            } else {
                                return false
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.busTicketsTableView.reloadData()
                        }
                    }
                }
        }
    }
    
    func getTravelDate(forTicketID ticketID: String, completion: @escaping (Date?) -> Void) {
        let ticketRef = db.collection("Bus_Tickets").document(ticketID)
        ticketRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let travelDateString = document.data()?["travelDate"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let travelDate = dateFormatter.date(from: travelDateString) {
                        completion(travelDate)
                        return
                    }
                }
            } else {
                print("Document does not exist")
            }
            completion(nil)
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
