//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 01.12.2022.
//

import UIKit

class ForecastCell: UITableViewCell {

    static let identifier = String(describing: ForecastCell.self)
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Forecastday) {
        dayLabel.text = getWeekDay(from: model.date)
        temperatureLabel.text = "\(model.day.maxtempC)° / \(model.day.mintempC)°"

    }
    
    private func getWeekDay(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "E"
        let dayOfTheWeekString = dateFormatter.string(from: date)
//        print(dayOfTheWeekString)
        return dayOfTheWeekString
    }
    
    private func makeTextPower(from string: String) -> NSMutableAttributedString {
        let font:UIFont? = UIFont(name: "Helvetica", size: 20)
        let fontSuper: UIFont? = UIFont(name: "Helvetica", size: 10)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: string, attributes: [.font: font!])
        attString.setAttributes([.font: fontSuper!, .baselineOffset:10], range: NSRange(location: string.count - 1, length: 1))
        return attString
    }
    
}
