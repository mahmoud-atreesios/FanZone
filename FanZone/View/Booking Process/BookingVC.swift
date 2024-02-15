//
//  BookingVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 14/02/2024.
//

import UIKit
import CTPanoramaView
import RxSwift
import RxCocoa

struct cellData{
    var opened: Bool
    var department: String
    var categories: [String : Int]
    var selectedButton: Int?
}

class BookingVC: UIViewController{
    
    @IBOutlet weak var panoramaImageView: CTPanoramaView!
    @IBOutlet weak var departmentSelectionTableView: UITableView!
    
    @IBOutlet weak var numberOfTicketsTableView: UITableView!
    
    @IBOutlet weak var bookingButton: UILabel!
    
    private let disposeBag = DisposeBag()
    
    let image = UIImage(named: "test11")
    
    var departmentTableViewData: [cellData] = [
        cellData(opened: false, department: "Left", categories: ["Cat-1": 10,"Cat-2": 20,"Cat-3": 30]),
        cellData(opened: false, department: "Right", categories: ["Cat-1": 10,"Cat-2": 20,"Cat-3": 30]),
        cellData(opened: false, department: "Vip", categories: ["Cat-1": 10,"Cat-2": 20,"Cat-3": 30]),
        cellData(opened: false, department: "Special Needs", categories: ["Cat-1": 10,"Cat-2": 20,"Cat-3": 30])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUi()
        panoramaImageView.image = image
        panoramaImageView.controlMethod = .both
        
        departmentSelectionTableView.register(UINib(nibName: "DepartmnetSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "departmentsCell")
        departmentSelectionTableView.register(UINib(nibName: "CategorySelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        
        departmentSelectionTableView.dataSource = self
        departmentSelectionTableView.delegate = self
    }
}

extension BookingVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return departmentTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if departmentTableViewData[section].opened == true {
            return departmentTableViewData[section].categories.count + 1
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categories = departmentTableViewData[indexPath.section].categories
        let categoryKeys = Array(categories.keys).sorted()
        let categoryValue = Array(categories.values).sorted()
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "departmentsCell", for: indexPath) as! DepartmnetSelectionTableViewCell
            cell.departmentName.text = departmentTableViewData[indexPath.section].department
            cell.setSelectedCategoryName(departmentTableViewData[indexPath.section].selectedButton != nil ? categoryKeys[departmentTableViewData[indexPath.section].selectedButton!] : nil)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategorySelectionTableViewCell
            cell.categoryName.text = categoryKeys[indexPath.row - 1]
            cell.categoryPrice.text = "\(categoryValue[indexPath.row - 1])$"
            
            let isSelected = departmentTableViewData[indexPath.section].selectedButton == indexPath.row - 1
            cell.setRadioButtonChecked(isSelected)
            
            cell.checkButtonPressed = {
                // Update the selectedButton index for the current section
                if isSelected {
                    self.departmentTableViewData[indexPath.section].selectedButton = nil
                } else {
                    self.departmentTableViewData[indexPath.section].selectedButton = indexPath.row - 1
                }
                
                // Reload the section to update the radio button states
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
            }
            
            return cell
        }
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if departmentTableViewData[indexPath.section].opened == true{
            departmentTableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }else {
            departmentTableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
}


extension BookingVC{
    func setUpUi(){
        panoramaImageView.layer.cornerRadius = 20
        panoramaImageView.clipsToBounds = true
        
        bookingButton.layer.cornerRadius = 15
        bookingButton.clipsToBounds = true
    }
}
