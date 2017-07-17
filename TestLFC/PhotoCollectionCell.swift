//
//  PhotoCollectionCell.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 15.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import AlamofireImage

final class PhotoCollectionCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var imageView: UIImageView!

    var model: PhotoModel? {
        didSet {
            guard let model = model else { return }
            imageView.af_setImage(withURL: model.small, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
    }
}
