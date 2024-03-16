//
//  MatchTicketDetailsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 13/03/2024.
//

import UIKit
import SDWebImage

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
    
    var qrCodeURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        if let qrCodeURL = qrCodeURL, let url = URL(string: qrCodeURL) {
            retrieveQRCodeImage(qrCodeURL: qrCodeURL)
        }
    }
    
    @IBAction func refundButtonPressed(_ sender: UIButton) {
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
