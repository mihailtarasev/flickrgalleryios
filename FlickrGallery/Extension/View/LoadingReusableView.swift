//
//  LoadingReusableView.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 13/9/2023.
//

import Foundation
import UIKit

class LoadingReusableView: UICollectionReusableView {
    static let ID = "LoadingReusableView"
    
    let activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }
    
    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
