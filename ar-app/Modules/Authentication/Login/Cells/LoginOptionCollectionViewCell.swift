//
//  LoginOptionCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/24/22.
//

import Foundation
import UIKit

class LoginOptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var logoImageView: UIImageView!
    
    func setup(image: UIImage?) {
        guard let image = image else { return }
        logoImageView.image = image
        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
    }
}
