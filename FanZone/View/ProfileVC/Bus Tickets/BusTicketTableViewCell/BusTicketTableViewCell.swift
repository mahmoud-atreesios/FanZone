//
//  BusTicketTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 15/04/2024.
//

import UIKit
import UIGradient

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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.backgroundColor = UIColor.fromGradientWithDirection(.leftToRight, frame: frame, colors: [ UIColor(red: 0.063, green: 0.188, blue: 0.247, alpha: 1.0) , UIColor(red: 0.165, green: 0.490, blue: 0.615, alpha: 1.0)])

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
