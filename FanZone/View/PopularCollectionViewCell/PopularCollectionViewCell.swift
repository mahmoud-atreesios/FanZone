//
//  PopularCollectionViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 02/02/2024.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stadiumImageView: UIImageView!
    
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var matchTime: UILabel!
    @IBOutlet weak var stadiumName: UILabel!
    
    @IBOutlet weak var getTicketButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        getTicketButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
    }

    @IBAction func getTicketButtonPressed(_ sender: UIButton) {
    }
}
