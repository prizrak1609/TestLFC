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

    fileprivate var model = TextSearchPhotoModel()
    fileprivate let flickrApi = FlickrApi()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseBaseCollectionView()
        flickrApi.searchPhotos(text: model) { [weak self] result in
            guard let welf = self else { return }
            switch result {
                case .error(let text): showText(text)
                case .success(let model):
                    welf.setFirstModels(model)
                    welf.collectionView?.reloadData()
            }
        }
    }

    override func initialiseBaseCollectionView() {
        super.initialiseBaseCollectionView()
        collectionView?.register(UINib(nibName: cellSearchHeader, bundle: nil),
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: cellSearchHeader)
        delegate = self
    }

    override var prefersStatusBarHidden: Bool {
        return true
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

    func loadMoreModels(_ completion: @escaping ([PhotoModel]) -> Void, in collectionView: UICollectionViewController) {
        model.page += 1
        flickrApi.searchPhotos(text: model) { [weak self] result in
            guard let welf = self else { return }
            switch result {
                case .error(let text): showText(text)
                case .success(let model):
                    completion(model)
                    welf.collectionView?.reloadData()
            }
        }
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
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.text = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        flickrApi.searchPhotos(text: model) { [weak self] result in
            guard let welf = self else { return }
            switch result {
                case .error(let text): showText(text)
                case .success(let model):
                    welf.setFirstModels(model)
                    welf.collectionView?.reloadData()
            }
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}
