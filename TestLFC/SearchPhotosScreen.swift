//
//  SearchPhotosScreen.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 15.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

fileprivate let cellSearchHeader = "HeaderSearchView"

final class SearchPhotosScreen: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseBaseCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func initialiseBaseCollectionView() {
        super.initialiseBaseCollectionView()
        collectionView?.register(UINib(nibName: cellSearchHeader, bundle: nil),
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: cellSearchHeader)
        delegate = self
    }
}

extension SearchPhotosScreen : BaseCollectionViewControllerProtocol {

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader,
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                       withReuseIdentifier: cellSearchHeader,
                                                                       for: indexPath) as? HeaderSearchView {

            cell.searchBar.delegate = self
            return cell
        }
        return UICollectionReusableView()
    }

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

extension SearchPhotosScreen : UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: get photos and send it to setFirstModels(_:)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}
