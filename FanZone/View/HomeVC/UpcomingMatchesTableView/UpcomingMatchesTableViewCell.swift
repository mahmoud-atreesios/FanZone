//
//  UpcomingMatchesTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 03/02/2024.
//

import UIKit

class UpcomingMatchesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var stadImageView: UIImageView!
    
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var matchTime: UILabel!
    @IBOutlet weak var stadName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set corner radius for top-left and bottom-left
        stadImageView.layer.cornerRadius = 10.0
        stadImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        stadImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
