//
//  ViewModel.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 02/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel{
    private let disposeBag = DisposeBag()

    var upcomingFixeturesModell: UpcomingFixeturesModel?
    var upcomingFixeturesResult = BehaviorRelay<[UpcomingFixetures]>.init(value: [])
    
    var trendingNewsDataResult = BehaviorRelay<TrendingNewsModels>.init(value: [])
    var newsDataResult = BehaviorRelay<NewsModels>.init(value: [])
    
    var highlightsModel: HighlightsModel?
    var highlightsResult = BehaviorRelay<[HighlightResponse]>.init(value: [])
    
    var teamsModel: AllTeamsModel?
    var teamsResult = BehaviorRelay<[Teams]>.init(value: [])

}

// MARK: - Fixtures
extension ViewModel{
    func getUpcomingFixetures(leagueID: String, from: String, to: String){
        ApiClient.shared().getData(modelDTO: UpcomingFixeturesModel.self, .getUpcomingFixetures(id: leagueID, from: from, to: to))
            .subscribe(onNext: { upcomingFixetures in
                self.upcomingFixeturesModell = upcomingFixetures
                self.upcomingFixeturesResult.accept(upcomingFixetures.result)
            }, onError: { error in
                print("Error fetching Upcoming Fixtures: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func getAllTeams(leagueID: String){
        ApiClient.shared().getData(modelDTO: AllTeamsModel.self, .getAllTeams(leagueID: leagueID))
            .subscribe(onNext: { allTeams in
                print("All Teams Data:", allTeams)
                self.teamsModel = allTeams
                self.teamsResult.accept(allTeams.result)
            }, onError: { error in
                print("Error fetching Upcoming Fixtures: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func clearUpcomingFixtures(){
        self.upcomingFixeturesResult.accept([])
    }
}


// MARK: - News Data
extension ViewModel{
    func getTrendingNewsData(){
        ApiClient.shared().fetchDataFromAPI(modelType: [TrendingNewsModel].self, url: URL(string: Constants.links.trendingNewsURL)!, host: Constants.links.newsHost, apiKey: Constants.links.newsApiKey) { [weak self] result in
            switch result {
            case .success(let newsModels):
                //print("dattaaaaaaaa \(newsModels)")
                    self?.trendingNewsDataResult.accept(newsModels)
            case .failure(let error):
                print("Error fetching news data: \(error)")
            }
        }
        print("Fetch data from API called")
    }
    
    func getNewsData(){
        ApiClient.shared().fetchDataFromAPI(modelType: [NewsModel].self, url: URL(string: Constants.links.newsURL)!, host: Constants.links.newsHost, apiKey: Constants.links.newsApiKey) { [weak self] result in
            switch result {
            case .success(let newsModels):
                //print("dattaaaaaaaa \(newsModels)")
                DispatchQueue.main.async {
                    self?.newsDataResult.accept(newsModels)
                }
            case .failure(let error):
                print("Error fetching news data: \(error)")
            }
        }
        print("Fetch data from API called")
    }
}

// MARK: - Highlight Data
extension ViewModel{
    func getHighlightsData(){
        ApiClient.shared().getData(modelDTO: HighlightsModel.self, .getHighlightsData)
            .subscribe { highlights in
               // print("Highlights Data Received \(highlights.self)")
                self.highlightsModel = highlights
                self.highlightsResult.accept(highlights.response)
            } onError: { error in
                print("Error fetching Highlights Data: \(error)")
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Payment
extension ViewModel {
    func getFirstToken(completion: @escaping (String?) -> Void) {
        ApiClient.shared().sendPostRequest(apiURL: URL(string: Constants.links.firstTokenUrl)!, body: Constants.links.firstTokenBody) { result in
            switch result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let accessToken = json["token"] as? String {
                        completion(accessToken)
                    } else {
                        completion(nil)
                        print("Failed to extract token from the response")
                    }
                } catch {
                    completion(nil)
                    print("Error parsing JSON:", error.localizedDescription)
                }
            case .failure(let error):
                completion(nil)
                print("Error:", error.localizedDescription)
            }
        }
    }
    
    func getOrderId(firstToken: String, completion: @escaping (String?) -> Void){
        
        let body: [String: Any] = [
            "auth_token": "\(firstToken)",
            "delivery_needed": "false",
            "amount_cents": "10000",
            "currency": "EGP",
            "items": Constants.links.orderIditems
        ]
        
        ApiClient.shared().sendPostRequest(apiURL: URL(string: Constants.links.orderIdUrl)!, body: body) { result in
            switch result {
            case .success(let data):
                // Handle successful response (data contains the response data)
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let orderId = json["id"] as? Int {
                        completion(String(orderId))
                    } else {
                        completion(nil)
                        print("Unable to extract order ID from the response")
                    }
                } catch {
                    completion(nil)
                    print("Error parsing JSON:", error.localizedDescription)
                }
            case .failure(let error):
                completion(nil)
                print("Error:", error.localizedDescription)
            }
        }
    }
    
    func getPaymentToken(firstToken: String, orderId: String, totalPrice: String, completion: @escaping (String?) -> Void){
        
        let body: [String: Any] = [
            "auth_token": "\(firstToken)",
            "amount_cents": "\(totalPrice)",
            "expiration": 3600,
            "order_id": "\(orderId)",
            "billing_data": Constants.links.billingData,
            "currency": "EGP",
            "integration_id": 4283915,
            "lock_order_when_paid": "false",
        ]
        
        ApiClient.shared().sendPostRequest(apiURL: URL(string: Constants.links.paymentTokenUrl)!, body: body) { result in
            switch result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let paymentToken = json["token"] as? String {
                        //print("Token:", paymentToken)
                        completion(paymentToken)
                    } else {
                        completion(nil)
                        print("Failed to extract token from the response")
                    }
                } catch {
                    completion(nil)
                    print("Error parsing JSON:", error.localizedDescription)
                }
            case .failure(let error):
                completion(nil)
                print("Error:", error.localizedDescription)
            }
        }
    }
}

