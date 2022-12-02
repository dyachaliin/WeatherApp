//
//  Extensions+String.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 03.12.2022.
//

import Foundation

extension String {
    func getWeekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "E"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        return dayOfTheWeekString
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "d MMMM"
        let fullDate = dateFormatter.string(from: date)
        return fullDate
    }
}
