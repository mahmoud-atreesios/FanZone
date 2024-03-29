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
    
    
    @IBOutlet weak var getTicketLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        getTicketLabel.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
        getTicketLabel.layer.cornerRadius = 5.0
        getTicketLabel.layer.masksToBounds = true
    }

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            parentResponder = responder.next
        }
        return nil
    }
}
