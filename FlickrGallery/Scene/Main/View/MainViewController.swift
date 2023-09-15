//
//  MainViewController.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    private static let searchBarPlaceholder = "Enter text"
    private static let mainAlertTitle = "Alert"
    private static let mainAlertActionTitle = "Close"
    
    var configurator = MainConfiguratorImplementation()
    var mainRouter: MainRouter!
    var viewModel: MainViewModel!
    var collectionViewController: MainCollectionViewController!

    private let navigationItemTitle = "Photos Search"
    private var pageClearedObservableToken: NSKeyValueObservation?
    private var photoListUpdatedObservableToken: NSKeyValueObservation?
    private var isRefreshingObservableToken: NSKeyValueObservation?
    private var isAlertFiredObservableToken: NSKeyValueObservation?
    private let refreshControl = UIRefreshControl()
    private var mainSearchController: UISearchController = {
        let searchBar = UISearchController()
        searchBar.searchBar.placeholder = searchBarPlaceholder
        searchBar.searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    private var mainAlert: UIAlertController = {
        let alert = UIAlertController(title: mainAlertTitle, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: mainAlertActionTitle, style: .default)
        alert.addAction(action)
        return alert
    }()
    private var isOrientationDidChange = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupViews()
        setupObservers()
        uploadFirstPage()
    }
    
    private func configure() {
        configurator.configure(viewController: self)
    }
        
    private func setupViews() {
        setupSearchBar()
        setupRefreshControl()
        setupCollectionView()
    }
    
    private func setupSearchBar() {
        navigationItem.title = navigationItemTitle
        navigationItem.searchController = mainSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        mainSearchController.searchBar.delegate = self
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    }
    
    @objc private func refreshControlAction() {
        viewModel.updateClearedPage()
    }

    private func setupCollectionView() {
        collectionViewController.setMainCollectionViewRefreshControl(refreshControl)
        addCollectionViewToViewHierarchy()
        setupCollectionViewConstraint()
    }
    
    private func addCollectionViewToViewHierarchy() {
        self.view.addSubview(collectionViewController.getMainCollectionView())
    }
    
    private func setupCollectionViewConstraint() {
        let mainCollectionView = collectionViewController.getMainCollectionView()
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupObservers() {
        pageClearedObservableToken = viewModel.observe(\.pageClearedObservable, options: .new) { value, change in
            self.clearCollectionView()
        }
        
        photoListUpdatedObservableToken = viewModel.observe(\.photoListUpdatedObservable, options: .new) { [self] _, change in
            let photoList = change.newValue as? [MainUseCasePhotoModel] ?? []
            self.updateCollectionView(photoList)
        }

        isRefreshingObservableToken = viewModel.observe(\.isEndRefreshingObservable, options: .new) { [self] _, change in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }

        isAlertFiredObservableToken = viewModel.observe(\.isAlertFiredObservable, options: .new) { value, change in
            if let message = change.newValue as? String {
                self.presentMainAlert(message)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChangeNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func orientationDidChangeNotification() {
        isOrientationDidChange = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCollectionViewCountRowsForChangedOrientation()
    }
    
    private func setCollectionViewCountRowsForChangedOrientation() {
        if(!isOrientationDidChange) { return }
        isOrientationDidChange = false
        let size = self.view.bounds.size
        let isLandscape = (size.width > size.height)
        self.collectionViewController.setCountRowsByOrientation(width: size.width, isLandscape: isLandscape)
    }
    
    private func clearCollectionView() {
        self.collectionViewController.updateDataSource([])
        DispatchQueue.main.async {
            self.collectionViewController.reloadCollection()
        }
    }
    
    private func updateCollectionView(_ photoList: [MainUseCasePhotoModel]) {
        collectionViewController.updateDataSource(photoList)
        DispatchQueue.main.async {
            self.collectionViewController.insertItemsToCollection()
            self.collectionViewController.setIsEndLoading()
        }
    }
    
    private func presentMainAlert(_ message: String) {
        DispatchQueue.main.async {
            self.mainAlert.message = message
            self.present(self.mainAlert, animated: true)
        }
    }
    
    private func uploadFirstPage() {
        collectionViewController.startRefreshControlAnimating()
        viewModel.uploadFirstPage()
    }
    
    deinit {
        pageClearedObservableToken?.invalidate()
        photoListUpdatedObservableToken?.invalidate()
        isRefreshingObservableToken?.invalidate()
        isAlertFiredObservableToken?.invalidate()
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

extension MainViewController: MainCollectionViewControllerDelegate {
    func collectionViewUploadNextPage() {
        viewModel.uploadNextAvailablePage()
    }
    
    func collectionViewDidSelectItemAt(imageUrl: String) {
        mainRouter.presentDetailsViewController(with: imageUrl)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.viewModel.setFilterWithDefault(text: text)
        self.viewModel.updateClearedPage()
    }
}
