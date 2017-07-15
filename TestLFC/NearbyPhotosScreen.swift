//
//  NearbyPhotosScreen.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 15.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class NearbyPhotosScreen: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseBaseCollectionView()
        // TODO: load images and send it to setFirstModels(_:)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func initialiseBaseCollectionView() {
        super.initialiseBaseCollectionView()
        delegate = self
    }
}

extension NearbyPhotosScreen : BaseCollectionViewControllerProtocol {

    func configure(cell: UICollectionViewCell, withIdentifier identifier: String, and model: PhotoModel, for indexPath: IndexPath) {
        guard identifier == Cell.photo, let cell = cell as? PhotoCollectionCell else { return }
        cell.model = model
    }

    func loadMoreModels(_ completion: ([PhotoModel]) -> Void, in collectionView: UICollectionViewController) {
        // TODO: load photos and send it to completion(_:)
    }

    func didSelect(model: PhotoModel, at indexPath: IndexPath, in collectionView: UICollectionViewController) {
        if let infoPhotoScreen = Storyboards.infoPhoto as? InfoPhotoScreen {
            infoPhotoScreen.model = model
            navigationController?.pushViewController(infoPhotoScreen, animated: true)
        } else {
            log("can't get \(Storyboards.Name.infoPhoto) storyboard")
        }
    }
}
