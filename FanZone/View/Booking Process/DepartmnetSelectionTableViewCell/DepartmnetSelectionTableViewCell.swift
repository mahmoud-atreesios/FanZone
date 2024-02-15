//
//  DepartmnetSelectionTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 15/02/2024.
//

import UIKit

class DepartmnetSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var departmentName: UILabel!
    @IBOutlet weak var selectedCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedCategoryName.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSelectedCategoryName(_ categoryName: String?) {
        selectedCategoryName.text = categoryName
    }
    
}
