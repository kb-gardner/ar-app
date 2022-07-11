//
//  ProjectMaterialCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/11/22.
//

import Foundation
import UIKit
import Kingfisher

class ProjectMaterialCollectionViewCell: UICollectionViewCell {
    @IBOutlet var materialImageView: UIImageView!
    
    func setup(imageUrl: String?) {
        contentView.layer.cornerRadius = 15
        guard let stringUrl = imageUrl, let url = URL(string: stringUrl)  else { return }
        materialImageView.kf.setImage(with: url)
    }
}
