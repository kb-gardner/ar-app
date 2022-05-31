//
//  MenuTableViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/31/22.
//

import Foundation
import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(image: UIImage, title: String) {
        titleImageView.image = image
        titleLabel.text = title
    }
}
