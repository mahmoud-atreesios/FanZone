//
//  RegisterationDoneVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/03/2024.
//

import UIKit
import Lottie
import Firebase

class RegisterationDoneVC: UIViewController {
    
    @IBOutlet weak var congratsAnimationViewOne: LottieAnimationView!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var congratsAnimationViewTwo: LottieAnimationView!
    
    @IBOutlet weak var getTicketButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationSetUp()
        setUpUi()
    }
    
    @IBAction func getYourTicketButtonPressed(_ sender: UIButton) {
        if let tabBarController = self.tabBarController as? TabBar {
            tabBarController.setupTabs()
        }
    }
}

extension RegisterationDoneVC{
    
    func setUpUi(){
        
        getTicketButton.tintColor = UIColor(red: 87/255, green: 149/255, blue: 154/255, alpha: 1.0)
        getTicketButton.layer.cornerRadius = 10
        getTicketButton.layer.masksToBounds = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func animationSetUp(){
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        animationView!.play()
        
        congratsAnimationViewOne!.contentMode = .scaleAspectFit
        congratsAnimationViewOne!.loopMode = .loop
        congratsAnimationViewOne!.animationSpeed = 0.5
        congratsAnimationViewOne!.play()
        
        congratsAnimationViewTwo!.contentMode = .scaleAspectFit
        congratsAnimationViewTwo!.loopMode = .loop
        congratsAnimationViewTwo!.animationSpeed = 0.5
        congratsAnimationViewTwo!.play()
    }
}
