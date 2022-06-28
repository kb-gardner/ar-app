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
    // MARK: - Requests
    func requestUser() {
        print(UserDefaults.hasAuth)
        print(UserDefaults.isAuth)
        CognitoNetworkingService.initSession { _ in
            guard let id = AWSMobileClient.default().userSub else {
                AppRouter.shared.logout()
                return
            }
            UserNetworkingService.getUser(id: id) { user, error in
                if let error = error {
                    print(error)
                    AppRouter.shared.logout()
                } else {
                    Store.shared.user = user
                    AppRouter.shared.showAppropriateView()
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
