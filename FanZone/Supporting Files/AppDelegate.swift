//
//  AppDelegate.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 31/01/2024.
//

import UIKit
import FirebaseCore
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "appLaunchDate")
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if hasCompletedOnboarding {
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            window?.rootViewController = tabBarController
        } else {
            let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
            window?.rootViewController = onboardingVC
        }
        
        window?.makeKeyAndVisible()
                
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

