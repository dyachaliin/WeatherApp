//
//  MainViewPresenter.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 02.12.2022.
//

import Foundation

protocol MainViewDelegate: NSObjectProtocol {
    func updateTableView()
    func updateImage(with data: Data)
}

class MainViewPresenter {
    
    weak private var mainViewDelegate: MainViewDelegate?
    
    private var latitude: Float?
    private var longitude: Float?
    private(set) var location: String?
    
    private(set) var models = [Forecastday]()
    private(set) var selectedHourlyModels = [Hour]()
    
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
    
    func setHourlyModels(from index: Int) {
        self.selectedHourlyModels = models[index].hour
    }
    
    
    func obtainWeatherResults() {
        guard let latitude = latitude, let longitude = longitude else { return }
        
        do {
            try NetworkManager.shared.obtainWeatherResults(latitude: latitude, longitude: longitude) {[weak self] (result) in
                switch result {
                case .success(let result):
                    let dailyForecasts = result.forecast.forecastday
                    self?.models.append(contentsOf: dailyForecasts)
                    self?.location = result.location.name
                    
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
    
    func getPicture(from url: String) {
        guard let url = URL(string: "https:\(url)") else { return }
        NetworkManager.shared.obtainPicture(from: url) { data, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.mainViewDelegate?.updateImage(with: data)
            }
        }
    }
    
}



