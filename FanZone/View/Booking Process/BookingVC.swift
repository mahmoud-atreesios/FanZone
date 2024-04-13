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
import Firebase

class BookingVC: UIViewController{
    
    @IBOutlet weak var panoramaImageView: CTPanoramaView!
    @IBOutlet weak var departmentSelectionTableView: UITableView!
    
    @IBOutlet weak var numberOfTicketsDropDown: DropDown!
    @IBOutlet weak var numberOfTicketsTableView: UITableView!
    
    @IBOutlet weak var bookingButton: UILabel!
    @IBOutlet weak var totallTicketPrice: UILabel!
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    var firstToken: String?
    var orderId: String?
    var totalPrice: String?
    
    private let ticketPriceRelay = BehaviorRelay<Int?>(value: nil)
    var numberOfSelectedTickets = BehaviorRelay<Int>(value: 1)

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
        getFirtToken()
        
        departmentSelectionTableView.register(UINib(nibName: "DepartmnetSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "departmentsCell")
        departmentSelectionTableView.register(UINib(nibName: "CategorySelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        numberOfTicketsTableView.register(UINib(nibName: "NumberOfTicketsTableViewCell", bundle: nil), forCellReuseIdentifier: "ticketsForCell")
        numberOfTicketsTableView.isScrollEnabled = false
        
        departmentSelectionTableView.dataSource = self
        departmentSelectionTableView.delegate = self
        
        numberOfTicketsTableView.dataSource = self
        numberOfTicketsTableView.delegate = self
        
        totalTicketPrice()
        setUpNumberOfTicketsDropDown()
        makeBookingButtonLabelClickable()
    }
}

extension BookingVC{
    func setUpUi(){
        panoramaImageView.layer.cornerRadius = 20
        panoramaImageView.clipsToBounds = true
        panoramaImageView.controlMethod = .both

        bookingButton.layer.cornerRadius = 15
        bookingButton.clipsToBounds = true
        bookingButton.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func makeBookingButtonLabelClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bookingButtonTapped))
        bookingButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func bookingButtonTapped() {
        //print(numberOfSelectedTickets.value)
        guard Auth.auth().currentUser != nil else {
            showAlert(title: "OOPS!", message: "You have to sign in first to be able to book a ticket.")
            return
        }
        
        let paymentMethodVC = PaymentMethodVC(nibName: "PaymentMethodVC", bundle: nil)
        paymentMethodVC.firstToken = firstToken
        paymentMethodVC.totalPrice = totalPrice
        
        viewModel.getOrderId(firstToken: firstToken ?? "") { orderid in
            if let order = orderid{
                print("order ID: \(order)")
                //self.orderId = order
                paymentMethodVC.orderId = order
            } else {
                print("Failed to get access token")
            }
        }
        navigationController?.pushViewController(paymentMethodVC, animated: true)
    }
}

extension BookingVC{
    func getFirtToken(){
        viewModel.getFirstToken { accessToken in
            if let token = accessToken {
                // Use the access token here
                print("Access Token:", token)
                self.firstToken = token
            } else {
                // Handle error or no token
                print("Failed to get access token")
            }
        }
    }
}

extension BookingVC{
    func setUpNumberOfTicketsDropDown(){
        let attributedString = NSAttributedString(string: "1", attributes: [
            .foregroundColor: UIColor.black
        ])
        
        numberOfTicketsDropDown.isSearchEnable = false
        numberOfTicketsDropDown.attributedPlaceholder = attributedString
        numberOfTicketsDropDown.optionArray = ["1","2","3","4"]
        numberOfTicketsDropDown.itemsTintColor = .black
        numberOfTicketsDropDown.selectedIndex = 0
        
        // The the Closure returns Selected Index and String
        numberOfTicketsDropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.numberOfSelectedTickets.accept(Int(selectedText) ?? 0)
            self.numberOfTicketsTableView.reloadData()
            
        }
    }
}

// MARK: Department and Category Selection
extension BookingVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == departmentSelectionTableView{
            return departmentTableViewData.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == departmentSelectionTableView{
            if departmentTableViewData[section].opened == true {
                return departmentTableViewData[section].categories.count + 1
            }else {
                return 1
            }
        }else if tableView == numberOfTicketsTableView{
            return numberOfSelectedTickets.value
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == departmentSelectionTableView{
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
        }else if tableView == numberOfTicketsTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ticketsForCell", for: indexPath) as! NumberOfTicketsTableViewCell
            let ticketsDropList = cell.ticketsForDropList
            ticketsDropList?.isSearchEnable = false
            ticketsDropList?.placeholder = "My self"
            ticketsDropList?.optionArray = ["My self","Dep-1","Dep-2","Dep-3"]
            ticketsDropList?.itemsTintColor = .black
            ticketsDropList?.arrowSize = 10
            
            // The the Closure returns Selected Index and String
            ticketsDropList?.didSelect{(selectedText , index ,id) in
                print("Selected String: \(selectedText) \n index: \(index)")
                
            }
            
            return cell
        }
        return UITableViewCell()
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

extension BookingVC {
    func totalTicketPrice() {
        Observable.combineLatest(ticketPriceRelay, numberOfSelectedTickets)
            .subscribe(onNext: { price, numberOfTickets in
                if let price = price{
                    self.totallTicketPrice.text = "\(price * numberOfTickets)$"
                    self.totalPrice = "\(price * numberOfTickets)00"
                } else {
                    self.totallTicketPrice.text = "0$"
                }
            })
            .disposed(by: disposeBag)
    }
}
