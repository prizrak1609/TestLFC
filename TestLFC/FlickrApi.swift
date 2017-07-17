//
//  FlickrApi.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 17.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation
import FlickrKit

final class FlickrApi {

    func searchPhotos(geo model: GeoSearchPhoto, _ completion: @escaping (Result<[PhotoModel]>) -> Void) {
        let photosSearch = FKFlickrPhotosSearch()
        photosSearch.radius = "\(model.radius)"
        photosSearch.lat = "\(model.lat)"
        photosSearch.lon = "\(model.lon)"
        photosSearch.page = "\(model.page)"
        getPhotos(method: photosSearch, completion)
    }

    func searchPhotos(text model: TextSearchPhotoModel, _ completion: @escaping (Result<[PhotoModel]>) -> Void) {
        let photosSearch = FKFlickrPhotosSearch()
        photosSearch.text = model.text
        photosSearch.page = "\(model.page)"
        getPhotos(method: photosSearch, completion)
    }

    fileprivate func getPhotos(method photosSearch: FKFlickrPhotosSearch, _ completion: @escaping (Result<[PhotoModel]>) -> Void) {
        photosSearch.privacy_filter = "1" // public photos
        photosSearch.accuracy = "3" // Country
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FlickrKit.shared().call(photosSearch, maxCacheAge: .oneHour) { response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let error = error {
                completion(.error(error.localizedDescription))
                return
            }
            if let response = response,
                let photosArray = FlickrKit.shared().photoArray(fromResponse: response) {

                let result = photosArray.map { photo -> PhotoModel in
                    let smallPhotoURL = FlickrKit.shared().photoURL(for: .small240, fromPhotoDictionary: photo)
                    let largePhotoURL = FlickrKit.shared().photoURL(for: .large2048, fromPhotoDictionary: photo)
                    let model = PhotoModel(small: smallPhotoURL, large: largePhotoURL)
                    return model
                }
                completion(.success(result))
            }
        }
    }
}
