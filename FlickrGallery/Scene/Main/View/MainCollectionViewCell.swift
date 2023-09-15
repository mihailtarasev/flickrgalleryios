//
//  MainCollectionViewCell.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 13/9/2023.
//

import Foundation
import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    static let ID = "MainCollectionViewCell"
    
    private var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5

        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cellImageView)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCollectionViewCell{
    func setupConstraint(){
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: topAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellImageView.leftAnchor.constraint(equalTo: leftAnchor),
            cellImageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    func updateCell(url: String){
        cellImageView.loadImage(fromURL: url)
    }
    
    override func prepareForReuse() {
        cellImageView.image = UIImage()
    }
}
