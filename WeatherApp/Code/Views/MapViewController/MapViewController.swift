//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 04.12.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    
}
