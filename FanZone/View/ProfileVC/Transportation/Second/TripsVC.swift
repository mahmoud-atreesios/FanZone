//
//  TripsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 22/02/2024.
//

import UIKit

class TripsVC: UIViewController {

    
    @IBOutlet weak var availableTripsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        availableTripsTableView.register(UINib(nibName: "AvailableTrips", bundle: nil), forCellReuseIdentifier: "availableTripsCell")
        
        availableTripsTableView.delegate = self
        availableTripsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
}

extension TripsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "availableTripsCell", for: indexPath) as! AvailableTrips
        
        return cell
    }
    
    
}
