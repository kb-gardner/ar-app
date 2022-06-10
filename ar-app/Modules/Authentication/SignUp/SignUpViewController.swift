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
    private var password: String?
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var phoneView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var termsButton: UIButton!
    @IBOutlet var termsLabel: UILabel!
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
        setupTextViews()
        // do the attributed text for terms label/button
    }
}

private extension SignUpViewController {
    func setupTextViews() {
        let nameField: LineTextView = LineTextView.fromNib()
        let emailField: LineTextView = LineTextView.fromNib()
        let phoneField: LineTextView = LineTextView.fromNib()
        let passwordField: LineTextView = LineTextView.fromNib()
        nameView.addSubview(nameField)
        emailView.addSubview(emailField)
        phoneView.addSubview(phoneField)
        passwordView.addSubview(passwordField)
        nameField.setup(title: "Name", value: nil) { [weak self] string in
            self?.user.name = string
        }
        emailField.setup(title: "Email", value: nil) { [weak self] string in
            self?.user.email = string
        }
        phoneField.setup(title: "Phone Number", value: nil) { [weak self] string in
            self?.user.phone = string
        }
        passwordField.setup(title: "New Password", value: nil) { [weak self] string in
            self?.password = string
        }
    }
    
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
        guard FieldValidation.validateFields(email: user.email, phone: user.phone, password: password, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }) else { return }
        showHUD()
        var attributes = [String: String]()
        if let phone = user.phone {
            attributes["phone_number"] = phone.cognitoFormattedPhoneNumber
        }
        if let email = user.email {
            attributes["email"] = email
        }
        CognitoNetworkingService.signUp(username: user.email!, password: password!, email: user.email!, attributes: attributes) { [weak self] error in
            self?.hideHUD()
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
        guard FieldValidation.validateFields(email: user.email, phone: user.phone, password: password, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }) else { return }
        showHUD()
        CognitoNetworkingService.login(password: password!, email: user.email!) { [weak self] error in
            self?.hideHUD()
            DispatchQueue.main.async {
                if let error = error as? AWSMobileClientError {
                    let alert = UIAlertController(title: error.errorMessage, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                    self?.present(alert, animated: true)
                } else {
                    self?.user.id = AWSMobileClient.default().userSub
                    self?.createUser()
                }
            }
        }
    }
    
    func createUser() {
        UserNetworkingService.createUser(user: user) { [weak self] newUser, error in
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

// MARK: - Instantiation
extension SignUpViewController {
    class func instantiate(onSuccess: (()->())?, onShowLogin: (()->())?) -> SignUpViewController? {
        let controller = UIStoryboard(name: R.storyboard.signUpViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.signUpIdentifier()) as? SignUpViewController
        controller?.onShowLogin = onShowLogin
        controller?.onSuccess = onSuccess
        return controller
    }
}
