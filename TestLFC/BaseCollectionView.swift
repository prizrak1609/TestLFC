//
//  BaseCollectionView.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 15.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

fileprivate struct Settings {
    static let cellSpacing: CGFloat = 2
    static let cellPerLine: CGFloat = 3
    static let lineSpacing: CGFloat = 2
}

protocol BaseCollectionViewControllerProtocol : class {
    func loadMoreModels(_ completion: @escaping ([PhotoModel]) -> Void, in collectionView: UICollectionViewController)
    func didSelect(model: PhotoModel, at indexPath: IndexPath, in collectionView: UICollectionViewController)
    func configure(cell: UICollectionViewCell, withIdentifier identifier: String, and model: PhotoModel, for indexPath: IndexPath)
}

class BaseCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate var models = [PhotoModel]()

    weak var delegate: BaseCollectionViewControllerProtocol?

    func initialiseBaseCollectionView() {
        collectionView?.register(UINib(nibName: Cell.photo, bundle: nil), forCellWithReuseIdentifier: Cell.photo)
        collectionView?.register(UINib(nibName: Cell.loading, bundle: nil), forCellWithReuseIdentifier: Cell.loading)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
    }

    func setFirstModels(_ models: [PhotoModel]) {
        self.models = models
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < models.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.photo, for: indexPath)
            delegate?.configure(cell: cell, withIdentifier: Cell.photo, and: models[indexPath.item], for: indexPath)
            return cell
        } else {
            delegate?.loadMoreModels({ [weak self] models in
                guard let welf = self else { return }
                welf.models.append(contentsOf: models)
            }, in: self)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.loading, for: indexPath)
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < models.count {
            delegate?.didSelect(model: models[indexPath.item], at: indexPath, in: self)
        }
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
