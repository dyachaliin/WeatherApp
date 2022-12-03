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
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionImage: UIImageView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
        view.showLoadingView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
//        print(latitude)
//        print(longitude)
    }
    
    func setFirstRowSelected() {
        let indexPath = IndexPath(row: 0, section: forecastTableView.numberOfSections - 1)
        forecastTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        forecastTableView.delegate?.tableView?(forecastTableView, didSelectRowAt: indexPath)
    }
    
}

extension MainViewController: MainViewDelegate {
    func updateImage(with data: Data) {
        conditionImage.image = UIImage(data: data)
    }
    
    func updateTableView() {
        forecastTableView.reloadData()
        setFirstRowSelected()
        view.removeLoadingView()
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
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = presenter.weatherModel(at: indexPath.row) else { return }
        currentLocationLabel.text = presenter.location
        dateLabel.text = "\(model.date.getWeekDay().uppercased()), \(model.date.getDate())"
        presenter.getPicture(from: model.day.condition.icon)
        temperatureLabel.text = "\(model.day.maxtempC)° / \(model.day.mintempC)°"
        humidityLabel.text = "\(model.day.avghumidity)%"
        windLabel.text = "\(model.day.maxwindKph)km/h"
        windDirectionImage.image = WindDirection(rawValue: model.hour[model.hour.count / 2].windDir)?.image
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
}
