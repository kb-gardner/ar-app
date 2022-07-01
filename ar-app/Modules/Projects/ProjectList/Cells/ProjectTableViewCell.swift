//
//  ProjectTableViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/29/22.
//

import Foundation
import UIKit
import Kingfisher

class ProjectTableViewCell: UITableViewCell {
    @IBOutlet var roundedView: UIView!
    @IBOutlet var projectImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var priceEstimateLabel: UILabel!
    
    func setup(imageUrl: String?, name: String?, address: String?, priceEstimate: Double) {
        roundedView.layer.cornerRadius = 15
        projectImageView.layer.cornerRadius = 15
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            projectImageView.kf.setImage(with: url)
        }
        nameLabel.text = name
        addressLabel.text = address
        priceEstimateLabel.text = "$\(priceEstimate)"
    }
}
