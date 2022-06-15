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
    private var onSuccess: (()->())?
    private var onShowSignUp: (()->())?
    private var loginOptions = [R.string.localizable.loginGoogleText(), R.string.localizable.loginFacebookText(), R.string.localizable.loginAppleText()]
    private var email: String?
    private var password: String?
    
    // MARK: - Outlets
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var forgotButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInTable: UITableView!
    
    // MARK: - Actions
    @IBAction func forgotClicked(_ sender: Any) {
        showForgotPassword()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        requestLogin()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        showSignUp()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        signInTable.register(R.nib.loginOptionTableViewCell)
        signInTable.delegate = self
        signInTable.dataSource = self
        signInTable.reloadData()
        signInButton.layer.cornerRadius = 8
    }
}

private extension LoginViewController {
    func reloadData() {
        let emailField: LineTextView = LineTextView.fromNib()
        let passwordField: LineTextView = LineTextView.fromNib()
        emailView.addSubview(emailField)
        passwordView.addSubview(passwordField)
        passwordField.setup(title: "Password", value: password, fieldType: .password) { [weak self] string in
            self?.password = string
        }
        emailField.setup(title: "Email", value: email, fieldType: .email) { [weak self] string in
            self?.email = string
        }
    }
    
    // MARK: - Navigation
    func showForgotPassword() {
        guard let controller = ForgotPasswordViewController.instantiate(onSuccess: { [weak self] password in
            self?.password = password
            self?.reloadData()
        }) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSignUp() {
        onShowSignUp?()
    }
    
    // MARK: - Requests
    func requestLogin() {
        guard FieldValidation.validateFields(email: email, password: password, checkEmail: true, checkPassword: true, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }) else { return }
        showHUD()
        CognitoNetworkingService.login(password: password!, email: email!) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error as? AWSMobileClientError {
                    let alert = UIAlertController(title: error.errorMessage, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                    self?.present(alert, animated: true)
                } else {
                    self?.requestUser()
                }
            }
            self?.hideHUD()
        }
    }
    
    func requestUser() {
        guard let id = AWSMobileClient.default().userSub else { return }
        showHUD()
        UserNetworkingService.getUser(id: id) { [weak self] user, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    AWSMobileClient.default().signOut()
                } else {
                    Store.shared.user = user
                    self?.onSuccess?()
                }
            }
            self?.hideHUD()
        }
    }
    
    func requestSignInApple() {}
    
    func requestSignInGoogle() {}
    
    func requestSignInFacebook() {}
    
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    enum LoginOptions: CaseIterable {
        case google, facebook, apple
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoginOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.loginOptionTableViewCell, for: indexPath)
        switch LoginOptions.allCases[indexPath.row] {
        case .apple:
            cell?.setup(image: R.image.appleIcon(), text: R.string.localizable.loginAppleText(), width: 200)
        case .google:
            cell?.setup(image: R.image.googleIcon(), text: R.string.localizable.loginGoogleText(), width: 200)
        case .facebook:
            cell?.setup(image: R.image.facebookIcon(), text: R.string.localizable.loginFacebookText(), width: 200)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch LoginOptions.allCases[indexPath.row] {
        case .apple:
            requestSignInApple()
        case .google:
            requestSignInGoogle()
        case .facebook:
            requestSignInFacebook()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == LoginOptions.allCases.count - 1 {
            return 30
        }
        return 40
    }
}

// MARK: - Properties
extension LoginViewController {
    class func instantiate(onSuccess: (()->())?, onShowSignUp: (()->())?) -> LoginViewController? {
        let controller = UIStoryboard(name: R.storyboard.loginViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.loginIdentifier()) as? LoginViewController
        controller?.onSuccess = onSuccess
        controller?.onShowSignUp = onShowSignUp
        return controller
    }
}

