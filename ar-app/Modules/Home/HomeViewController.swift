//
//  HomeViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/24/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension HomeViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension HomeViewController {
    class func instantiate() -> HomeViewController? {
        let controller = UIStoryboard(name: R.storyboard.homeViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.homeIdentifier()) as? HomeViewController
        return controller
    }
}
