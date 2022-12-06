//
//  DependencyInjectionManager.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 06.12.2022.
//

import Foundation
import Swinject

final class DependencyInjectionManager {
    static let shared = DependencyInjectionManager()
    
    private init() {}
    
     var container: Container = {
        let container = Container()
        container.register(DataFetchable.self) { _ in
            return NetworkManager.shared
        }
        container.register(MainViewController.self) { resolver in
            let vc = MainViewController(presenter: MainViewPresenter(dataFetchable: resolver.resolve(DataFetchable.self)))
            return vc
        }
        return container
    }()
}
