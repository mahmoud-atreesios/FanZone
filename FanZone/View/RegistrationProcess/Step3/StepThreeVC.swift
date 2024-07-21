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
import CoreML
import Vision

class StepThreeVC: UIViewController {
    
    @IBOutlet weak var fanSsnImage: UIImageView!
    @IBOutlet weak var optionalFanPassportId: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let db = Firestore.firestore()
    var activityIndicator: UIActivityIndicatorView!
    var isSavingData = false
    var modell: ID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        hideKeyboardWhenTappedAround()
        LoaderManager.shared.setUpBallLoader(in: view)
    }
    
    @IBAction func addSsnImageButtonPressed(_ sender: UIButton) {
        presentImageSelectionOptions()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard !isSavingData else { return }
        saveMoreDataToFanCollection()
    }
}


// MARK: - SAVING DATA
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
            showAlert(title: "SSN image required", message: "please add ssn image")
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
        let storageRef = Storage.storage().reference().child("ssnImages/\(imageName).jpg")
        
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
                        "passportID": self.optionalFanPassportId.text == "" ? "null" : self.optionalFanPassportId.text!,
                        "SSNimage": downloadURL.absoluteString,
                        "status":"allowed",
                        "panned_date": "null",
                        "panned_until":"null",
                        "country": "Egypt",
                        "birthDate": "2000-05-30",
                        "ssn":"null"
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

// MARK: - IMAGE PICKER
extension StepThreeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            fanSsnImage.image = selectedImage
            // Process the selected image
            processImage(selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    func presentImageSelectionOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { (_) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        alertController.addAction(choosePhotoAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
                self.showImagePickerController(sourceType: .camera)
            }
            alertController.addAction(takePhotoAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - ML MODEL
extension StepThreeVC{
    func processImage(_ inputImage: UIImage) {
            guard let ciImage = CIImage(image: inputImage) else {
                fatalError("Failed to convert UIImage to CIImage.")
            }
            
            // Resize the image to match the model's input size
            let imageSize = CGSize(width: 256, height: 256)
            guard let resizedCIImage = ciImage.resize(targetSize: imageSize) else {
                fatalError("Failed to resize image.")
            }
            
            // Create a pixel buffer from the resized CIImage
            guard let pixelBuffer = resizedCIImage.pixelBuffer() else {
                fatalError("Failed to create pixel buffer.")
            }
            
            let width = 256
            let height = 256
            let bufferSize = width * height * 3 // RGB channels
            
            // Create MLMultiArray for RGB pixel data
            let batchSize: NSNumber = 1
            let channels: NSNumber = 3
            let inputShape: [NSNumber] = [batchSize, height as NSNumber, width as NSNumber, channels]
            guard let inputMultiArray = try? MLMultiArray(shape: inputShape, dataType: .float32) else {
                fatalError("Error creating MLMultiArray")
            }
            
            // Copy pixel data to MLMultiArray and normalize pixel values
            let dataPointer = inputMultiArray.dataPointer.bindMemory(to: Float32.self, capacity: bufferSize)
            // Create CIContext
            let context = CIContext()
            
            // Render the resized CIImage into the pixelBuffer
            context.render(resizedCIImage, to: pixelBuffer)
            
            // Normalize pixel values to range [0, 1]
            let buffer = unsafeBitCast(pixelBuffer, to: UnsafeMutablePointer<UInt8>.self)
            for i in 0..<bufferSize {
                // Normalize pixel values to range [0, 1]
                dataPointer[i] = Float32(buffer[i]) / 255.0
            }
            
            // Create IDInput instance using the MLMultiArray
            let input = IDInput(conv2d_input: inputMultiArray)
            
            // Make a prediction
            do {
                let output = try modell.prediction(input: input)
                let identityMultiArray = output.Identity
                let identity = identityMultiArray[0].doubleValue // Assuming the result is a single value
                if identity < 0.6 {
                    print("it is a real id: \(identity)")
                } else {
                    print("it is a fake id: \(identity)")
                }
            } catch {
                fatalError("Error making prediction: \(error.localizedDescription)")
            }
        }
}

// MARK: - INTIAL SETUP
extension StepThreeVC{
    func setUp(){
        registerButton.tintColor = UIColor(red: 87/255, green: 149/255, blue: 154/255, alpha: 1.0)
        registerButton.layer.cornerRadius = 10
        registerButton.layer.masksToBounds = true
        do {
            modell = try ID(configuration: MLModelConfiguration())
            print("Model loaded successfully.")
        } catch {
            fatalError("Error loading ML model: \(error.localizedDescription)")
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

// MARK: - HIDE KEYBOARD
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
