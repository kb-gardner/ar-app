//
//  SignUpViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/18/22.
//

import Foundation
import UIKit
import AWSMobileClient

class SignUpViewController: UIViewController {
    // MARK: - Properties
    private var user = User()
    private var onShowLogin: (()->())?
    private var onSuccess: (()->())?
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var termsButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    // MARK: - Actions
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsClicked(_ sender: Any) {
        showTerms()
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        requestSignUp()
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        showLogin()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        nameField.delegate = self
        phoneField.delegate = self
    }
}

private extension SignUpViewController {
    // MARK: - Navigation
    func showLogin() {
        onShowLogin?()
    }
    
    func showTerms() {
        guard let controller = TermsViewController.instantiate() else { return }
        present(controller, animated: true)
    }
    
    // MARK: - Requests
    func requestSignUp() {
        guard FieldValidation.validateFields(email: emailField, phone: phoneField, password: passwordField, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }) else { return }
        CognitoNetworkingService.signUp(username: user.email!, password: passwordField.text!, email: user.email!) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error as? AWSMobileClientError {
                    let alert = UIAlertController(title: error.errorMessage, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                    self?.present(alert, animated: true)
                } else {
                    self?.requestLogin()
                }
            }
        }
    }
    
    func requestLogin() {
        guard FieldValidation.validateFields(email: emailField, phone: phoneField, password: passwordField, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }) else { return }
        CognitoNetworkingService.login(password: passwordField.text!, email: user.email!) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error as? AWSMobileClientError {
                    let alert = UIAlertController(title: error.errorMessage, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                    self?.present(alert, animated: true)
                } else {
                    self?.createUser()
                }
            }
        }
    }
    
    func createUser() {
        UserNetworkingService.saveUser(user: user) { [weak self] newUser, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    Store.shared.user = newUser
                    self?.onSuccess?()
                }
            }
        }
    }
    
}

// MARK: - TextField
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            user.email = textField.text
        case nameField:
            user.name = textField.text
        case phoneField:
            user.phone = textField.text
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailField:
            user.email = textField.text
        case nameField:
            user.name = textField.text
        case phoneField:
            user.phone = textField.text
        default:
            break
        }
    }
}

// MARK: - Instantiation
extension SignUpViewController {
    class func instantiate(onSuccess: (()->())?, onShowLogin: (()->())?) -> SignUpViewController? {
        let controller = UIStoryboard(name: R.storyboard.signUpViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.signUpIdentifier()) as? SignUpViewController
        controller?.onShowLogin = onShowLogin
        controller?.onSuccess = onSuccess
        return controller
    }
}
