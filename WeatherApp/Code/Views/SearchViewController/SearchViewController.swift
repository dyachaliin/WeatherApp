//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 04.12.2022.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    private let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor(named: "blue")
        
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
       
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        backButton.setImage(UIImage(named: "ic_back.pdf"), for: .normal)
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    @objc func backTapped () {
        navigationController?.popViewController(animated: true)
    }
}
