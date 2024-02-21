//
//  TransportaionVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 22/02/2024.
//

import UIKit

class TransportationVC: UIViewController {

    @IBOutlet weak var bookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bookButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func bookBusButtonPressed(_ sender: UIButton) {
        print("book button pressed")
        let BookBusVC = BookBusVC(nibName: "BookBusVC", bundle: nil)
        navigationController?.pushViewController(BookBusVC, animated: true)
    }
}
