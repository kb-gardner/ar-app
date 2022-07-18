//
//  OrderViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/13/22.
//

import Foundation
import UIKit

class OrderViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension OrderViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension OrderViewController {
    class func instantiate() -> OrderViewController? {
        let controller = UIStoryboard(name: R.storyboard.orderViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.orderIdentifier()) as? OrderViewController
        return controller
    }
}
