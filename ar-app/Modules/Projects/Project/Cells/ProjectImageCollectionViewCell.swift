//
//  ProjectImageCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/11/22.
//

import Foundation
import UIKit
import Kingfisher

class ProjectImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var projectImageView: UIImageView!
    
    func setup(imageUrl: String?) {
        projectImageView.layer.cornerRadius = 15
        guard let stringUrl = imageUrl, let url = URL(string: stringUrl)  else { return }
        projectImageView.kf.setImage(with: url)
    }
}
