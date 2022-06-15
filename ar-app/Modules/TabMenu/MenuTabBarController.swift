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
        let homeNav = generateNavigationController(controller: home, title: R.string.localizable.homeTitle(), icon: R.image.home(), selectedIcon: R.image.homeActive())
        let projectListNav = generateNavigationController(controller: projectList, title: R.string.localizable.projectListTitle(), icon: R.image.projects(), selectedIcon: R.image.projectsActive())
        let materialListNav = generateNavigationController(controller: materialList, title: R.string.localizable.materialListTitle(), icon: R.image.materials(), selectedIcon: R.image.materialsActive())
        let accountNav = generateNavigationController(controller: account, title: R.string.localizable.accountTitle(), icon: R.image.account(), selectedIcon: R.image.accountActive())
        viewControllers = [homeNav, projectListNav, materialListNav, accountNav]
        setupScanButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UITabBar.appearance().backgroundColor = .white
        tabBar.frame.size.height = 73
        tabBar.frame.origin.y = view.frame.height - 73
        tabBar.items![1].titlePositionAdjustment = UIOffset(horizontal: -20, vertical: 0)
        tabBar.items![2].titlePositionAdjustment = UIOffset(horizontal: 20, vertical: 0)
    }
}

private extension MenuTabBarController {
    func generateNavigationController(controller: UIViewController, title: String, icon: UIImage?, selectedIcon: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.title = title
        navigationController.tabBarItem.image = icon
        navigationController.tabBarItem.selectedImage = selectedIcon
        navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 14, left: 0, bottom: -14, right: 0)
        return navigationController
    }
    
    func setupScanButton() {
        let button = UIButton(frame: CGRect(x: view.bounds.width / 2 - 32.5, y: -32.5, width: 65, height: 65))
        button.layer.cornerRadius = button.bounds.width / 2
        button.setImage(R.image.scanHome(), for: .normal)
        button.imageView?.layer.cornerRadius = button.bounds.width / 2
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.menuScanDropShadow.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
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
