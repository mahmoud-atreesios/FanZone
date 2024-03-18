//
//  StepTwoVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/03/2024.
//

import UIKit
import iOSDropDown
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Lottie

class StepTwoVC: UIViewController {
    
    @IBOutlet weak var fanImage: UIImageView!
    @IBOutlet weak var fanFullName: UITextField!
    @IBOutlet weak var fanPhoneNumber: UITextField!
    
    @IBOutlet weak var fanGender: DropDown!
    @IBOutlet weak var fanSupportedTeam: DropDown!
    
    @IBOutlet weak var nextButton: UIButton!
    
    let db = Firestore.firestore()
    var selectedGender: String?
    var selectedSupportedTeam: String?

    var isSavingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        setUpGenderDropList()
        setUpSupportedTeamDropList()
        makeFanImageViewClickable()
        hideKeyboardWhenTappedAround()
        LoaderManager.shared.setUpBallLoader(in: view)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard !isSavingData else { return }
        
        guard let fullName = fanFullName.text, !fullName.isEmpty else {
            showAlert(title: "Full Name Required", message: "Please enter your Name.")
            return
        }
        guard let phoneNumber = fanPhoneNumber.text, !phoneNumber.isEmpty else {
            showAlert(title: "Phone Number Required", message: "Please enter your Phone number.")
            return
        }
        guard let gender = selectedGender, !gender.isEmpty else {
            showAlert(title: "Gender Required", message: "Please select your gender.")
            return
        }
        guard let supportedTeam = selectedSupportedTeam, !supportedTeam.isEmpty else {
            showAlert(title: "Supported Team Required", message: "Please select your favourite team.")
            return
        }
        
        saveFanData()
        
    }
}

extension StepTwoVC {
    func saveFanData() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.5
        view.addSubview(blurEffectView)

        LoaderManager.shared.showBallLoader()
        view.addSubview(LoaderManager.shared.ballLoader)
        
        isSavingData = true
        nextButton.isEnabled = false
        
        guard let image = fanImage.image else {
            showAlert(title: "Error!", message: "No image selected")
            LoaderManager.shared.hideBallLoader()
            blurEffectView.removeFromSuperview()
            isSavingData = false
            nextButton.isEnabled = true
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error!", message: "User not authenticated")
            LoaderManager.shared.hideBallLoader()
            blurEffectView.removeFromSuperview()
            isSavingData = false
            nextButton.isEnabled = true
            return
        }
        
        // Generate a unique image name
        let imageName = UUID().uuidString
        
        // Construct the storage reference
        let storageRef = Storage.storage().reference().child("images/\(imageName).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            // Upload the image data to Firebase Storage
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    LoaderManager.shared.hideBallLoader()
                    blurEffectView.removeFromSuperview()
                    self.isSavingData = false
                    self.nextButton.isEnabled = true
                    return
                }
                
                // Image uploaded successfully, now save the download URL in Firestore
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        if let error = error {
                            print("Error getting download URL: \(error.localizedDescription)")
                        }
                        LoaderManager.shared.hideBallLoader()
                        blurEffectView.removeFromSuperview()
                        self.isSavingData = false
                        self.nextButton.isEnabled = true
                        return
                    }
                    
                    // Add a new document with the user's ID
                    self.db.collection("Fan").document(userID).setData([
                        "fullname": self.fanFullName.text!,
                        "phoneNumber": self.fanPhoneNumber.text!,
                        "gender": self.selectedGender!,
                        "supportedTeam": self.selectedSupportedTeam!,
                        "fanImageURL": downloadURL.absoluteString // Save the download URL
                    ]) { error in
                        if let e = error {
                            print("Error adding document: \(e.localizedDescription)")
                        } else {
                            let stepThreeVC = StepThreeVC(nibName: "StepThreeVC", bundle: nil)
                            self.navigationController?.pushViewController(stepThreeVC, animated: true)
                        }
                        LoaderManager.shared.hideBallLoader()
                        self.isSavingData = false
                        blurEffectView.removeFromSuperview()
                        self.nextButton.isEnabled = true
                    }
                }
            }
        }
    }
}

extension StepTwoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func makeFanImageViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        fanImage.addGestureRecognizer(tapGesture)
        fanImage.isUserInteractionEnabled = true
    }
    
    @objc func imageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("No image selected")
            return
        }
        fanImage.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension StepTwoVC{
    func setUpGenderDropList(){
        fanGender.isSearchEnable = false
        fanGender.optionArray = ["Male","Female"]
        fanGender.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        fanGender.didSelect{(selectedText , index ,id) in
            //print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedGender = selectedText
        }
    }
    
    func setUpSupportedTeamDropList(){
        fanSupportedTeam.isSearchEnable = false
        fanSupportedTeam.optionArray = ["Zamalek", "Ahly"]
        fanSupportedTeam.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        fanSupportedTeam.didSelect{(selectedText , index ,id) in
            //print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedSupportedTeam = selectedText
        }
    }
}

extension StepTwoVC{
    func setUp(){
        nextButton.tintColor = UIColor(red: 87/255, green: 149/255, blue: 154/255, alpha: 1.0)
        nextButton.layer.cornerRadius = 10
        nextButton.layer.masksToBounds = true
        fanImage.makeRounded()
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

// MARK: HIDE KEYBOARD
extension StepTwoVC{
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddMemberVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
