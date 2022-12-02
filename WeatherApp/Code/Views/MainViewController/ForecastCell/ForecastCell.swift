//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 01.12.2022.
//

import UIKit

enum DayTime {
    case day, night
}

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
        getPicture(from: model.day.condition.icon)
        dayLabel.text = getWeekDay(from: model.date)
        temperatureLabel.text = "\(model.day.maxtempC)° / \(model.day.mintempC)°"
    }
    
    func getPicture(from url: String) {
        guard let url = URL(string: "https:\(url)") else { return }
        NetworkManager.shared.obtainPicture(from: url) { data, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() { [weak self] in
                self?.weatherIcon.image = UIImage(data: data)
            }
        }
    }
    
    private func getWeekDay(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "E"
        let dayOfTheWeekString = dateFormatter.string(from: date)
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
