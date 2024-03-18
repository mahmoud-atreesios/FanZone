//
//  MatchTicketDetailsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 13/03/2024.
//

import UIKit
import SDWebImage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class MatchTicketDetailsVC: UIViewController {
    
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueRound: UILabel!
    
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    
    @IBOutlet weak var matchStadium: UILabel!
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var matchTime: UILabel!
    @IBOutlet weak var departmentName: UILabel!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var refundButton: UIButton!
    
    var ticketID: String?
    var qrCodeURL: String?
    var matchDateForComparison: String?
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let qrCodeURL = qrCodeURL{
            retrieveQRCodeImage(qrCodeURL: qrCodeURL)
        }
        setUp()
    }
    
    @IBAction func refundButtonPressed(_ sender: UIButton) {
        guard let ticketID = ticketID else {
            print("No ticket ID available")
            return
        }

        let confirmAlert = UIAlertController(title: "Do you want to refund the ticket?",
                                             message: nil,
                                             preferredStyle: .alert)

        confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            // Update ticket status to "Refunded" in Firestore
            let ticketRef = self.db.collection("Match_Tickets").document(ticketID)
            ticketRef.updateData(["ticketStatus": "Refunded"]) { error in
                if let error = error {
                    print("Error updating ticket status: \(error.localizedDescription)")
                } else {
                    print("Ticket status updated successfully to refundedddd")
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



extension MatchTicketDetailsVC {
    
    
    
    func retrieveQRCodeImage(qrCodeURL: String) {
        self.qrCodeImageView.sd_setImage(with: URL(string: qrCodeURL), placeholderImage: UIImage(named: "circle"))
    }
}

extension MatchTicketDetailsVC{
    
    func setUp(){
        backgroundView.layer.cornerRadius = 10.0
        backgroundView.layer.masksToBounds = true
        refundButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
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
