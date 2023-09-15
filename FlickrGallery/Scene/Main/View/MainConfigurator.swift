//
//  MainConfigurator.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 14/9/2023.
//

import Foundation

protocol MainConfigurator {
    func configure(viewController: MainViewController)
}

class MainConfiguratorImplementation: MainConfigurator {
    
    func configure(viewController: MainViewController) {
        let navigationController = viewController.navigationController!
        let mainRouter = MainRouterImplementation(navigationController: navigationController)
        let viewModel = MainViewModel()
        let collectionViewController = MainCollectionViewController()
        viewController.mainRouter = mainRouter
        viewController.viewModel = viewModel
        viewController.collectionViewController = collectionViewController
    }
}
