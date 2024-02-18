//
//  CategorySelectionTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 15/02/2024.
//

import UIKit

class CategorySelectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryPrice: UILabel!
    @IBOutlet weak var categorySelectedRadioButton: RadioButton!
    
    var checkButtonPressed: (() -> Void)?
    var categoryPriceText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func categorySelectedButtonPressed(_ sender: UIButton) {
        checkButtonPressed?()
//        print("price-----------\(categoryPriceText)")
    }
    
    func setRadioButtonChecked(_ isChecked: Bool) {
        categorySelectedRadioButton.isChecked = isChecked
    }
    
}
