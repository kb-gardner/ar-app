//
//  UIViewControllerExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/3/22.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    func showHUD() {
        SVProgressHUD.show()
    }
    
    func showHUD(message: String?) {
        SVProgressHUD.show(withStatus: message)
    }

    func hideHUD() {
        SVProgressHUD.dismiss()
    }
}
