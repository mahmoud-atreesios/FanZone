//
//  FamilyMembersTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 25/02/2024.
//

import UIKit

class FamilyMembersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var depImage: UIImageView!
    @IBOutlet weak var depID: UILabel!
    @IBOutlet weak var depName: UILabel!
    @IBOutlet weak var depGender: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        depImage.makeRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
