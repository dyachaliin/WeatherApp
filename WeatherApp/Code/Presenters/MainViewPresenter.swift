//
//  MainViewPresenter.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 02.12.2022.
//

import Foundation

protocol MainViewDelegate: NSObjectProtocol {
    func updateTableView()
}

class MainViewPresenter {
    
    weak private var mainViewDelegate: MainViewDelegate?
    
    private var latitude: Float?
    private var longitude: Float?
    private(set) var models = [Forecastday]()
    
    func setViewDelegate(mainViewDelegate: MainViewDelegate?){
        self.mainViewDelegate = mainViewDelegate
    }
    
    func numberOfWeatherItems() -> Int {
        return models.count
    }
    
    func weatherModel(at index: Int) -> Forecastday? {
        return models[index]
    }
    
    func getCoordinates(latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
   
    func obtainWeatherResults() {
        guard let latitude = latitude, let longitude = longitude else { return }
        
        do {
            try NetworkManager.shared.obtainWeatherResults(latitude: latitude, longitude: longitude) {[weak self] (result) in
                switch result {
                case .success(let result):
                    let dailyForecasts = result.forecast.forecastday
                    self?.models.append(contentsOf: dailyForecasts)
                    
                    DispatchQueue.main.async {
                        self?.mainViewDelegate?.updateTableView()
                    }
                   
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


