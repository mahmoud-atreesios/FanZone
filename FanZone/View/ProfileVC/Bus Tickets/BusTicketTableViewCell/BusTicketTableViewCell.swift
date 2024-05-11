//
//  BusTicketTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 15/04/2024.
//

import UIKit
import UIGradient
import Firebase

protocol BusTicketTableViewCellDelegate: AnyObject {
    func refundTicket(withID ticketID: String)
}

class BusTicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var destination: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var numberOfSeats: UILabel!
    @IBOutlet weak var fanID: UILabel!
    
    @IBOutlet weak var busNumber: UILabel!
    @IBOutlet weak var ticketStatus: UILabel!
    
    @IBOutlet weak var refundedButton: UIImageView!
    
    var ticketID: String?
    //private let db = Firestore.firestore()
    var delegate: BusTicketTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //mainView.backgroundColor = UIColor.fromGradientWithDirection(.leftToRight, frame: frame, colors: [ UIColor(red: 0.063, green: 0.188, blue: 0.247, alpha: 1.0) , UIColor(red: 0.165, green: 0.490, blue: 0.615, alpha: 1.0)])
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        makeRefundedButtonClickable()
    }
    
    func makeRefundedButtonClickable(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(refundedButtonTapped))
        refundedButton.isUserInteractionEnabled = true
        refundedButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func refundedButtonTapped() {
        guard let ticketID = ticketID else {
            print("No ticket ID available")
            return
        }
        
        delegate?.refundTicket(withID: ticketID)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
