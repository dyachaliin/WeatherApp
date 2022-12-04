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
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            dayLabel.textColor = UIColor(named: "lightBlue")
            temperatureLabel.textColor = UIColor(named: "lightBlue")
            
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowColor = UIColor(named: "lightBlue")?.cgColor
            shadowView.layer.shadowRadius = 3
            shadowView.layer.shadowOpacity = 0.25
            shadowView.layer.masksToBounds = false
            shadowView.clipsToBounds = false
        } else {
            dayLabel.textColor = .black
            temperatureLabel.textColor = .black
            shadowView.layer.shadowRadius = 0
        }
    }
    
    func configure(with model: Forecastday) {
        getPicture(from: model.day.condition.icon)
        dayLabel.text = model.date.getWeekDay().uppercased()
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
    
}
