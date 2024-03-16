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
        setupActivityIndicator()
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

extension StepThreeVC{
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
}

extension StepThreeVC{
    func saveMoreDataToFanCollection(){
        activityIndicator.startAnimating()
        isSavingData = true
        registerButton.isEnabled = false
        
        guard let image = fanSsnImage.image else {
            print("No image selected")
            self.activityIndicator.stopAnimating()
            self.isSavingData = false
            registerButton.isEnabled = true
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            self.activityIndicator.stopAnimating()
            self.isSavingData = false
            registerButton.isEnabled = true
            return
        }
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(imageName).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            // Upload the image data to Firebase Storage
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    self.activityIndicator.stopAnimating()
                    self.isSavingData = false
                    self.registerButton.isEnabled = true
                    return
                }
                
                // Image uploaded successfully, now save the download URL in Firestore
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        if let error = error {
                            self.activityIndicator.stopAnimating()
                            self.isSavingData = false
                            self.registerButton.isEnabled = true
                            print("Error getting download URL: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    self.db.collection("Fan").document(userID).updateData([
                        "passportID": self.optionalFanPassportId.text ?? "",
                        "SSNimage": downloadURL.absoluteString
                    ]) { error in
                        if let error = error {
                            self.activityIndicator.stopAnimating()
                            self.isSavingData = false
                            self.registerButton.isEnabled = true
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.isSavingData = false
                            
                            let RegisterationDoneVC = RegisterationDoneVC(nibName: "RegisterationDoneVC", bundle: nil)
                            self.navigationController?.pushViewController(RegisterationDoneVC, animated: true)
                        }
                        self.registerButton.isEnabled = true
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
