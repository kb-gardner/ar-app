//
//  MenuTabBarController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/7/22.
//

import Foundation
import UIKit
import RealityKit
import SwiftUI

class MenuTabBarController: UITabBarController {
    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let home = HomeViewController.instantiate(),
              let projectList = ProjectListViewController.instantiate(),
              let materialList = MaterialListViewController.instantiate(),
              let account = AccountViewController.instantiate() else { return }
        let homeNav = generateNavigationController(controller: home, title: R.string.localizable.homeTitle(), icon: UIImage())
        let projectListNav = generateNavigationController(controller: projectList, title: R.string.localizable.projectListTitle(), icon: UIImage())
        let materialListNav = generateNavigationController(controller: materialList, title: R.string.localizable.materialListTitle(), icon: UIImage())
        let accountNav = generateNavigationController(controller: account, title: R.string.localizable.accountTitle(), icon: UIImage())
        UINavigationBar.appearance().prefersLargeTitles = true
        viewControllers = [homeNav, projectListNav, materialListNav, accountNav]
        setupScanButton()
    }
}

private extension MenuTabBarController {
    func generateNavigationController(controller: UIViewController, title: String, icon: UIImage) -> UINavigationController {
        controller.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.title = title
        navigationController.tabBarItem.image = R.image.appleIcon()
        return navigationController
    }
    
    func setupScanButton() {
        let button = UIButton(frame: CGRect(x: view.bounds.width / 2 - 30, y: -40, width: 50, height: 50))
        button.layer.cornerRadius = button.bounds.width / 2
        button.setImage(R.image.googleIcon(), for: .normal)
        button.imageView?.layer.cornerRadius = button.bounds.width / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        tabBar.addSubview(button)
        view.layoutIfNeeded()
    }
    
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension MenuTabBarController {
    class func instantiate() -> MenuTabBarController? {
        let controller = UIStoryboard(name: R.storyboard.menuTabBarController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.tabMenuIdentifier()) as? MenuTabBarController
        return controller
    }
}
