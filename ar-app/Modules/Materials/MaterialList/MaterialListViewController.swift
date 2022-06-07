//
//  MaterialListViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/7/22.
//

import Foundation
import UIKit

class MaterialListViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension MaterialListViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension MaterialListViewController {
    class func instantiate() -> MaterialListViewController? {
        let controller = UIStoryboard(name: R.storyboard.materialListViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.materialListIdentifier()) as? MaterialListViewController
        return controller
    }
}
