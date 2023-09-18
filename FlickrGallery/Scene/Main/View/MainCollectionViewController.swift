//
//  MainCollectionViewController.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 14/9/2023.
//

import Foundation
import UIKit

class MainCollectionViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private static let layoutFooterReferenceSize: CGFloat = 50
    private static let portraitCountRows: CGFloat = 3
    private static let landscapeCountRows: CGFloat = 4
    private static let itemMargin: CGFloat = 10
    
    private weak var delegate: MainCollectionViewControllerDelegate?
    private var isLoading = true
    private var oldSizePhotoList = 0
    private var photoList = Array<MainPhotoModel>()
    private var loadingView: LoadingReusableView?
    private var mainCollectionViewFlowLayout: UICollectionViewFlowLayout
    private var mainCollectionView: UICollectionView
    
    init(delegate: MainCollectionViewControllerDelegate?) {
        self.delegate = delegate
        self.mainCollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.mainCollectionViewFlowLayout)
        super.init()
        setupCollectionview()
    }
    
    private func setupCollectionview() {
        setupMainCollectionViewFlowLayout()
        setupMainCollectionView()
    }
    
    private func setupMainCollectionViewFlowLayout() {
        let layoutFooterReferenceSize = MainCollectionViewController.layoutFooterReferenceSize
        self.mainCollectionViewFlowLayout.footerReferenceSize = CGSize(width: layoutFooterReferenceSize, height: layoutFooterReferenceSize)
        self.mainCollectionViewFlowLayout.scrollDirection = .vertical
    }
    
    private func setupMainCollectionView() {
        self.mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.ID)
        self.mainCollectionView.register(LoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingReusableView.ID)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }
    
    func getMainCollectionView() -> UICollectionView {
        return mainCollectionView
    }
    
    func setMainCollectionViewRefreshControl(_ refreshControl: UIRefreshControl){
        return mainCollectionView.refreshControl = refreshControl
    }
            
    func reloadCollection() {
        mainCollectionView.reloadData()
    }
    
    func startRefreshControlAnimating() {
        mainCollectionView.refreshControl?.beginRefreshing()
        mainCollectionView.contentOffset = CGPointMake(0, mainCollectionView.refreshControl!.bounds.size.height  * -1)
    }

    func updateDataSource(_ photoList: Array<MainPhotoModel>) {
        oldSizePhotoList = self.photoList.count
        self.photoList = photoList
    }
    
    func setIsEndLoading() {
        self.isLoading = false
    }
        
    func insertItemsToCollection() {
        let startIndex = oldSizePhotoList
        let endIndex = photoList.count
        let paths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        self.mainCollectionView.insertItems(at: paths)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.ID, for: indexPath) as? MainCollectionViewCell {
            let imageUrl = photoList[indexPath.row].smallImageUrl
            myCell.updateCell(url: imageUrl)
            return myCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let largeImageUrl = photoList[indexPath.row].largeImageUrl
        delegate?.collectionViewDidSelectItemAt(imageUrl: largeImageUrl)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: MainCollectionViewController.layoutFooterReferenceSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionFooter {
                if let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingReusableView.ID, for: indexPath) as? LoadingReusableView {
                    loadingView = aFooterView
                    loadingView?.backgroundColor = UIColor.clear
                    return aFooterView
                }
            }
            return UICollectionReusableView()
        }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
            if elementKind == UICollectionView.elementKindSectionFooter {
                if(photoList.count > 0) {
                    self.loadingView?.activityIndicator.startAnimating()
                }
            }
        }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photoList.count - 1 {
            uploadNextPage()
        }
    }
    
    private func uploadNextPage() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                self.delegate?.collectionViewUploadNextPage()
            }
        }
    }
}

extension MainCollectionViewController {
    // Change count items in Collection by Screen Orientation
    func setCountRowsByOrientation(width: CGFloat, isLandscape: Bool) {
        if(isLandscape) {
            setLandscapeCountRows(width)
        }else {
            setPortraitCountRows(width)
        }
    }
    
    private func setPortraitCountRows(_ width: CGFloat) {
        let layoutCountRows = MainCollectionViewController.portraitCountRows
        updateMainCollectionViewFlowLayout(width: width, layoutCountRows: layoutCountRows)
    }
    
    private func setLandscapeCountRows(_ width: CGFloat) {
        let layoutCountRows = MainCollectionViewController.landscapeCountRows
        updateMainCollectionViewFlowLayout(width: width, layoutCountRows: layoutCountRows)
    }
    
    private func updateMainCollectionViewFlowLayout(width: CGFloat, layoutCountRows: CGFloat) {
        let layoutItemSize = width / layoutCountRows - MainCollectionViewController.itemMargin
        mainCollectionViewFlowLayout.itemSize = CGSize(width: layoutItemSize, height: layoutItemSize)
    }
}
