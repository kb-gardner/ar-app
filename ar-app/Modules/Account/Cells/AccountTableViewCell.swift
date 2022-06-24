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
    private var onLogout: (()->())?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    @IBAction func buttonClicked(_ sender: Any) {
        onSelect?()
    }
    
    @objc func logoutClicked() {
        onLogout?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup(title: String?, text: String? = nil, buttonType: AccountButtonType? = nil, accountRow: AccountInfoRow? = nil, onSelect: (()->())? = nil, onLogout: (()->())? = nil) {
        self.onSelect = onSelect
        self.onLogout = onLogout
        titleLabel.text = title
        descriptionLabel.text = text
        button.isHidden = buttonType == nil
        button.setImage(buttonType?.image, for: .normal)
        if accountRow == .logout { titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutClicked))) }
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
