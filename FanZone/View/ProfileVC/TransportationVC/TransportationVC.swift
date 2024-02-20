//
//  TransportationVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 20/02/2024.
//

import UIKit

class TransportationVC: UIViewController {

    @IBOutlet weak var bookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bookButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)

    }

    @IBAction func bookBusButtonPressed(_ sender: UIButton) {
    }
}
