//
//  Extensions+String.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 03.12.2022.
//

import Foundation
import UIKit

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
    
    func makeTextPower() -> NSMutableAttributedString {
        let font: UIFont? = UIFont(name: "Helvetica", size: 20)
        let fontSuper: UIFont? = UIFont(name: "Helvetica", size: 10)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: [.font: font!])
        attString.setAttributes([.font: fontSuper!, .baselineOffset: 10], range: NSRange(location: self.count - 2, length: 2))
        return attString
    }
    
    func getTimeFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = dateFormatter.date(from: self) else { return "" }
        
        dateFormatter.dateFormat = "HH"
        let hour = dateFormatter.string(from: date)
        return hour
    }
}
