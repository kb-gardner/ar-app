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
    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.requestUser()
        }
    }
}

private extension StartViewController {
    // MARK: - Navigation
    func showPreview() {
        guard let controller = PreviewViewController.instantiate(onSuccess: { [weak self] in
            self?.showTabBarMenu()
        }, onShowLogin: { [weak self] in
            self?.showLogin()
        }) else { fatalError(R.string.localizable.previewFatalError()) }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showHome() {
        guard let controller = HomeViewController.instantiate() else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showTabBarMenu() {
        guard let controller = MenuTabBarController.instantiate() else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showLogin() {
        guard let controller = LoginViewController.instantiate(onSuccess: { [weak self] in
            self?.showTabBarMenu()
        }, onShowSignUp: { [weak self] in
            self?.showPreview()
        }) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Requests
    func requestUser() {
        CognitoNetworkingService.initSession { [weak self] error in
            DispatchQueue.main.async {
                if let id = AWSMobileClient.default().userSub {
                    UserNetworkingService.getUser(id: id) { user, error in
                        if let error = error {
                            print(error)
                            AWSMobileClient.default().signOut()
                            self?.showPreview()
                        } else {
                            Store.shared.user = user
                            if AWSMobileClient.default().isSignedIn {
                                self?.showTabBarMenu()
                            } else {
                                self?.showLogin()
                            }
                        }
                    }
                } else if let _ = AWSMobileClient.default().username {
                    AWSMobileClient.default().signOut()
                    self?.showLogin()
                } else {
                    AWSMobileClient.default().signOut()
                    self?.showPreview()
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
