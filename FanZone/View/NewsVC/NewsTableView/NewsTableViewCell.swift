//
//  NewsTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 08/02/2024.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsImageView.layer.cornerRadius = 10.0
        newsImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        newsImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }    
}
