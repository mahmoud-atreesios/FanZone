//
//  BookBusVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/02/2024.
//

import UIKit

class BookBusVC: UIViewController {
    
    @IBOutlet weak var showTripsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showTripsButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func showTripsButtonPressed(_ sender: UIButton) {
        print("show trips button pressed")
    }
}
