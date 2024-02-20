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

        let userIsSignedIn = true
        if userIsSignedIn {
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
            let profileNavController = UINavigationController(rootViewController: profileVC)
            profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle.fill"), selectedImage: UIImage(systemName: "person.circle.fill"))
            viewControllers[3] = profileNavController
        }

        setViewControllers(viewControllers, animated: false)
    }
}
