//
//  FireBaseViewModel.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 27/06/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class FireBaseViewModel{
    
    private let db = Firestore.firestore()
    
    var loggedInFanData = BehaviorRelay<[String:String]>.init(value: [:])
}

extension FireBaseViewModel {
    func retriveCurrentFanData(userID: String) {
        db.collection("Fan").document(userID).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                if let data = document.data(),
                   let fullname = data["fullname"] as? String,
                   let phoneNumber = data["phoneNumber"] as? String,
                   let gender = data["gender"] as? String,
                   let supportedTeam = data["supportedTeam"] as? String,
                   let fanImageURL = data["fanImageURL"] as? String {
                    
                    let fanData: [String: String] = [
                        "fullname": fullname,
                        "phoneNumber": phoneNumber,
                        "gender": gender,
                        "supportedTeam": supportedTeam,
                        "fanImageURL": fanImageURL
                    ]
                    
                    self.loggedInFanData.accept(fanData)
                    
                } else {
                    print("Document does not exist")
                }
            } else {
                print("Error retrieving document: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

