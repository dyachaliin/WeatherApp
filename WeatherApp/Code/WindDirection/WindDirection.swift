//
//  WindDirection.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 03.12.2022.
//

import Foundation
import UIKit

enum WindDirection: String {
    case north = "N"
    case northNorthWest = "NNW"
    case northWest = "NW"
    case westNorthWest = "WNW"
    case west = "W"
    case westSouthWest = "WSW"
    case southWest = "SW"
    case southSouthWest = "SSW"
    case south = "S"
    case southSouthEast = "SSE"
    case southEast = "SE"
    case eastSouthEast = "ESE"
    case east = "E"
    case eastNorthEast = "ENE"
    case northEast = "NE"
    case northNorthEast = "NNE"
    
    var image: UIImage {
        switch self {
        case .north:
            return UIImage(named: "icon_wind_n")!
        case .northNorthWest, .northWest, .westNorthWest:
            return UIImage(named: "icon_wind_wn")!
        case .west:
            return UIImage(named: "icon_wind_w")!
        case .westSouthWest, .southWest, .southSouthWest:
            return UIImage(named: "icon_wind_ws")!
        case .south:
            return UIImage(named: "icon_wind_s")!
        case .southSouthEast, .southEast, .eastSouthEast:
            return UIImage(named: "icon_wind_se")!
        case .east:
            return UIImage(named: "icon_wind_e")!
        case .eastNorthEast, .northEast, .northNorthEast:
            return UIImage(named: "icon_wind_ne")!
        }
    }
}
