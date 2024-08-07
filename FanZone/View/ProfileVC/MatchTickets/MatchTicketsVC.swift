//
//  MatchTicketsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 06/03/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class MatchTicketsVC: UIViewController {
    
    @IBOutlet weak var matchTicketsTableView: UITableView!
    
    var noMatchesImageView: UIImageView!
    
    private let db = Firestore.firestore()
    var tickets: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        matchTicketsTableView.register(UINib(nibName: "MatchTicketsTableViewCell", bundle: nil), forCellReuseIdentifier: "matchTicketCell")
        matchTicketsTableView.delegate = self
        matchTicketsTableView.dataSource = self
        fetchMatchTickets()
        //setFirstScreen()
    }
}

extension MatchTicketsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchTicketCell", for: indexPath) as! MatchTicketsTableViewCell
        
        let ticket = tickets[indexPath.row] // Assuming tickets is an array containing the documents from the "Match_Tickets" collection
        cell.leagueName.text = ticket["leagueName"] as? String
        cell.departmentName.text = ticket["departmentName"] as? String
        cell.homeTeamLogo.sd_setImage(with: URL(string: ticket["homeTeamLogo"] as? String ?? ""))
        cell.awayTeamLogo.sd_setImage(with: URL(string: ticket["awayTeamLogo"] as? String ?? ""))
        cell.matchStadium.text = ticket["matchStadium"] as? String
        cell.matchDate.text = ticket["matchDate"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let matchDateString = ticket["matchDate"] as? String,
           let matchDate = dateFormatter.date(from: matchDateString),
           let appLaunchDate = UserDefaults.standard.object(forKey: "appLaunchDate") as? Date {
            if matchDate < appLaunchDate && ticket["ticketStatus"] as! String == "Activated"  {
                let ticketID = ticket["documentID"] as? String ?? ""
                let ticketRef = db.collection("Match_Tickets").document(ticketID)
                ticketRef.updateData(["ticketStatus": "Expired"]) { error in
                    if let error = error {
                        print("Error updating ticket status: \(error.localizedDescription)")
                    } else {
                        cell.ticketStatus.text = ticket["ticketStatus"] as? String
                    }
                }
            } else {
                cell.ticketStatus.text = ticket["ticketStatus"] as? String
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
}

extension MatchTicketsVC {
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? MatchTicketsTableViewCell else { return }
        guard let indexPath = matchTicketsTableView.indexPath(for: cell) else { return }
        let ticket = tickets[indexPath.row]
        
        guard let ticketStatus = ticket["ticketStatus"] as? String, ticketStatus != "Refunded" else {
            // Ticket status is "refunded", do nothing
            return
        }
        guard let ticketStatus = ticket["ticketStatus"] as? String, ticketStatus != "Expired" else {
            // Ticket status is "refunded", do nothing
            return
        }
        
        let matchTicketDetailsVC = MatchTicketDetailsVC(nibName: "MatchTicketDetailsVC", bundle: nil)
        matchTicketDetailsVC.loadViewIfNeeded() // Ensure the view is loaded
        matchTicketDetailsVC.leagueName.text = ticket["leagueName"] as? String
        matchTicketDetailsVC.leagueRound.text = ticket["leagueRound"] as? String
        matchTicketDetailsVC.departmentName.text = ticket["departmentName"] as? String
        matchTicketDetailsVC.homeTeamLogo.sd_setImage(with: URL(string: ticket["homeTeamLogo"] as? String ?? ""))
        matchTicketDetailsVC.awayTeamLogo.sd_setImage(with: URL(string: ticket["awayTeamLogo"] as? String ?? ""))
        matchTicketDetailsVC.matchStadium.text = ticket["matchStadium"] as? String
        matchTicketDetailsVC.matchDate.text = ticket["matchDate"] as? String
        matchTicketDetailsVC.matchTime.text = ticket["matchTime"] as? String
        matchTicketDetailsVC.retrieveQRCodeImage(qrCodeURL: ticket["qrCodeURL"] as? String ?? "")
        matchTicketDetailsVC.matchDateForComparison = ticket["matchDate"] as? String
        print("Ticket ID: \(ticket["documentID"] as? String ?? "")")
        matchTicketDetailsVC.ticketID = ticket["documentID"] as? String
        
        navigationController?.pushViewController(matchTicketDetailsVC, animated: true)
    }
}

extension MatchTicketsVC {
    func fetchMatchTickets(){
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID {
            db.collection("Match_Tickets")
                .whereField("userID", isEqualTo: userID)
                .whereField("selectedTicket", isEqualTo: "yes")
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else {
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        self.tickets = documents.map { document in
                            var data = document.data()
                            data["documentID"] = document.documentID
                            return data
                        }
                        // Sort tickets based on ticket status
                        self.tickets.sort { (ticket1, ticket2) -> Bool in
                            guard let status1 = ticket1["ticketStatus"] as? String,
                                  let status2 = ticket2["ticketStatus"] as? String else {
                                return false
                            }
                            // Define order based on status: Activated -> Refunded -> Expired
                            if status1 == "Activated" && status2 != "Activated" {
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
                            self.matchTicketsTableView.reloadData()
                        }
                    }
                }
        }
    }
}

//MARK: - intial setup
extension MatchTicketsVC{
    func setFirstScreen(){
        if tickets.isEmpty {
            // Create and configure the "no matches" image view
            noMatchesImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200)) // Adjust the frame according to your layout
            noMatchesImageView.image = UIImage(named: "nomatches")
            noMatchesImageView.contentMode = .scaleAspectFit // Adjust the content mode according to your image aspect ratio
            noMatchesImageView.center = view.center
            view.addSubview(noMatchesImageView)
        } else {
            // Remove the "no matches" image view if tickets are available
            noMatchesImageView?.removeFromSuperview()
            noMatchesImageView = nil
        }
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
