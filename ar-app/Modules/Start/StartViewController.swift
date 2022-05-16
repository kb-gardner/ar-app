//
//  StartViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userIsAuthenticated() {
            // Home
        } else {
            requestUser()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func userIsAuthenticated() -> Bool {
        return true
    }
    
    // MARK: - Requests
    func requestUser() {
        // if user -> Login else -> Preview
    }
}
