//
//  StartViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import UIKit
import AWSMobileClient

class StartViewController: UIViewController {
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension StartViewController {
    // MARK: - Navigation
    func showPreview() {
        guard let controller = PreviewViewController.instantiate(onLogin: { [weak self] in
            self?.showHome()
        }) else { fatalError(R.string.localizable.previewFatalError()) }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showHome() {}
    
    func showLogin() {
        guard let controller = LoginViewController.instantiate(onLogin: { [weak self] in
            self?.showHome()
        }, onSignUp: { [weak self] in
            self?.showPreview()
        }) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Requests
    func requestUser() {
        guard let id = AWSMobileClient.default().username else {
            showPreview()
            return
        }
        UserNetworkingService.getUserByCognitoId(id: id) { [weak self] user, error in
            if let error = error {
                print(error)
                self?.showPreview()
            } else {
                Store.shared.user = user
                if AWSMobileClient.default().isSignedIn {
                    self?.showHome()
                } else {
                    self?.showLogin()
                }
            }
        }
    }
}

// MARK: - Instantiation
extension StartViewController {
    class func instantiate() -> StartViewController? {
        let controller = UIStoryboard(name: R.storyboard.startViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.storyboard.startViewController.name) as? StartViewController
        return controller
    }
}
