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
    private var dataFetchable: DataFetchable?
    
    private var latitude: Float?
    private var longitude: Float?
    private(set) var location: String?
    
    private(set) var models = [Forecastday]()
    private(set) var selectedHourlyModels = [Hour]()
    
    init(dataFetchable: DataFetchable?) {
        self.dataFetchable = dataFetchable
    }
    
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
        guard let dataFetchable = dataFetchable, let latitude = latitude, let longitude = longitude else { return }
        
        do {
            try dataFetchable.obtainWeatherResults(latitude: latitude, longitude: longitude) {[weak self] (result) in
                switch result {
                case .success(let result):
                    let dailyForecasts = result.forecast.forecastday
                    self?.models = dailyForecasts
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
    
    func getPicture(from url: String, completion: @escaping (Data) -> Void) {
        guard let dataFetchable = dataFetchable, let url = URL(string: "https:\(url)") else { return }
        dataFetchable.obtainPicture(from: url) { data, error in
            guard let data = data, error == nil else { return }
            completion(data)
        }
    }
}
