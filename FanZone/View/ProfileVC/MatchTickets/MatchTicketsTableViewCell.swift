//
//  MatchTicketsTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 06/03/2024.
//

import UIKit

class MatchTicketsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leagueName: UILabel!
    
    @IBOutlet weak var departmentName: UILabel!
    
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    
    @IBOutlet weak var matchStadium: UILabel!
    @IBOutlet weak var matchDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
