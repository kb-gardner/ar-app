//
//  ImageCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/12/22.
//

import Foundation
import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    func setup(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        imageView.kf.setImage(with: url)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
}

extension ImageCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
