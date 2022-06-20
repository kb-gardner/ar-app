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
    @IBOutlet var customTabBar: CustomTabBar!
    
    // MARK: - Actions
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let home = HomeViewController.instantiate(),
              let projectList = ProjectListViewController.instantiate(),
              let materialList = MaterialListViewController.instantiate(),
              let account = AccountViewController.instantiate() else { return }
        let homeNav = generateNavigationController(controller: home, title: R.string.localizable.homeTitle(), icon: R.image.home(), selectedIcon: R.image.homeActive(), 0)
        let projectListNav = generateNavigationController(controller: projectList, title: R.string.localizable.projectListTitle(), icon: R.image.projects(), selectedIcon: R.image.projectsActive(), -20)
        let materialListNav = generateNavigationController(controller: materialList, title: R.string.localizable.materialListTitle(), icon: R.image.materials(), selectedIcon: R.image.materialsActive(), 20)
        let accountNav = generateNavigationController(controller: account, title: R.string.localizable.accountTitle(), icon: R.image.account(), selectedIcon: R.image.accountActive(), 0)
        viewControllers = [homeNav, projectListNav, materialListNav, accountNav]
        customTabBar.frame.size.height = 73
        customTabBar.frame.origin.y = view.frame.height - 73
        setupScanButton()
    }
}

private extension MenuTabBarController {
    func generateNavigationController(controller: UIViewController, title: String, icon: UIImage?, selectedIcon: UIImage?, _ horizontalShift: CGFloat) -> UINavigationController {
        controller.tabBarItem = UITabBarItem(title: nil,
                                             image: icon?.addTitleBelow(text: title, false),
                                             selectedImage: selectedIcon?.addTitleBelow(text: title, true))
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 14, left: horizontalShift, bottom: -14, right: -horizontalShift)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.setNavigationBarHidden(true, animated: true)
        return navigationController
    }
    
    func setupScanButton() {
        let button = UIButton(frame: CGRect(x: view.bounds.width / 2 - 32.5, y: -30, width: 65, height: 65))
        button.layer.cornerRadius = button.bounds.width / 2
        button.setImage(R.image.scanHome(), for: .normal)
        button.imageView?.layer.cornerRadius = button.bounds.width / 2
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.menuScanDropShadow.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = true
        customTabBar.addSubview(button)
        customTabBar.bringSubviewToFront(button)
        view.layoutIfNeeded()
    }
    
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

class CustomTabBar: UITabBar {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event)
            else { continue }
            return result
        }
        return nil
    }
}

// MARK: - Properties
extension MenuTabBarController {
    class func instantiate() -> MenuTabBarController? {
        let controller = UIStoryboard(name: R.storyboard.menuTabBarController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.tabMenuIdentifier()) as? MenuTabBarController
        return controller
    }
}
