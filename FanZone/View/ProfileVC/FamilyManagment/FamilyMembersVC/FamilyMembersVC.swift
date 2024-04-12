//
//  FamilyMembersVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 25/02/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class FamilyMembersVC: UIViewController {
    
    @IBOutlet weak var familyMembersTableView: UITableView!
    @IBOutlet weak var addNewMemberButton: UIButton!
    
    private let db = Firestore.firestore()
    var members: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
        familyMembersTableView.register(UINib(nibName: "FamilyMembersTableViewCell", bundle: nil), forCellReuseIdentifier: "familyMembersCell")
        fetchFamilyMembers()
    }
    
    @IBAction func addNewMemberButtonPressed(_ sender: UIButton) {
        let addMemberVC = AddMemberVC(nibName: "AddMemberVC", bundle: nil)
        navigationController?.pushViewController(addMemberVC, animated: true)
    }
    
}

extension FamilyMembersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "familyMembersCell", for: indexPath) as! FamilyMembersTableViewCell
        
        let member = members[indexPath.row] // Assuming tickets is an array containing the documents from the "Match_Tickets" collection
        let memberImage = member["depImageURL"] as? String
        cell.depID.text = member["userID"] as? String
        cell.depName.text = member["depName"] as? String
        cell.depGender.text = member["depGender"] as? String
        cell.depImage.sd_setImage(with: URL(string: memberImage ?? ""))
        return cell
    }
}

extension FamilyMembersVC{
    func fetchFamilyMembers(){
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID {
            db.collection("Family_Members")
                .whereField("userID", isEqualTo: userID)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else {
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        self.members = documents.map { document in
                            var data = document.data()
                            data["documentID"] = document.documentID
                            return data
                        }
                        DispatchQueue.main.async {
                            self.familyMembersTableView.reloadData()
                        }
                    }
                }
        }
    }
}

extension FamilyMembersVC{
    func setUpUI(){
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
}
