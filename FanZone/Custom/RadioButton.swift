//
//  RadioButton.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 15/02/2024.
//

import Foundation
import UIKit

class RadioButton: UIButton {
    var isChecked: Bool = false {
        didSet {
            updateButtonAppearance()
        }
    }
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    func initButton() {
        backgroundColor = .clear
        tintColor = .clear
        setTitle("", for: .normal)
        updateButtonAppearance()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        isChecked.toggle()
        feedbackGenerator.impactOccurred()
    }
    
    func updateButtonAppearance() {
        if isChecked {
            setImage(UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            setImage(UIImage(named: "radio_button_unchecked")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
}
