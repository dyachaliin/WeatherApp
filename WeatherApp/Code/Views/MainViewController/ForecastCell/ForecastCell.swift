//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 01.12.2022.
//

import UIKit

class ForecastCell: UITableViewCell {

    static let identifier = String(describing: ForecastCell.self)
    
//    static func nib() -> UINib {
//        return UINib(nibName: identifier, bundle: nil)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
