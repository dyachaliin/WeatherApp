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
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionImage: UIImageView!
    
    private var presenter: MainViewPresenter
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    required init(presenter: MainViewPresenter) {
        self.presenter = presenter
        super.init(nibName: "MainViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        view.showLoadingView()
        presenter.obtainWeatherResults()
    }
    
    func setFirstRowSelected() {
        let indexPath = IndexPath(row: 0, section: forecastTableView.numberOfSections - 1)
        forecastTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        forecastTableView.delegate?.tableView?(forecastTableView, didSelectRowAt: indexPath)
    }
    
    
    @IBAction func toSearchController(_ sender: UIButton) {
        let vc = SearchViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toMapController(_ sender: UIButton) {
        guard let coordinate = currentLocation?.coordinate else { return }
        let vc = MapViewController(coordinate: coordinate, presenter: MapViewPresenter())
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: MainViewDelegate {
    func updateTableView() {
        forecastTableView.reloadData()
        setFirstRowSelected()
        presenter.setHourlyModels(from: 0)
        view.removeLoadingView()
    }
}

extension MainViewController: SearchViewControllerDelegate {
    func getCoordinate(coordinate: CLLocationCoordinate2D) {
        currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.requestWeatherForLocation()
    }
}

extension MainViewController: MapViewControllerDelegate {
    func getCoordinates(_ coordinates: CLLocationCoordinate2D) {
        currentLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.requestWeatherForLocation()
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return presenter.numberOfWeatherItems()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HourlyForecastCell.identifier, for: indexPath) as? HourlyForecastCell {
                cell.configure(with: presenter.selectedHourlyModels)
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as? ForecastCell, let model = presenter.weatherModel(at: indexPath.row) {
                cell.configure(with: model)
                
                presenter.getPicture(from: model.day.condition.icon) { data in
                    cell.getPicture(from: data)
                }
                
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = presenter.weatherModel(at: indexPath.row) else { return }
        
        currentLocationButton.setTitle(presenter.location, for: .normal)
        dateLabel.text = "\(model.date.getWeekDay().uppercased()), \(model.date.getDate())"
        
        presenter.getPicture(from: model.day.condition.icon) { data in
            DispatchQueue.main.async { [weak self] in
                self?.conditionImage.image = UIImage(data: data)
            }
        }
        
        temperatureLabel.text = "\(model.day.maxtempC)?? / \(model.day.mintempC)??"
        humidityLabel.text = "\(model.day.avghumidity)%"
        windLabel.text = "\(model.day.maxwindKph)km/h"
        windDirectionImage.image = WindDirection(rawValue: model.hour[model.hour.count / 2].windDir)?.image
        
        presenter.setHourlyModels(from: indexPath.row)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.collectionCellSize.height
        } else {
            return Constants.rowHeight
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
