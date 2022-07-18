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
    private var email: String!
    private var code: String?
    private var password: String?
    private var confirmedPassword: String?
    
    // MARK: - Outlets
    @IBOutlet var codeView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var confirmView: UIView!
    @IBOutlet var signInButton: UIButton!
    
    // MARK: - Actions
    @IBAction func signInClicked(_ sender: Any) {
        requestPasswordChange()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        onFailure?()
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 8
        setupTextViews()
    }
}

private extension ResetPasswordViewController {
    func setupTextViews() {
        let codeField: LineTextView = LineTextView.fromNib()
        codeView.addSubview(codeField)
        let passwordField: LineTextView = LineTextView.fromNib()
        passwordView.addSubview(passwordField)
        let confirmField: LineTextView = LineTextView.fromNib()
        confirmView.addSubview(confirmField)
        codeField.setup(title: "Code", value: nil, fieldType: .code) { [weak self] string in
            self?.code = string?.lowercased()
        }
        passwordField.setup(title: "New Password", value: nil, fieldType: .password) { [weak self] string in
            self?.password = string?.lowercased()
        }
        confirmField.setup(title: "Confirm Password", value: nil, fieldType: .password) { [weak self] string in
            self?.confirmedPassword = string?.lowercased()
        }
    }
    
    // MARK: - Navigation
    
    // MARK: - Requests
    func requestPasswordChange() {
        guard FieldValidation.validateFields(password: password, confirmPassword: confirmedPassword, authCode: code, checkPassword: true, checkConfirmPassword: true, checkAuthCode: true, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }) else { return }
        showHUD()
        CognitoNetworkingService.submitForgotPasswordCode(email: email, password: password!, code: code!) { [weak self] error in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error as? AWSMobileClientError {
                    let alert = UIAlertController(title: error.errorMessage, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default) { _ in
                        self?.onFailure?()
                    })
                    self?.present(alert, animated: true)
                } else {
                    self?.onSuccess?(self?.password)
                    self?.dismiss(animated: true)
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
        controller?.email = email
        return controller
    }
}
