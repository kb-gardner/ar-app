//
//  AppRouter.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/28/22.
//

import Foundation
import UIKit

class AppRouter: NSObject {
    private let window: UIWindow!
    static let shared = AppRouter()
    
    override init () {
        guard let window = UIApplication.shared.delegate?.window else { fatalError("Window is not available") }
        self.window = window
        super.init()
        showAppropriateView(animated: false)
    }
    
    func logout() {
        CognitoNetworkingService.logout()
        UserDefaults.isAuth = false
        Store.clear()
        showAppropriateView()
    }
    
    func showAppropriateView(animated: Bool = true) {
        if UserDefaults.isAuth {
            showTabBarMenu()
        } else if UserDefaults.hasAuth {
            showLogin()
        } else {
            showPreview()
        }
    }
    
}

private extension AppRouter {
    func showPreview() {
        guard let controller = PreviewViewController.instantiate(onSuccess: { [weak self] in
            UserDefaults.hasAuth = true
            UserDefaults.isAuth = true
            self?.showTabBarMenu()
        }, onShowLogin: { [weak self] in
            self?.showLogin()
        }) else { fatalError(R.string.localizable.previewFatalError()) }
        let navigation = UINavigationController(rootViewController: controller)
        navigation.isNavigationBarHidden = true
        animateTransition(to: navigation, animated: true)
    }
    
    func showTabBarMenu() {
        guard let controller = MenuTabBarController.instantiate() else { return }
        let navigation = UINavigationController(rootViewController: controller)
        navigation.isNavigationBarHidden = true
        animateTransition(to: navigation, animated: true)
    }
    
    func showLogin() {
        guard let controller = LoginViewController.instantiate(onSuccess: { [weak self] in
            UserDefaults.isAuth = true
            self?.showTabBarMenu()
        }, onShowSignUp: { [weak self] in
            self?.showPreview()
        }) else { return }
        let navigation = UINavigationController(rootViewController: controller)
        navigation.isNavigationBarHidden = true
        animateTransition(to: navigation, animated: true)
    }

    func animateTransition(to controller: UIViewController, animated: Bool) {
        guard let window = window else {
            return
        }
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = controller
            }, completion: { completed in
            })
        } else {
            window.rootViewController = controller
        }
    }
}
