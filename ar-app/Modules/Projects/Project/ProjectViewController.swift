//
//  ProjectViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 7/1/22.
//

import Foundation
import UIKit

class ProjectViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension ProjectViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension ProjectViewController {
    class func instantiate() -> ProjectViewController? {
        let controller = UIStoryboard(name: R.storyboard.projectViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.projectIdentifier()) as? ProjectViewController
        return controller
    }
}
