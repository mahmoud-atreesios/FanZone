//
//  NumberOfTicketsTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 18/02/2024.
//

import UIKit
import iOSDropDown

class NumberOfTicketsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ticketsForDropList: DropDown!
    @IBOutlet weak var ticketsTest: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setUPTicketsForDropDown()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
