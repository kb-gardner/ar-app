//
//  ForgotPasswordViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/18/22.
//

import Foundation
import UIKit

class ForgotPasswordViewController: UIViewController {
    // MARK: - Properties
    private var onSuccess: ((String?)->())?
    
    // MARK: - Outlets
    @IBOutlet var emailField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var forgotView: UIView!
    @IBOutlet var forgotViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var forgotViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction func submitClicked(_ sender: Any) {
        requestCode()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension ForgotPasswordViewController {
    // MARK: - Navigation
    func showCodeView() {
        guard let email = emailField.text, let controller = ResetPasswordViewController.instantiate(email: email, onSuccess: { [weak self] password in
            self?.onSuccess?(password)
        }, onFailure: { [weak self] in
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            self?.present(alert, animated: true)
        }) else { return }
        
    }
    
    // MARK: - Requests
    func requestCode() {
        guard emailField.text?.isValidEmail == true else {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            present(alert, animated: true)
            return
        }
        CognitoNetworkingService.forgotPassword(email: emailField.text!) { [weak self] error in
            if let error = error {
                print(error)
            } else {
                self?.showCodeView()
            }
        }
    }
    
}

// MARK: - Properties
extension ForgotPasswordViewController {
    class func instantiate(onSuccess: ((String?)->())?) -> ForgotPasswordViewController? {
        let controller = UIStoryboard(name: R.storyboard.forgotPasswordViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.forgotPasswordIdentifier()) as? ForgotPasswordViewController
        controller?.onSuccess = onSuccess
        return controller
    }
}
