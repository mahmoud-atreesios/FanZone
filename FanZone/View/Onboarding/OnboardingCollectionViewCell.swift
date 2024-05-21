//
//  OnboardingCollectionViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 19/05/2024.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitle: UILabel!
    @IBOutlet weak var slideDescription: UILabel!
    
    func setup(_ slide: OnboardingSlide){
        slideImageView.image = slide.image
        slideTitle.text = slide.title
        slideDescription.text = slide.desc
    }
}
