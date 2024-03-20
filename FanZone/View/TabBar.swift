//
//  TabBar.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 19/02/2024.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import SDWebImage

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
        let signInNavController = UINavigationController(rootViewController: signInVC)
        signInNavController.tabBarItem = UITabBarItem(title: "SignIn", image: UIImage(systemName: "person.circle.fill"), selectedImage: UIImage(systemName: "person.circle.fill"))
        
        var viewControllers = [homeNavController, newsNavController, highlightsNavController, signInNavController]
        
        if Auth.auth().currentUser != nil {
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
            let profileNavController = UINavigationController(rootViewController: profileVC)
            
            if let userID = Auth.auth().currentUser?.uid {
                Firestore.firestore().collection("Fan").document(userID).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        
                        if let fanImageURL = data?["fanImageURL"] as? String , let fanName = data?["fullname"] as? String{
                            let firstName = fanName.components(separatedBy: " ").first ?? ""
                            DispatchQueue.global().async {
                                SDWebImageManager.shared.loadImage(with: URL(string: fanImageURL), options: [], progress: nil) { (image, _, _, _, _, _) in
                                    if let fanImage = image {
                                        DispatchQueue.main.async {
                                            let resizedImage = self.resizeImageAndRoundCorners(fanImage, targetSize: CGSize(width: 30, height: 30))
                                            let tabBarItem = UITabBarItem(title: firstName, image: resizedImage.withRenderingMode(.alwaysOriginal), selectedImage: resizedImage.withRenderingMode(.alwaysOriginal))
                                            profileNavController.tabBarItem = tabBarItem
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            viewControllers[3] = profileNavController
        }
        
        setViewControllers(viewControllers, animated: false)
    }
}

extension TabBar {
    func resizeImageAndRoundCorners(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let roundedImage = renderer.image { _ in
            let ovalPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: targetSize))
            ovalPath.addClip()
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return roundedImage
    }
}
