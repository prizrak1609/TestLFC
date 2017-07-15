//
//  HeaderReusableView.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 15.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class HeaderSearchView: UICollectionReusableView {
    // disable because search bar in collection view only can be in header or footer view
    // and this view live only for search bar and no need to set any models
    // swiftlint:disable:next private_outlet
    @IBOutlet weak var searchBar: UISearchBar!
}
