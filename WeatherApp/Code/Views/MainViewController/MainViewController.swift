//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 30.11.2022.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    private let presenter: MainViewPresenter = MainViewPresenter()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(mainViewDelegate: self)
        
        forecastTableView.register(UINib(nibName: HourlyForecastCell.identifier, bundle: nil), forCellReuseIdentifier: HourlyForecastCell.identifier)
        forecastTableView.register(UINib(nibName: ForecastCell.identifier, bundle: nil), forCellReuseIdentifier: ForecastCell.identifier)
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else { return }
        let longitude = Float(currentLocation.coordinate.longitude)
        let latitude = Float(currentLocation.coordinate.latitude)
        
        presenter.getCoordinates(latitude: latitude, longitude: longitude)
        presenter.obtainWeatherResults()
        print(latitude)
        print(longitude)
    }
    
}

extension MainViewController: MainViewDelegate {
    func updateTableView() {
        forecastTableView.reloadData()
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
}

extension MainViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfWeatherItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as? ForecastCell, let model = presenter.weatherModel(at: indexPath.row) {
            cell.configure(with: model)
            return cell
        }
        return UITableViewCell()
    }
    
}
