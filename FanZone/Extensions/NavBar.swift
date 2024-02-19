//
//  NavBar.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 01/02/2024.
//

import Foundation
import UIKit

// Mainly for title bar for the logoo and the person button
struct NavBar{
     static func applyCustomNavBar(to viewController: UIViewController){
        let imageView = UIImageView(image: UIImage(named: "FanZoneLogo"))
        let leftBarButton = UIBarButtonItem(customView: imageView)
         viewController.navigationItem.leftBarButtonItem = leftBarButton
        
        if let image = UIImage(systemName: "person.circle") {
            let coloredImage = image.withTintColor(UIColor(red: 33/255.0, green: 53/255.0, blue: 85/255.0, alpha: 1.0), renderingMode: .alwaysOriginal)
            let imageView = UIImageView(image: coloredImage)
            imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 28)
            let rightBarButton = UIBarButtonItem(customView: imageView)
            viewController.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
}


// For gradient background signup page
extension UIView {
    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.8, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
