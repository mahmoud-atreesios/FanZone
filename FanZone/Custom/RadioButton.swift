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
        let outerCircleImage = UIImage(systemName: "circle")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        let innerCircleImage = UIImage(systemName: "circle.fill")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        let size = outerCircleImage?.size ?? .zero

        if isChecked {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            outerCircleImage?.draw(in: CGRect(origin: .zero, size: size))
            innerCircleImage?.draw(in: CGRect(origin: CGPoint(x: 5, y: 5), size: CGSize(width: size.width - 10, height: size.height - 10)))
            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            setImage(combinedImage, for: .normal)

        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            outerCircleImage?.draw(in: CGRect(origin: .zero, size: size))
            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            setImage(combinedImage, for: .normal)

        }
    }
}

