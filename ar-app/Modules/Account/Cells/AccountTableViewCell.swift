//
//  AccountTableViewCell.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/22/22.
//

import Foundation
import UIKit

class AccountTableViewCell: UITableViewCell {
    private var onSelect: (()->())?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup(title: String?, text: String? = nil, buttonType: AccountButtonType? = nil, onSelect: (()->())? = nil) {
        self.onSelect = onSelect
        titleLabel.text = title
        descriptionLabel.text = text
        button.isHidden = buttonType == nil
        button.setImage(buttonType?.image, for: .normal)
    }
}

enum AccountButtonType {
    case upgrade, edit
    
    var image: UIImage? {
        switch self {
        case .upgrade:
            return R.image.upArrowOrange()
        case .edit:
            return R.image.addNoteOrange()
        }
    }
}
