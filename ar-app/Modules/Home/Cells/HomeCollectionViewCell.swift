//
//  HomeCollectionViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/20/22.
//

import Foundation
import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    private var cellType: CellType?
    
    @IBOutlet var displayImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var cartButton: UIButton!
    @IBOutlet var cellView: UIView!
    @IBOutlet var titleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!
    
    @IBAction func menuClicked(_ sender: Any) {
        switch cellType {
        case .project:
            print("project menu clicked")
        case .space:
            print("space menu clicked")
        default:
            break
        }
    }
    
    @IBAction func cartClicked(_ sender: Any) {
        // add item to cart -> or go to item amount selection -> or go to price comparison -> or go to store website
    }
    
    func setup(cellType: CellType, imageUrl: String?, title: String?, subtitle: String?) {
        guard let stringUrl = imageUrl, let url = URL(string: stringUrl) else { return }
        self.cellType = cellType
        displayImageView.kf.setImage(with: url)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        menuButton.isHidden = cellType == .material
        cartButton.isHidden = cellType != .material
        titleTrailingConstraint.isActive = cellType != .material
        titleLeadingConstraint.constant = cellType == .project ? 13 : cellType == .space ? 10 : 7
        imageHeightConstraint.constant = cellType == .project ? 10 : cellType == .space ? 5 : 0
        cellView.layer.cornerRadius = 15
        layoutIfNeeded()
    }
    
    enum CellType {
        case project, space, material
    }
    
}
