//
//  GooglePlacesManager.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 05.12.2022.
//

import Foundation
import GooglePlaces
import CoreLocation

struct Place {
    let name: String
    let id: String
}

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PlacesError: Error {
        case failedToFind
        case failedToGetCoordinates
    }
    
    public func findPlaces(
        query: String,
        completion: @escaping (Result<[Place], Error>) -> Void) {
            let filter = GMSAutocompleteFilter()
            filter.type = .geocode
            
            client.findAutocompletePredictions(
                fromQuery: query,
                filter: filter, sessionToken: nil) { (results, error) in
                    guard let results = results, error == nil else {
                        completion(.failure(PlacesError.failedToFind))
                        return }
                    
                    let places: [Place] = results.compactMap({
                        Place(name: $0.attributedFullText.string, id: $0.placeID)
                    })
                    
                    completion(.success(places))
                }
        }
    
    public func resolveLocation(for place: Place, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        client.fetchPlace(
            fromPlaceID: place.id,
            placeFields: .coordinate,
            sessionToken: nil
        ) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToGetCoordinates))
                return
            }
            let googleCoordinate = googlePlace.coordinate
            let coordinate = CLLocationCoordinate2D(latitude: googleCoordinate.latitude, longitude: googleCoordinate.longitude)
            
            completion(.success(coordinate))
        }
    }
}
