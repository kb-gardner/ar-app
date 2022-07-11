//
//  ProjectSpaceCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/11/22.
//

import Foundation
import UIKit
import Kingfisher

class ProjectSpaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet var spaceImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    func setup(space: Space) {
        if let stringUrl = space.imageUrl, let url = URL(string: stringUrl) {
            spaceImageView.kf.setImage(with: url)
        }
        spaceImageView.layer.cornerRadius = 15
        nameLabel.text = space.name?.titlecased
    }
}
