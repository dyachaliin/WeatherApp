//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 04.12.2022.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: HourlyCollectionViewCell.self)
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: Hour) {
        let hour = model.time.getTimeFromDate()
        hourLabel.attributedText = "\(hour)00".makeTextPower()
        getPicture(from: model.condition.icon)
        temperatureLabel.text = "\(model.tempC)°"
    }
    
    func getPicture(from url: String) {
        guard let url = URL(string: "https:\(url)") else { return }
        NetworkManager.shared.obtainPicture(from: url) { data, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.weatherImage.image = UIImage(data: data)
            }
        }
    }
    
}
