//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 04.12.2022.
//

import Foundation
import UIKit
import CoreLocation

protocol SearchViewControllerDelegate: AnyObject {
    func getCoordinate(coordinate: CLLocationCoordinate2D)
}

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    private let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    weak var delegate: SearchViewControllerDelegate?
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.backgroundColor = UIColor(named: "blue")
        navigationController?.navigationBar.backgroundColor = UIColor(named: "blue")
        
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
        setupSearchBar()
        setBackButton()
        
        addConstraints()
    }
    
    func setupSearchBar() {
        searchVC.searchBar.tintColor = .white
        searchVC.searchBar.setImage(UIImage(), for: .search, state: .normal)
    }
    
    func setBackButton() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        backButton.setImage(UIImage(named: "ic_back.pdf"), for: .normal)
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, let resultVC = searchController.searchResultsController as? ResultsViewController else { return }
        
        resultVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    resultVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func backTapped () {
        navigationController?.popViewController(animated: true)
    }
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        let guide = view.safeAreaLayoutGuide
        
        constraints.append(contentView.topAnchor.constraint(equalTo: guide.topAnchor))
        constraints.append(contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(contentView.leadingAnchor.constraint(equalTo: guide.leadingAnchor))
        constraints.append(contentView.trailingAnchor.constraint(equalTo: guide.trailingAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension SearchViewController: ResultsViewControllerDelegate {
    func didTapPlace(with coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async { [weak self] in
            self?.searchVC.dismiss(animated: false, completion: {
                self?.delegate?.getCoordinate(coordinate: coordinate)
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
}
