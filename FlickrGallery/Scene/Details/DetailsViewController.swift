//
//  DetailsViewController.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 14/9/2023.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    private let navigationItemTitle = "Photo Details"
    private var imageUrl: String
    
    private var detailsImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    private var detailsIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.startAnimating()
        return indicator
    }()
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupView()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = navigationItemTitle
    }

    private func setupView() {
        setupImageView()
        setupIndicator()
    }
    
    private func setupImageView() {
        view.addSubview(detailsImageView)
        detailsImageView.backgroundColor = .white
        detailsImageView.contentMode = .scaleAspectFit
        detailsImageView.clipsToBounds = true
        detailsImageView.frame = self.view.frame
        detailsImageView.loadImage(fromURL: imageUrl, callbackHandler: hideDetailsIndicator)
        setupImageViewConstraints()
    }
    
    func hideDetailsIndicator() {
        detailsIndicator.stopAnimating()
    }
        
    private func setupImageViewConstraints() {
        detailsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsImageView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailsImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailsImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupIndicator() {
        view.addSubview(detailsIndicator)
        setupIndicatorConstraints()
    }
    
    private func setupIndicatorConstraints() {
        detailsIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
