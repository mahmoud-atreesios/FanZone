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
    case getAllTeams(leagueID: String)
    case getHighlightsData
    
    var stringUrl: URL {
        switch self {
            
        case .getUpcomingFixetures(let id, let from, let to):
            return URL(string: Constants.links.upcomingFixteuresURL + Constants.links.apikey + "&from=\(from)&to=\(to)" + Constants.links.leagueId + "\(id)")!

        case .getAllTeams(let leagueID):
            return URL(string: Constants.links.allTeams + Constants.links.leagueId + "\(leagueID)" + "&APIkey=\(Constants.links.apikey)")!
            
        case .getHighlightsData:
            return URL(string: Constants.links.highlightsURL + Constants.links.highlightsApi)!
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
    
    func sendPostRequest(apiURL: URL, body: [String: Any], completion: @escaping (Swift.Result<Data, Error>) -> Void){
        
        // Serialize the body data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            let serializationError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON"])
            completion(.failure(serializationError))
            return
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                completion(.failure(error as Error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
}
