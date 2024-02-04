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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
