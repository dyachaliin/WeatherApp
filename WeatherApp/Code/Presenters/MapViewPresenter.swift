//
//  MapViewPresenter.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 06.12.2022.
//

import Foundation
import UIKit

protocol MapViewProtocol: AnyObject {
    var presenter: MapViewPresenterProtocol { get set }
}

protocol MapViewPresenterProtocol: AnyObject {
     var managedView: MapViewProtocol? { get set }
}

class MapViewPresenter: MapViewPresenterProtocol {
    
    weak var managedView: MapViewProtocol?
    
    init() {}
}
