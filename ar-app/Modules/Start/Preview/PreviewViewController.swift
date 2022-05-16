//
//  PreviewViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet var getStartedButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var previewCollection: UICollectionView!
    
    // MARK: - Actions
    @IBAction func getStartedClicked(_ sender: Any) {
        showSignUp()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        showLogin()
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension PreviewViewController {
    // MARK: - Navigation
    func showSignUp() {}
    func showLogin() {}
}

// MARK: - Instantiation
extension PreviewViewController {
    class func instantiate() -> PreviewViewController {
        let controller = PreviewViewController()
        return controller
    }
}
