//
//  PaymentMethodVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 26/02/2024.
//

import UIKit
import AcceptSDK
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class PaymentMethodVC: UIViewController {
    
    @IBOutlet weak var visaButton: RadioButton!
    @IBOutlet weak var fawryButton: RadioButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private let viewModel = ViewModel()
    private let accept = AcceptSDK()
    private let db = Firestore.firestore()
    
    var firstToken: String?
    var orderId: String?
    var paymentToken: String?
    var totalPrice: String?
    var matchBus = true
    
    var selectedDepIds: [String] = []
    
    var dep1 = "A9BK7Zsf1lOPThd05LQeBKLfR4Q2"
    var dep2 = "v3iobxxTAyQev3bkF2nkFxcpm6o1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        accept.delegate = self
        nextButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
        print("++++++++++ \(selectedDepIds) ++++++++")
    }
    
    @IBAction func button(_ sender: UIButton) {
        print("payment method vc \(firstToken ?? "")")
        print("payment method vc \(orderId ?? "")")
        print("payment method vc \(totalPrice ?? "")")
        viewModel.getPaymentToken(firstToken: firstToken ?? "", orderId: orderId ?? "", totalPrice: totalPrice ?? "") { token in
            if let paymentToken = token{
                //print("payment token done \(paymentToken)")
                self.paymentToken = paymentToken
            }else {
                print("Failed to get Payment Token")
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        guard paymentToken != nil else {
            // Payment token is nil, show an alert
            showAlert(title: "Payment method Required!", message: "You have to choose a payment method first.")
            return
        }
        paymentView()
    }
}

extension PaymentMethodVC: AcceptSDKDelegate{
    
    func paymentView(){
        accept.customization?.buttonsColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
        accept.customization?.backgroundColor = .white
        accept.customization?.navBarColor = .white
        accept.customization?.navBarTextColor = .black
        accept.customization?.textFieldBackgroundColor = .white
        accept.customization?.textFieldTextColor = .black
        accept.customization?.titleLabelTextColor = .black
        accept.customization?.inputLabelTextColor = .black
        accept.customization?.buttonText = ""
        accept.customization?.cardNameLabelText = ""
        accept.customization?.cardNumberLabelText = ""
        accept.customization?.expirationLabelText = ""
        accept.customization?.cvvLabelText = ""
        
        do {
            if let paymentTokenn = paymentToken {
                try accept.presentPayVC(vC: self, paymentKey: paymentTokenn, saveCardDefault: true, showSaveCard: true, showAlerts: true)
            }
        } catch AcceptSDKError.MissingArgumentError(let errorMessage) {
            print(errorMessage)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func userDidCancel() {
        print("user canceled")
    }
    
    func paymentAttemptFailed(_ error: AcceptSDKError, detailedDescription: String) {
        print(error)
    }
    
    func transactionRejected(_ payData: PayResponse) {
        print(payData)
    }
    
    func transactionAccepted(_ payData: PayResponse) {
        print("Transaction accepted")
        print(payData)
    }
    
    // MARK: mohaaaaaaaaaam
    // MARK: de l functon l hastakhdmha lma l user edfa3 3shan a3mal save ll ticket fe l data base
    func transactionAccepted(_ payData: PayResponse, savedCardData: SaveCardResponse){
        print("Here i should save the ticket in the data base")
        print(payData)
        
        if matchBus{
            saveMatchTicketToDataBase()
        } else {
            saveBusTicketToDataBase()
        }
        
        if let tabBarController = self.tabBarController as? TabBar {
            tabBarController.setupTabs()
        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
//            navigationController?.pushViewController(homeVC, animated: true)
//        }
    }
    
    func userDidCancel3dSecurePayment(_ pendingPayData: PayResponse) {
        print(pendingPayData.integration_id)
    }
    
}

extension PaymentMethodVC {
    func saveMatchTicketToDataBase(){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Generate a new document ID for the match ticket
        let ticketRef = self.db.collection("Match_Tickets").document()
        
        // Generate and save the QR code
        createAndSaveQRCodeToFirebase(withUserID: userID) { qrCodeURL in
            if let selectedMatchTicketsModel = MatchTicketsManager.shared.selectedMatchTicketsModel {
                let data: [String: Any] = [
                    "userID": userID, // Store the user ID for reference
                    "leagueName": selectedMatchTicketsModel.leagueName ?? "Unknown leagueName",
                    "leagueSeason": selectedMatchTicketsModel.leagueRound ?? "Unknown leagueRound",
                    "departmentName": selectedMatchTicketsModel.departmentName ?? "Unknown departmentName",
                    "homeTeamLogo": selectedMatchTicketsModel.homeTeamLogo ?? "Unknown homeTeamLogo",
                    "awayTeamLogo": selectedMatchTicketsModel.awayTeamLogo ?? "Unknown awayTeamLogo",
                    "matchStadium": selectedMatchTicketsModel.matchStadium ?? "Unknown matchStadium",
                    "matchDate": selectedMatchTicketsModel.matchDate ?? "Unknown matchDate",
                    "matchTime": selectedMatchTicketsModel.matchTime ?? "Unknown matchTime",
                    "ticketStatus": selectedMatchTicketsModel.ticketStatus ?? "Unkown status",
                    "qrCodeURL": qrCodeURL
                ]
                
                // Set data to Firestore
                ticketRef.setData(data) { error in
                    if let e = error {
                        print("+++++++++++++++++++++++++++++++++++++++ Error adding document: \(e.localizedDescription)")
                    } else {
                        print("Match Ticket with QR Code Saved successfully")
                    }
                }
            }
        }
    }
    
    func saveBusTicketToDataBase(){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        // Generate a new document ID for the match ticket
        let ticketRef = self.db.collection("Bus_Tickets").document()

        if let selectedBusTicketsModel = BusTicketsManager.shared.selectedBusTicketsModel {
            let data: [String: Any] = [
                "userID": userID, // Store the user ID for reference
                "busStation": selectedBusTicketsModel.station ?? "Unknown station",
                "stadiumDestination": selectedBusTicketsModel.destination ?? "Unknown destination",
                "travelDate": selectedBusTicketsModel.travelDate ?? "Unknown travelDate",
                "travelTime": selectedBusTicketsModel.travelTime ?? "Unknown travelTime",
                "numberOfSeats": selectedBusTicketsModel.numberOfSeats ?? "Unknown numberOfSeats",
                "busNumber": selectedBusTicketsModel.busNumber ?? "Unknown busNumber",
                "ticketStatus": selectedBusTicketsModel.ticketStatus ?? "Unkown status",
            ]

            // Set data to Firestore
            ticketRef.setData(data) { error in
                if let e = error {
                    print("+++++++++++++++++++++++++++++++++++++++ Error adding document: \(e.localizedDescription)")
                } else {
                    print("Bus Ticket Saved successfully")
                }
            }
        }
    }
    
    private func createAndSaveQRCodeToFirebase(withUserID userID: String, completion: @escaping (String) -> Void){
        // Generate a unique string for the QR code (you can use any unique identifier)
        let depIdsString = selectedDepIds.joined(separator: "_")
        let uniqueString = "\(depIdsString)_\(generateUniqueString())"
        
        // Create a data object from the unique string
        if let data = uniqueString.data(using: .ascii) {
            // Create a QR code filter
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                // Set the message data for the QR code
                filter.setValue(data, forKey: "inputMessage")
                
                // Get the output image from the filter
                if let outputImage = filter.outputImage {
                    // Scale the image to fit into the image view
                    let scaledImage = UIImage(ciImage: outputImage).resized(to: CGSize(width: 200, height: 200))
                    
                    // Convert the UIImage to Data
                    if let imageData = scaledImage.pngData() {
                        // Upload the image data to Firebase Storage
                        let qrCodeRef = Storage.storage().reference().child("qr_codes/\(uniqueString).png")
                        qrCodeRef.putData(imageData, metadata: nil) { (metadata, error) in
                            guard metadata != nil else {
                                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                                return
                            }
                            
                            // Get the download URL of the uploaded image
                            qrCodeRef.downloadURL { (url, error) in
                                if let downloadURL = url {
                                    completion(downloadURL.absoluteString)
                                } else {
                                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension PaymentMethodVC{
    func generateUniqueString() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString = String((0..<11).map{ _ in characters.randomElement()! })
        return randomString
    }
}

extension PaymentMethodVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

