//
//  TermsViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/18/22.
//

import Foundation
import UIKit

class TermsViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension TermsViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension TermsViewController {
    class func instantiate() -> TermsViewController? {
        let controller = UIStoryboard(name: R.storyboard.termsViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.termsIdentifier()) as? TermsViewController
        return controller
    }
}
