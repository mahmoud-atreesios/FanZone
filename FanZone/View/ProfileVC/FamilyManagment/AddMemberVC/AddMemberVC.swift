//
//  AddMemberVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 25/02/2024.
//

import UIKit
import iOSDropDown
import UniformTypeIdentifiers
import Firebase
import FirebaseStorage
import FirebaseFirestore

class AddMemberVC: UIViewController {
    
    @IBOutlet weak var depImage: UIImageView!
    
    @IBOutlet weak var depName: UITextField!
    @IBOutlet weak var depSSN: UITextField!
    @IBOutlet weak var genderDropList: DropDown!
    
    @IBOutlet weak var birthCertificateImage: UIImageView!
    @IBOutlet weak var addBirthCertificateImageButton: UIButton!
    @IBOutlet weak var addMemberButton: UIButton!
    
    private let db = Firestore.firestore()
    var isUpdatingDepImage = false
    var selectedGender: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        hideKeyboardWhenTappedAround()
        makeDepImageClickable()
        setUpGenderDropList()
        LoaderManager.shared.setUpBallLoader(in: view)
    }
    
    @IBAction func addBirthCertificateImageButtonPressed(_ sender: UIButton) {
        isUpdatingDepImage = false
        presentImagePicker()
    }
    
    
    @IBAction func addMemberButtonPressed(_ sender: UIButton) {
        saveMemberToDataBase()
    }
    
}

//extension AddMemberVC{
//    func generateUniqueString() -> String {
//        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        let randomString = String((0..<9).map{ _ in characters.randomElement()! })
//        return randomString
//    }
//}

extension AddMemberVC{
    func saveMemberToDataBase(){
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.5
        view.addSubview(blurEffectView)

        LoaderManager.shared.showBallLoader()
        view.addSubview(LoaderManager.shared.ballLoader)
        
        //isSavingData = true
        addMemberButton.isEnabled = false
        
       // let depID = generateUniqueString()

        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        guard let depImage = depImage.image else{
            showAlert(title: "Error!", message: "No Member image selected.")
            LoaderManager.shared.hideBallLoader()
            blurEffectView.removeFromSuperview()
            //isSavingData = false
            addMemberButton.isEnabled = true
            return
        }
        
        guard let birthCertificateImage = birthCertificateImage.image else{
            showAlert(title: "Error!", message: "No birth cerftificate image selected.")
            LoaderManager.shared.hideBallLoader()
            blurEffectView.removeFromSuperview()
            //isSavingData = false
            addMemberButton.isEnabled = true
            return
        }
        
        
        guard let depName = depName.text, let depSSN = depSSN.text, let depGender = selectedGender else {
            showAlert(title: "Error", message: "Please complete the form.")
            return
        }
        
        // Construct the storage reference for department image
        let depImageName = UUID().uuidString
        let depImageRef = Storage.storage().reference().child("dependanciesImages/\(depImageName).jpg")
        
        // Construct the storage reference for birth certificate image
        let birthCertificateName = UUID().uuidString
        let birthCertificateImageRef = Storage.storage().reference().child("birthCertificatesImages/\(birthCertificateName).jpg")
        
        // Convert department image to data
        guard let depImageData = depImage.jpegData(compressionQuality: 0.5) else {
            showAlert(title: "Error", message: "Failed to convert Dep image to data.")
            return
        }
        
        // Convert birth certificate image to data
        guard let birthCertificateImageData = birthCertificateImage.jpegData(compressionQuality: 0.5) else {
            showAlert(title: "Error", message: "Failed to convert birth image to data.")
            return
        }
        
        // Upload department image to Firebase Storage
        depImageRef.putData(depImageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading department image: \(error.localizedDescription)")
                LoaderManager.shared.hideBallLoader()
                blurEffectView.removeFromSuperview()
                //self.isSavingData = false
                self.addMemberButton.isEnabled = true
                return
            }
            
            // Department image uploaded successfully, get download URL
            depImageRef.downloadURL { (url, error) in
                guard let depImageURL = url?.absoluteString else {
                    print("Error getting department image URL: \(error?.localizedDescription ?? "")")
                    return
                }
                
                // Upload birth certificate image to Firebase Storage
                birthCertificateImageRef.putData(birthCertificateImageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading birth certificate image: \(error.localizedDescription)")
                        LoaderManager.shared.hideBallLoader()
                        blurEffectView.removeFromSuperview()
                        //self.isSavingData = false
                        self.addMemberButton.isEnabled = true
                        return
                    }
                    
                    // Birth certificate image uploaded successfully, get download URL
                    birthCertificateImageRef.downloadURL { (url, error) in
                        guard let birthCertificateImageURL = url?.absoluteString else {
                            print("Error getting birth certificate image URL: \(error?.localizedDescription ?? "")")
                            return
                        }
                        
                        // Generate a new document reference for the Family_Members
                        let memberRef = self.db.collection("Family_Members").document()
                        // Use the document ID as the depID
                        let depID = memberRef.documentID
                        
                        // Save department image URL, birth certificate image URL, and other data to Firestore
                        let data: [String: Any] = [
                            "userID": userID,
                            "depID": depID,
                            "depName": depName,
                            "depSSN": depSSN,
                            "depGender": depGender,
                            "depImageURL": depImageURL,
                            "birthCertificateImageURL": birthCertificateImageURL,
                            "status": "allowed",
                            "birthDate": "2017-03-20"
                        ]
                        
                        // Set data to Firestore
                        memberRef.setData(data) { error in
                            if let e = error {
                                print("Error adding document: \(e.localizedDescription)")
                            } else {
                                print("Family Member Saved successfully")
                            }
                        }
                    }
                }
            }
            if let tabBarController = self.tabBarController as? TabBar {
                tabBarController.setupTabs()
            }
            LoaderManager.shared.hideBallLoader()
            blurEffectView.removeFromSuperview()
            self.addMemberButton.isEnabled = true
        }
    }
}


// MARK: Setting up the image picker
extension AddMemberVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    func makeDepImageClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(depImageTapped(_:)))
        tapGesture.delegate = self
        depImage.addGestureRecognizer(tapGesture)
        depImage.isUserInteractionEnabled = true
    }
    @objc func depImageTapped(_ sender: UITapGestureRecognizer) {
        isUpdatingDepImage = true
        presentImagePicker()
    }
    
    func presentImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            actionSheet.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if isUpdatingDepImage {
                depImage.image = pickedImage
            } else {
                birthCertificateImage.image = pickedImage
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddMemberVC{
    
    func setupUI(){
        depImage.makeRounded()
        addBirthCertificateImageButton.tintColor = .lightGray
        addMemberButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
    }
    
    func setUpGenderDropList(){
        genderDropList.isSearchEnable = false
        genderDropList.optionArray = ["Male","Female"]
        genderDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        genderDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.selectedGender = selectedText
//            self.selectedBusStation = selectedText
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

// MARK: HIDE KEYBOARD
extension AddMemberVC {
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddMemberVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
