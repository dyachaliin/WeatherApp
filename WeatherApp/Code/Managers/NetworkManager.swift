//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 01.12.2022.
//

import Foundation

class NetworkManager {
    
    enum ObtainResult {
        case success(result: WeatherResponse?)
        case failure(error: Error)
    }
    
    enum ResultFetchError: Error {
        case invalidUrl
        case unknown
        case parsingError
    }
    
    private let urlSession = URLSession(configuration: .default)
    private let key = "95769e2496a64aa8b38102202220212"
    
    func obtainWeatherResults(latitude: Float, longitude: Float, completion: @escaping (Result<WeatherResponse, Error>) -> Void) throws {
        
        guard let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(key)&q=\(latitude),\(longitude)&days=8") else {
            throw ResultFetchError.invalidUrl
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error == nil, let parseData = data {
                do {
                    let exchange = try JSONDecoder().decode(WeatherResponse.self, from: parseData)
                    DispatchQueue.main.async {
                        completion(.success(exchange))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(ResultFetchError.unknown))
            }
        }.resume()
    }
}
