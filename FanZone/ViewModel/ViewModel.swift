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

    func getUpcomingFixetures(leagueID: String, from: String, to: String){
        ApiClient.shared().getData(modelDTO: UpcomingFixeturesModel.self, .getUpcomingFixetures(id: leagueID, from: from, to: to))
            .subscribe(onNext: { upcomingFixetures in
                //print("Received upcoming Fixetures: \(upcomingFixetures.self)")
                self.upcomingFixeturesModell = upcomingFixetures
                self.upcomingFixeturesResult.accept(upcomingFixetures.result)
            }, onError: { error in
                print("Error fetching Upcoming Fixtures: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func clearUpcomingFixtures() {
        self.upcomingFixeturesResult.accept([])
    }
    
    func getTrendingNewsData() {
        ApiClient.shared().fetchDataFromAPI(modelType: [TrendingNewsModel].self, url: URL(string: Constants.links.trendingNewsURL)!, host: Constants.links.newsHost, apiKey: Constants.links.newsApiKey) { [weak self] result in
            switch result {
            case .success(let newsModels):
                print("dattaaaaaaaa \(newsModels)")
                    self?.trendingNewsDataResult.accept(newsModels)
            case .failure(let error):
                print("Error fetching news data: \(error)")
            }
        }
        print("Fetch data from API called")
    }
    
    func getNewsData() {
        ApiClient.shared().fetchDataFromAPI(modelType: [NewsModel].self, url: URL(string: Constants.links.newsURL)!, host: Constants.links.newsHost, apiKey: Constants.links.newsApiKey) { [weak self] result in
            switch result {
            case .success(let newsModels):
                print("dattaaaaaaaa \(newsModels)")
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
