//
//  HourlyForecastCell.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 01.12.2022.
//

import UIKit

class HourlyForecastCell: UITableViewCell {
    
    static let identifier = String(describing: HourlyForecastCell.self)
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var models = [Hour]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: HourlyCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with models: [Hour]) {
        self.models = models
        collectionView.reloadData()
    }
    
    func getPicture(from url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: "https:\(url)") else { return }
        NetworkManager.shared.obtainPicture(from: url) { data, error in
            guard let data = data, error == nil else { return }
            completion(data)
        }
    }
    
}

extension HourlyForecastCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.collectionCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        let model = models[indexPath.row]
        
        getPicture(from: model.condition.icon) { data in
            cell.getPicture(from: data)
        }
        
        cell.configure(with: model)
        return cell
    }
}
