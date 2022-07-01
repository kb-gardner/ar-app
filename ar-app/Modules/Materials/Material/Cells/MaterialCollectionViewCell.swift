//
//  MaterialCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/1/22.
//

import Foundation
import UIKit
import Kingfisher

class MaterialCollectionViewCell: UICollectionViewCell {
    private var onCartClicked: (()->())?
    
    @IBOutlet var materialImageView: UIImageView!
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountTypeLabel: UILabel!
    
    @IBAction func cartClicked(_ sender: Any) {
        onCartClicked?()
    }
    
    func setup(imageUrl: String?, storeName: String?, price: Double, amountType: String?, onCartClicked: (()->())?) {
        contentView.layer.cornerRadius = 15
        self.onCartClicked = onCartClicked
        if let stringUrl = imageUrl, let url = URL(string: stringUrl) {
            materialImageView.kf.setImage(with: url)
        }
        storeNameLabel.text = storeName
        priceLabel.text = "$\(price)"
        if amountType != nil {
            amountTypeLabel.text = "/\(amountType!)"
        }
    }
}
