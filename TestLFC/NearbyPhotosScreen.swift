//
//  NearbyPhotosScreen.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 15.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import CoreLocation

final class NearbyPhotosScreen: BaseCollectionViewController {

    fileprivate let locationManager = CLLocationManager()
    fileprivate var model = GeoSearchPhoto()
    fileprivate let flickrApi = FlickrApi()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseBaseCollectionView()
        initLocationManager()
    }

    override func initialiseBaseCollectionView() {
        super.initialiseBaseCollectionView()
        delegate = self
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension NearbyPhotosScreen : CLLocationManagerDelegate {

    func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showText(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coords = locations.last?.coordinate, coords.latitude != 0, coords.longitude != 0 else { return }
        model.lat = coords.latitude
        model.lon = coords.longitude
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        flickrApi.searchPhotos(geo: model) { [weak self] result in
            guard let welf = self else { return }
            switch result {
                case .error(let text): showText(text)
                case .success(let model):
                    welf.setFirstModels(model)
                    welf.collectionView?.reloadData()
            }
        }
    }
}

extension NearbyPhotosScreen : BaseCollectionViewControllerProtocol {

    func configure(cell: UICollectionViewCell, withIdentifier identifier: String, and model: PhotoModel, for indexPath: IndexPath) {
        guard identifier == Cell.photo, let cell = cell as? PhotoCollectionCell else { return }
        cell.model = model
    }

    func loadMoreModels(_ completion: @escaping ([PhotoModel]) -> Void, in collectionView: UICollectionViewController) {
        model.page += 1
        flickrApi.searchPhotos(geo: model) { [weak self] result in
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
