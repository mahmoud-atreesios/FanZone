//
//  TripDetailsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 23/02/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
//estimatedArrivalTime
class TripDetailsVC: UIViewController {
    
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var destinationName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var numberOfSeats: UILabel!
    @IBOutlet weak var busNumber: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bookButton: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    var selectedStation: String?
    var selectedDestination: String?
    var travelDate: String?
    var travelTime: String?
    var selectedNumberOfSeats: String?
    var selectedBusNumber: String?
    var ticketPrice: String?
    var tripDocumentID: String?
    var availableSeats: Int?
    var selectedTicketTo: String?
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    var firstToken: String?
    var orderId: String?
    var totalTicketPrice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setUpTripDetails()
        getFirtToken()
    }
}

extension TripDetailsVC{
    @objc func bookButtonTapped() {
        
        guard Auth.auth().currentUser != nil else {
            showAlert(title: "OOPS!", message: "You have to sign in first to be able to book a ticket.")
            return
        }
        
//        guard let availableSeats = availableSeats, let selectedNumberOfSeatsInteger = Int(selectedNumberOfSeats ?? "0") else {
//            showAlert(title: "Error", message: "Invalid number of available seats or selected number of seats.")
//            return
//        }
//
//        guard availableSeats >= selectedNumberOfSeatsInteger else {
//            showAlert(title: "Not Enough Seats", message: "There are not enough available seats in this trip.")
//            return
//        }
        
        BusTicketsManager.shared.selectedBusTicketsModel = BusTicketsModel(
            station: selectedStation,
            destination: selectedDestination,
            travelDate: travelDate,
            travelTime: travelTime,
            busNumber: selectedBusNumber,
            ticketStatus: "Activated",
            documentID: tripDocumentID,
            availableSeats: availableSeats,
            ticketTo: selectedTicketTo)
        
        let paymentMethodVC = PaymentMethodVC(nibName: "PaymentMethodVC", bundle: nil)
        paymentMethodVC.firstToken = firstToken
        paymentMethodVC.totalPrice = totalTicketPrice
        paymentMethodVC.matchBus = false
        
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

extension TripDetailsVC{
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

extension TripDetailsVC{
    func setupUI(){
        bookButton.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bookButtonTapped))
        bookButton.addGestureRecognizer(tapGestureRecognizer)
        
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true
        bookButton.layer.cornerRadius = 10
        bookButton.layer.masksToBounds = true
    }
    func setUpTripDetails(){
        stationName.text = selectedStation
        destinationName.text = selectedDestination
        date.text = travelDate
        time.text = travelTime
        busNumber.text = selectedBusNumber
        numberOfSeats.text = "000"
                
        if let ticketPriceInt = Int(ticketPrice ?? "0") , let selectedNumberOfSeatsInt = Int(selectedNumberOfSeats ?? "1"){
            totalTicketPrice = String(ticketPriceInt * selectedNumberOfSeatsInt)
            totalPrice.text = "\(ticketPriceInt * selectedNumberOfSeatsInt)$"
        }else {
            totalPrice.text = "N/A"
        }
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
