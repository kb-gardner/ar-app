//
//  LoginOptionCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/24/22.
//

import Foundation
import UIKit

class LoginOptionTableViewCell: UITableViewCell {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var optionLabel: UILabel!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var centerView: UIView!
    
    func setup(image: UIImage?, text: String, width: CGFloat) {
        guard let image = image else { return }
        roundedView.layer.cornerRadius = 8
        optionLabel.text = text
        logoImageView.image = image
        centerView.frame = CGRect(x: 0, y: 0, width: width, height: contentView.frame.height)
        centerView.center = contentView.center
    }
}
