//
//  StepThreeVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/03/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class StepThreeVC: UIViewController {
    
    @IBOutlet weak var fanSsnImage: UIImageView!
    @IBOutlet weak var optionalFanPassportId: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let db = Firestore.firestore()
    var activityIndicator: UIActivityIndicatorView!
    var isSavingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        hideKeyboardWhenTappedAround()
        LoaderManager.shared.setUpBallLoader(in: view)
    }
    
    @IBAction func addSsnImageButtonPressed(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard !isSavingData else { return }
        saveMoreDataToFanCollection()
    }
}

extension StepThreeVC {
    func saveMoreDataToFanCollection() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.5
        view.addSubview(blurEffectView)

        LoaderManager.shared.showBallLoader()
        view.addSubview(LoaderManager.shared.ballLoader)
        
        registerButton.isEnabled = false
        
        guard let image = fanSsnImage.image else {
            print("No image selected")
            LoaderManager.shared.hideBallLoader()
            isSavingData = false
            registerButton.isEnabled = true
            blurEffectView.removeFromSuperview()
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            LoaderManager.shared.hideBallLoader()
            isSavingData = false
            registerButton.isEnabled = true
            blurEffectView.removeFromSuperview()
            return
        }
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(imageName).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            // Upload the image data to Firebase Storage
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    LoaderManager.shared.hideBallLoader()
                    self.isSavingData = false
                    self.registerButton.isEnabled = true
                    blurEffectView.removeFromSuperview()
                    return
                }
                
                // Image uploaded successfully, now save the download URL in Firestore
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        if let error = error {
                            print("Error getting download URL: \(error.localizedDescription)")
                        }
                        LoaderManager.shared.hideBallLoader()
                        self.isSavingData = false
                        self.registerButton.isEnabled = true
                        blurEffectView.removeFromSuperview()
                        return
                    }
                    
                    // Update the document in Firestore
                    self.db.collection("Fan").document(userID).updateData([
                        "passportID": self.optionalFanPassportId.text ?? "",
                        "SSNimage": downloadURL.absoluteString
                    ]) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            let registrationDoneVC = RegisterationDoneVC(nibName: "RegisterationDoneVC", bundle: nil) 
                            self.navigationController?.pushViewController(registrationDoneVC, animated: true)
                        }
                        LoaderManager.shared.hideBallLoader()
                        self.isSavingData = false
                        self.registerButton.isEnabled = true
                        blurEffectView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

extension StepThreeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("No image selected")
            return
        }
        fanSsnImage.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension StepThreeVC{
    func setUp(){
        registerButton.tintColor = UIColor(red: 87/255, green: 149/255, blue: 154/255, alpha: 1.0)
        registerButton.layer.cornerRadius = 10
        registerButton.layer.masksToBounds = true
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
extension StepThreeVC{
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddMemberVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
