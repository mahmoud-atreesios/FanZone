//
//  MatchTicketsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 06/03/2024.
//

import UIKit
import RxSwift

class MatchTicketsVC: UIViewController {
    
    @IBOutlet weak var matchTicketsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        matchTicketsTableView.register(UINib(nibName: "MatchTicketsTableViewCell", bundle: nil), forCellReuseIdentifier: "matchTicketCell")
    }
}

extension MatchTicketsVC{
    
}
