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
import iOSDropDown

class BookingVC: UIViewController{
    
    @IBOutlet weak var panoramaImageView: CTPanoramaView!
    @IBOutlet weak var departmentSelectionTableView: UITableView!
    
    @IBOutlet weak var numberOfTicketsDropDown: DropDown!
    @IBOutlet weak var numberOfTicketsTableView: UITableView!
    
    @IBOutlet weak var bookingButton: UILabel!
    @IBOutlet weak var totallTicketPrice: UILabel!
    
    private let disposeBag = DisposeBag()
    
    private let ticketPriceRelay = BehaviorRelay<Int?>(value: nil)

    var departmentTableViewData: [cellData] = [
        cellData(opened: false, department: "Left", categories: ["Cat-1": 10,"Cat-2": 20,"Cat-3": 30], imageName: "test11"),
        cellData(opened: false, department: "Right", categories: ["Cat-1": 10,"Cat-2": 20,"Cat-3": 30], imageName: "test13"),
        cellData(opened: false, department: "Vip", categories: ["Normal": 50,"SkyBox": 150], imageName: "test14"),
        cellData(opened: false, department: "Special Needs", categories: ["Standard": 5], imageName: "test11")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUi()
        panoramaImageView.controlMethod = .both
        
        departmentSelectionTableView.register(UINib(nibName: "DepartmnetSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "departmentsCell")
        departmentSelectionTableView.register(UINib(nibName: "CategorySelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
                
        departmentSelectionTableView.dataSource = self
        departmentSelectionTableView.delegate = self
        
        totalTicketPrice()
        setUpNumberOfTicketsDropDown()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bookingButtonTapped))
        bookingButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func bookingButtonTapped() {
        //setTotallTicketPrice()
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

extension BookingVC{
    func setUpNumberOfTicketsDropDown(){
        numberOfTicketsDropDown.isSearchEnable = false
        numberOfTicketsDropDown.placeholder = "0"
        numberOfTicketsDropDown.optionArray = ["1","2","3"]
        numberOfTicketsDropDown.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        numberOfTicketsDropDown.didSelect{(selectedText , index ,id) in
        print("Selected String: \(selectedText) \n index: \(index)")
            
        }
    }
}


// MARK: Department and Category Selection
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
            panoramaImageView.image = UIImage(named: departmentTableViewData[indexPath.section].imageName)
            
            cell.setSelectedCategoryName(departmentTableViewData[indexPath.section].selectedButton != nil ? categoryKeys[departmentTableViewData[indexPath.section].selectedButton!] : nil)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategorySelectionTableViewCell
            cell.categoryName.text = categoryKeys[indexPath.row - 1]
            cell.categoryPrice.text = "\(categoryValue[indexPath.row - 1])$"
            cell.categoryPriceText = "\(categoryValue[indexPath.row - 1])$"
            
            let isSelected = departmentTableViewData[indexPath.section].selectedButton == indexPath.row - 1
            cell.setRadioButtonChecked(isSelected)
            
            cell.checkButtonPressed = {
                if isSelected {
                    self.departmentTableViewData[indexPath.section].selectedButton = nil
                    self.ticketPriceRelay.accept(nil)
                } else {
                    self.departmentTableViewData[indexPath.section].selectedButton = indexPath.row - 1
                    self.ticketPriceRelay.accept(categoryValue[indexPath.row - 1])
                }
                
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
    func totalTicketPrice(){
        ticketPriceRelay
            .subscribe(onNext: { [weak self] price in
                guard let self = self else { return }
                if let price = price {
                    self.totallTicketPrice.text = "\(price)$"
                } else {
                    self.totallTicketPrice.text = "0$"
                }
            })
            .disposed(by: disposeBag)
    }
}
