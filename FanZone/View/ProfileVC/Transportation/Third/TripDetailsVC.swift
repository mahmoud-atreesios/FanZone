//
//  TripDetailsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 23/02/2024.
//

import UIKit

class TripDetailsVC: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bookButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true
        
        bookButton.layer.cornerRadius = 10
        bookButton.layer.masksToBounds = true
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
