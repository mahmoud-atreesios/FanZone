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
    
    func setUPTicketsForDropDown(){
        ticketsForDropList.isSearchEnable = false
        ticketsForDropList.placeholder = "My self"
        ticketsForDropList.optionArray = ["Dep 1","Dep_2","Dep-3"]
        ticketsForDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        ticketsForDropList.didSelect{(selectedText , index ,id) in
        print("Selected String: \(selectedText) \n index: \(index)")
            
        }
    }
    
}
