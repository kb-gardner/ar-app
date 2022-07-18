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
    private var email: String?
    
    // MARK: - Outlets
    @IBOutlet var backButton: UIButton!
    @IBOutlet var emailView: UIView!
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
        submitButton.layer.cornerRadius = 8
        setupTextViews()
    }
}

private extension ForgotPasswordViewController {
    func setupTextViews() {
        let emailField: LineTextView = LineTextView.fromNib()
        emailView.addSubview(emailField)
        emailField.setup(title: "Email", value: nil, fieldType: .email) { [weak self] string in
            self?.email = string?.lowercased()
        }
    }
    
    // MARK: - Navigation
    func showCodeView() {
        guard let email = email, let controller = ResetPasswordViewController.instantiate(email: email, onSuccess: { [weak self] password in
            self?.onSuccess?(password)
        }, onFailure: { [weak self] in
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            self?.present(alert, animated: true)
        }) else { return }
        present(controller, animated: true)
    }
    
    // MARK: - Requests
    func requestCode() {
        guard FieldValidation.validateFields(email: email, checkEmail: true, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }), let email = email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else { return }
        showHUD()
        CognitoNetworkingService.forgotPassword(email: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.hideHUD()
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
