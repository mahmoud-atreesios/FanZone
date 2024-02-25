//
//  AddMemberVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 25/02/2024.
//

import UIKit
import iOSDropDown
import UniformTypeIdentifiers

class AddMemberVC: UIViewController {
    
    @IBOutlet weak var depImage: UIImageView!
    
    @IBOutlet weak var depName: UITextField!
    @IBOutlet weak var depSSN: UITextField!
    @IBOutlet weak var genderDropList: DropDown!
    
    @IBOutlet weak var birthCertificateImage: UIImageView!
    @IBOutlet weak var addBirthCertificateImageButton: UIButton!
    @IBOutlet weak var addMemberButton: UIButton!
    
    var testImage: UIImage?
    var isUpdatingDepImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        depImage.makeRounded()
        addBirthCertificateImageButton.tintColor = .lightGray
        addMemberButton.tintColor = UIColor(red: 33/255, green: 53/255, blue: 85/255, alpha: 1.0)
        hideKeyboardWhenTappedAround()
        makeDepImageClickable()
        setUpGenderDropList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func addBirthCertificateImageButtonPressed(_ sender: UIButton) {
        //birthCertificateImage.image = testImage ?? UIImage(named: "")
        isUpdatingDepImage = false
        presentImagePicker()
    }
}

extension AddMemberVC{
    func setUpGenderDropList(){
        genderDropList.isSearchEnable = false
        genderDropList.optionArray = ["Male","Female"]
        genderDropList.itemsTintColor = .black
        
        // The the Closure returns Selected Index and String
        genderDropList.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
//            self.selectedBusStation = selectedText
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
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [UTType.image.identifier]
            present(imagePicker, animated: true, completion: nil)
        }
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
