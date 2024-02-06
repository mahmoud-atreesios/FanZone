//
//  ApiManager.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/02/2024.
//

import Foundation
import RxSwift

protocol fetchData {
    func getData<T: Decodable>(modelDTO: T.Type, _ endpoint: Endpoints, attributes: [String: String]?) -> Observable<T>
}

enum Endpoints {
    
    case getUpcomingFixetures(id: String, from: String, to: String)
    
    var stringUrl: URL {
        switch self {
            
        case .getUpcomingFixetures(let id, let from, let to):
            return URL(string: Constants.links.upcomingFixteuresURL + Constants.links.apikey + "&from=\(from)&to=\(to)" + Constants.links.leagueId + "\(id)")!

        }
    }
}

class ApiClient {
    private static let sharedInstance = ApiClient()

    static func shared() -> ApiClient {
        return ApiClient.sharedInstance
    }

    private init() {}

    func getData<T>(modelDTO: T.Type, _ endpoint: Endpoints) -> Observable<T> where T: Decodable {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: endpoint.stringUrl) { data, _, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    do {
                        let exchangeRate = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(exchangeRate)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
