//
//  ForgotPasswordViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/18/22.
//

import Foundation
import UIKit
import AWSMobileClient

class ForgotPasswordViewController: UIViewController {
    // MARK: - Properties
    private var onSuccess: ((String?)->())?
    
    // MARK: - Outlets
    @IBOutlet var backButton: UIButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var forgotView: UIView!
    @IBOutlet var forgotViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var forgotViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
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
            self?.hideResetPasswordView()
        }, onFailure: { [weak self] in
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            self?.present(alert, animated: true)
            self?.hideResetPasswordView()
        }) else { return }
        controller.view?.embed(in: forgotView)
        showResetPasswordView()
    }
    
    func showResetPasswordView() {
        forgotViewBottomConstraint?.isActive = true
        forgotViewTopConstraint?.isActive = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func hideResetPasswordView() {
        forgotViewTopConstraint?.isActive = true
        forgotViewBottomConstraint?.isActive = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Requests
    func requestCode() {
        guard FieldValidation.validateFields(email: emailField.text, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }), let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else { return }
        CognitoNetworkingService.forgotPassword(email: email) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error as? AWSMobileClientError {
                    let alert = UIAlertController(title: error.errorMessage, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                    self?.present(alert, animated: true)
                } else {
                    self?.showCodeView()
                }
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
