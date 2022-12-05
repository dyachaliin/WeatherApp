//
//  Constants.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 02.12.2022.
//

import Foundation

enum Constants {
    static let rowHeight: CGFloat = 60
    static let collectionCellSize: CGSize = CGSize(width: 100, height: 150)
    static let apiKey: String = "AIzaSyBByxovjOz93XkMnjcDr-rJhp8wSrO7YhQ"
    
    static func isAppAlreadyLaunchedOnce() -> Bool{
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}
