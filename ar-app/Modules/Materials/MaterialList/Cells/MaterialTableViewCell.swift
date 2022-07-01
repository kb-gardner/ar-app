//
//  MaterialTableViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/1/22.
//

import Foundation
import UIKit
import Kingfisher

class MaterialTableViewCell: UITableViewCell {
    @IBOutlet var roundedView: UIView!
    @IBOutlet var materialImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountTypeLabel: UILabel!
    @IBOutlet var storeNameLabel: UILabel!
    
    func setup(imageUrl: String?, name: String?, price: Double, amountType: String?, storeName: String?) {
        roundedView.layer.cornerRadius = 15
        materialImageView.layer.cornerRadius = 15
        if let stringUrl = imageUrl, let url = URL(string: stringUrl) {
            materialImageView.kf.setImage(with: url)
        }
        nameLabel.text = name
        priceLabel.text = "$\(price)"
        if amountType != nil {
            amountTypeLabel.text = "/\(amountType!)"
        }
        storeNameLabel.text = storeName
    }
}
