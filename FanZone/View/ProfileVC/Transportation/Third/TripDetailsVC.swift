//
//  TripDetailsVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 23/02/2024.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setUpTripDetails()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        numberOfSeats.text = selectedNumberOfSeats
                
        if let ticketPriceInt = Int(ticketPrice ?? "0") , let selectedNumberOfSeatsInt = Int(selectedNumberOfSeats ?? "0"){
            totalPrice.text = "\(ticketPriceInt * selectedNumberOfSeatsInt)$"
        }else {
            totalPrice.text = "N/A"
        }
    }
}

extension TripDetailsVC{
    @objc func bookButtonTapped() {
        print("Book button tapped")
        
        BusTicketsManager.shared.selectedBusTicketsModel = BusTicketsModel(
            station: selectedStation,
            destination: selectedDestination,
            travelDate: travelDate,
            travelTime: travelTime,
            numberOfSeats: selectedNumberOfSeats,
            busNumber: selectedBusNumber,
            ticketStatus: "Activated")
    }
}
