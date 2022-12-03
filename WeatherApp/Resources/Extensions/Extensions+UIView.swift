//
//  Extensions+UIView.swift
//  WeatherApp
//
//  Created by Alina Diachenko on 03.12.2022.
//

import Foundation
import UIKit

extension UIView {
    func showLoadingView() {
        let loadingView = LoadingView(frame: frame)
        self.addSubview(loadingView)
    }

    func removeLoadingView() {
        if let loadingView = subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        }
    }
}
