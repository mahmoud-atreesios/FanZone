//
//  TripDetailsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 23/02/2024.
//

import UIKit

class TripDetailsVC: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
