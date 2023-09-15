//
//  MainRouter.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 14/9/2023.
//

import Foundation
import UIKit

protocol MainRouter {
    init(navigationController: UINavigationController)

    func presentDetailsViewController(with imageUrl: String)
}

class MainRouterImplementation: MainRouter {
    private weak var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentDetailsViewController(with imageUrl: String) {
        let detailsViewController = DetailsViewController(imageUrl: imageUrl)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
