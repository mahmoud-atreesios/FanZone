//
//  ApiManager.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 05/02/2024.
//

import Foundation
import RxSwift

protocol fetchData {
    func fetchDataFromAPI<T: Decodable>(modelType: T.Type, url: URL, host: String, apiKey: String, completion: @escaping (Result<T, Error>) -> Void)
    func getData<T: Decodable>(modelDTO: T.Type, _ endpoint: Endpoints) -> Observable<T>
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

class ApiClient: fetchData {
    
    private static let sharedInstance = ApiClient()

    static func shared() -> ApiClient {
        return ApiClient.sharedInstance
    }

    private init() {}

    func fetchDataFromAPI<T>(modelType: T.Type, url: URL, host: String, apiKey: String, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let headers = [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": host
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP status code: \(httpResponse.statusCode)")
                let statusCodeError = NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(statusCodeError))
                return
            }
            
            guard let data = data else {
                print("No data received")
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Error decoding data: \(error)")
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }


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
