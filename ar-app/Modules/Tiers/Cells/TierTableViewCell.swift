//
//  TierTableViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/28/22.
//

import Foundation
import UIKit

class TierTableViewCell: UITableViewCell {
    @IBOutlet var roundedView: UIView!
    @IBOutlet var recommendedLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tierImageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var billingCycleLabel: UILabel!
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    func setup(title: String?, image: UIImage?, price: Double, billingCycle: String?, summary: String?, isRecommended: Bool) {
        titleLabel.text = title
        tierImageView.image = image
        priceLabel.text = "$\(price)"
        billingCycleLabel.text = "/\(billingCycle ?? "/ MONTH")"
        let lines = summary?.components(separatedBy: "\n") ?? []
        
        if lines.count > 1 {
            label1.text = lines[0]
            label2.text = lines[1]
        }
        if lines.count > 2 {
            label3?.text = lines[2]
            label3.isHidden = false
            priceLabel.isHidden = false
            billingCycleLabel.isHidden = false
        } else {
            label3.isHidden = true
            priceLabel.isHidden = true
            billingCycleLabel.isHidden = true
        }
        
        roundedView.layer.cornerRadius = 15
        roundedView.layer.borderWidth = 2
        roundedView.applyDropShadow(x: 0, y: 3, blur: 6, color: UIColor(hex: "020A2E17").cgColor)
        
        if isRecommended {
            roundedView.layer.borderColor = UIColor(hex: "F29325").cgColor
            recommendedLabel.isHidden = false
        } else {
            roundedView.layer.borderColor = UIColor(hex: "D0D0D0").cgColor
            recommendedLabel.isHidden = true
        }
    }
}
