//
//  FamilyMembersVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 25/02/2024.
//

import UIKit

class FamilyMembersVC: UIViewController {
    
    @IBOutlet weak var familyMembersTableView: UITableView!
    @IBOutlet weak var addNewMemberButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        familyMembersTableView.register(UINib(nibName: "FamilyMembersTableViewCell", bundle: nil), forCellReuseIdentifier: "familyMembersCell")
        familyMembersTableView.isUserInteractionEnabled = false
        familyMembersTableView.delegate = self
        familyMembersTableView.dataSource = self
        addNewMemberButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func addNewMemberButtonPressed(_ sender: UIButton) {
        let addMemberVC = AddMemberVC(nibName: "AddMemberVC", bundle: nil)
        navigationController?.pushViewController(addMemberVC, animated: true)
    }
    
}

extension FamilyMembersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "familyMembersCell", for: indexPath) as! FamilyMembersTableViewCell
        return cell
    }
    
}
