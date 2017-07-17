//
//  Result.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 17.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import Foundation

enum Result<T> {
    case error(String)
    case success(T)
}
