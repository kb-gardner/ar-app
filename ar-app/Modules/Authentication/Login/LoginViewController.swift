//
//  LoginViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/18/22.
//

import Foundation
import UIKit
import AWSMobileClient

class LoginViewController: UIViewController {
    // MARK: - Properties
    private var onLogin: (()->())?
    private var onSignUp: (()->())?
    
    // MARK: - Outlets
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var forgotButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInCollection: UICollectionView!
    
    // MARK: - Actions
    @IBAction func forgotClicked(_ sender: Any) {
        showForgotPassword()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        requestLogin()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        onSignUp?()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension LoginViewController {
    // MARK: - Navigation
    func showForgotPassword() {
        
    }
    
    // MARK: - Requests
    func requestLogin() {
        guard emailField.text?.isValidEmail == true,
              passwordField.text?.isValidPassword == true else {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            present(alert, animated: true)
            return
        }
        CognitoNetworkingService.login(password: passwordField.text!, email: emailField.text!) { [weak self] error in
            if let error = error {
                print(error)
            } else {
                self?.requestUser()
            }
        }
    }
    
    func requestUser() {
        guard let cognitoId = AWSMobileClient.default().username else { return }
        UserNetworkingService.getUserByCognitoId(id: cognitoId) { [weak self] user, error in
            if let error = error {
                print(error)
            } else {
                Store.shared.user = user
                self?.onLogin?()
            }
        }
    }
    
}

// MARK: - Properties
extension LoginViewController {
    class func instantiate(onLogin: (()->())?, onSignUp: (()->())?) -> LoginViewController? {
        let controller = UIStoryboard(name: R.storyboard.loginViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.loginIdentifier()) as? LoginViewController
        controller?.onLogin = onLogin
        controller?.onSignUp = onSignUp
        return controller
    }
}

