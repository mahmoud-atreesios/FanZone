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
    
    private let db = Firestore.firestore()
    var tickets: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        matchTicketsTableView.register(UINib(nibName: "MatchTicketsTableViewCell", bundle: nil), forCellReuseIdentifier: "matchTicketCell")
        matchTicketsTableView.delegate = self
        matchTicketsTableView.dataSource = self
        
        fetchMatchTickets()
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
            if matchDate < appLaunchDate {
                cell.ticketStatus.text = "Expired"
            } else {
                cell.ticketStatus.text = "Activated"
            }
        } else {
            cell.ticketStatus.text = "Activated"
        }
        return cell
    }
    
    func fetchMatchTickets(){
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID {
            db.collection("Match_Tickets")
                .whereField("userID", isEqualTo: userID)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else {
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        self.tickets = documents.compactMap { $0.data() }
                        DispatchQueue.main.async {
                            self.matchTicketsTableView.reloadData()
                        }
                    }
                }
        }
    }
}
