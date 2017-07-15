//
//  NearbyPhotosScreen.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 15.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

fileprivate enum Cell {
    static let photo = "PhotoCollectionCell"
    static let loading = "LoadingCollectionCell"
}

fileprivate struct Settings {
    static let cellSpacing: CGFloat = 2
    static let cellPerLine: CGFloat = 3
    static let lineSpacing: CGFloat = 2
}

final class NearbyPhotosScreen: UICollectionViewController {

    fileprivate var models = [PhotoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        // TODO: load images
    }
}

extension NearbyPhotosScreen : UICollectionViewDelegateFlowLayout {

    func initCollectionView() {
        collectionView?.register(UINib(nibName: Cell.photo, bundle: nil), forCellWithReuseIdentifier: Cell.photo)
        collectionView?.register(UINib(nibName: Cell.loading, bundle: nil), forCellWithReuseIdentifier: Cell.loading)
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < models.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.photo, for: indexPath) as? PhotoCollectionCell else { return UICollectionViewCell() }
            cell.model = models[indexPath.item]
            return cell
        } else {
            // TODO: load more images
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.loading, for: indexPath)
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: open details screen
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Settings.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Settings.lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let allSpacingBetweenCells = Settings.cellSpacing * (Settings.cellPerLine - 1)
        let width = (collectionView.bounds.width - allSpacingBetweenCells) / Settings.cellPerLine
        return CGSize(width: width, height: width)
    }
}
