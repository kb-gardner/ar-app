//
//  AccountViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/7/22.
//

import Foundation
import UIKit

class AccountViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension AccountViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension AccountViewController {
    class func instantiate() -> AccountViewController? {
        let controller = UIStoryboard(name: R.storyboard.accountViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.accountIdentifier()) as? AccountViewController
        return controller
    }
}
