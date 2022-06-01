//
//  ResetPasswordViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/23/22.
//

import Foundation
import UIKit
import AWSMobileClient

class ResetPasswordViewController: UIViewController {
    // MARK: - Properties
    private var onSuccess: ((String?)->())?
    private var onFailure: (()->())?
    private var email: String?
    
    // MARK: - Outlets
    @IBOutlet var codeField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmField: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    // MARK: - Actions
    @IBAction func signInClicked(_ sender: Any) {
        requestPasswordChange()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension ResetPasswordViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    func requestPasswordChange() {
        guard let email = email,
              codeField.text?.isEmpty == false,
              passwordField.text?.isValidPassword == true,
              confirmField.text?.isValidPassword == true else {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            present(alert, animated: true)
            return
        }
        CognitoNetworkingService.submitForgotPasswordCode(email: email, password: passwordField.text!, code: codeField.text!) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error as? AWSMobileClientError {
                    let alert = UIAlertController(title: error.errorMessage, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default) { _ in
                        self?.onFailure?()
                    })
                    self?.present(alert, animated: true)
                } else {
                    self?.onSuccess?(self?.passwordField.text)
                }
            }
        }
    }
    
}

// MARK: - Properties
extension ResetPasswordViewController {
    class func instantiate(email: String, onSuccess: ((String?)->())?, onFailure: (()->())?) -> ResetPasswordViewController? {
        let controller = UIStoryboard(name: R.storyboard.resetPasswordViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.resetPasswordIdentifier()) as? ResetPasswordViewController
        controller?.onSuccess = onSuccess
        controller?.onFailure = onFailure
        return controller
    }
}
