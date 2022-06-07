//
//  ProjectListViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/7/22.
//

import Foundation
import UIKit

class ProjectListViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension ProjectListViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension ProjectListViewController {
    class func instantiate() -> ProjectListViewController? {
        let controller = UIStoryboard(name: R.storyboard.projectListViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.projectListIdentifier()) as? ProjectListViewController
        return controller
    }
}
