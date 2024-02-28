//
//  PaymentMethodVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 26/02/2024.
//

import UIKit
import AcceptSDK

class PaymentMethodVC: UIViewController {
    
    
    @IBOutlet weak var visaButton: RadioButton!
    @IBOutlet weak var fawryButton: RadioButton!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    private let viewModel = ViewModel()
    private let accept = AcceptSDK()
    
    var firstToken: String?
    var orderId: String?
    var paymentToken: String?
    var totalPrice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        accept.delegate = self
        nextButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
    func transactionAccepted(_ payData: PayResponse, savedCardData: SaveCardResponse) {
        print("Here i should save the ticket in the data base")
        print(payData)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    func userDidCancel3dSecurePayment(_ pendingPayData: PayResponse) {
        print(pendingPayData.integration_id)
    }
    
}
