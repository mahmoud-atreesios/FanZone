//
//  NavBar.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 01/02/2024.
//

import Foundation
import UIKit

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
//kfkfk
