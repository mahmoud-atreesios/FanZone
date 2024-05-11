//
//  AvailableTrips.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 22/02/2024.
//

import UIKit

class AvailableTrips: UITableViewCell {

    
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var stadiumName: UILabel!
    
    
    @IBOutlet weak var travelDate: UILabel!
    @IBOutlet weak var travelTime: UILabel!
    
    @IBOutlet weak var tripPrice: UILabel!
    @IBOutlet weak var availableSeats: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
