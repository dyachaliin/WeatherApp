//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 04.12.2022.
//

import UIKit
import CoreLocation
import MapKit

protocol MapViewControllerDelegate: AnyObject {
    func getCoordinates(_ coordinates: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {
    
    weak var delegate: MapViewControllerDelegate?
    var presenter: MapViewPresenterProtocol
    
    private let mapView = MKMapView()
    private var coordinate: CLLocationCoordinate2D?
    
    required init(coordinate: CLLocationCoordinate2D? = nil, presenter: MapViewPresenterProtocol) {
        self.coordinate = coordinate
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        navigationController?.navigationBar.backgroundColor = UIColor(named: "blue")
        view.backgroundColor = UIColor(named: "blue")
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(tapGesture)
        
        setMark()
    }

    @objc func mapViewTapped(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        addPin(at: coordinate)
    }
    
    func addPin(at coordinate: CLLocationCoordinate2D) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordinate

        mapView.addAnnotation(newAnnotation)
        
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    @objc func doneTapped() {
        guard let coordinate = coordinate else { return }
        self.delegate?.getCoordinates(coordinate)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }
    
    func setMark() {
        guard let coordinate = coordinate else { return }
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
    }
}
