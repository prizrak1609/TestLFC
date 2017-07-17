//
//  InfoPhotoScreen.swift
//  TestLFC
//
//  Created by Dima Gubatenko on 15.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

final class InfoPhotoScreen : UIViewController {
    @IBOutlet fileprivate weak var scrollView: UIScrollView!

    fileprivate var imageView: UIImageView?

    var model: PhotoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        initImageView()
        initScrollView()
        guard let model = model else { return }
        imageView?.af_setImage(withURL: model.large)
    }
}

extension InfoPhotoScreen {

    func initImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height))
        imageView?.contentMode = .scaleAspectFit
    }
}

extension InfoPhotoScreen : UIScrollViewDelegate {

    func initScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
