//
//  TabBar.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 19/02/2024.
//

import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    func setupTabs() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))

        let newsVC = storyboard.instantiateViewController(withIdentifier: "NewsVC")
        let newsNavController = UINavigationController(rootViewController: newsVC)
        newsNavController.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper"))

        let highlightsVC = storyboard.instantiateViewController(withIdentifier: "HighlightsVC")
        let highlightsNavController = UINavigationController(rootViewController: highlightsVC)
        highlightsNavController.tabBarItem = UITabBarItem(title: "Highlights", image: UIImage(systemName: "video"), selectedImage: UIImage(systemName: "video"))

        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        signInVC.tabBarItem = UITabBarItem(title: "SignIn", image: UIImage(systemName: "person.circle.fill"), selectedImage: UIImage(systemName: "person.circle.fill"))

        var viewControllers = [homeNavController, newsNavController, highlightsNavController, signInVC]
        
        let userIsSignedIn = false
        
        if userIsSignedIn {
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
            let profileNavController = UINavigationController(rootViewController: profileVC)
            if let originalImage = UIImage(named: "FanImage") {
                let resizedImage = resizeImageAndRoundCorners(originalImage, targetSize: CGSize(width: 30, height: 30), strokeColor: .lightGray, strokeWidth: 2.0)
                let tabBarItem = UITabBarItem(title: "Profile", image: resizedImage.withRenderingMode(.alwaysOriginal), selectedImage: resizedImage.withRenderingMode(.alwaysOriginal))
                profileNavController.tabBarItem = tabBarItem
            }
            viewControllers[3] = profileNavController
        }

        setViewControllers(viewControllers, animated: false)
    }
    
}

extension TabBar{
    func resizeImageAndRoundCorners(_ image: UIImage, targetSize: CGSize, strokeColor: UIColor, strokeWidth: CGFloat) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)

        let context = UIGraphicsGetCurrentContext()!

        let strokeRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(strokeWidth)
        context.strokeEllipse(in: strokeRect)

        let clipPath = UIBezierPath(ovalIn: rect)
        clipPath.addClip()

        image.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
