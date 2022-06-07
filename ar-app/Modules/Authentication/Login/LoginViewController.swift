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
        showSignUp()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        signInCollection.delegate = self
        signInCollection.dataSource = self
        signInCollection.register(R.nib.loginOptionCollectionViewCell)
        signInCollection.reloadData()
    }
}

private extension LoginViewController {
    // MARK: - Navigation
    func showForgotPassword() {
        guard let controller = ForgotPasswordViewController.instantiate(onSuccess: { [weak self] password in
            self?.passwordField.text = password
        }) else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSignUp() {
        onShowSignUp?()
    }
    
    // MARK: - Requests
    func requestLogin() {
        guard FieldValidation.validateFields(email: emailField, password: passwordField, completion: { alert in
            if let alert = alert { present(alert, animated: true) }
        }) else { return }
        showHUD()
        CognitoNetworkingService.login(password: self.passwordField.text!, email: self.emailField.text!) { [weak self] error in
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
    
}

extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    enum LoginOptions: CaseIterable {
        case apple, google, facebook
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        LoginOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch LoginOptions.allCases[indexPath.row] {
        case .apple:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.loginOptionCollectionViewCell, for: indexPath)!
            cell.setup(image: R.image.appleIcon())
            return cell
        case .google:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.loginOptionCollectionViewCell, for: indexPath)!
            cell.setup(image: R.image.googleIcon())
            return cell
        case .facebook:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.loginOptionCollectionViewCell, for: indexPath)!
            cell.setup(image: R.image.facebookIcon())
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch LoginOptions.allCases[indexPath.row] {
        case .apple:
            print("")
        case .google:
            print("")
        case .facebook:
            print("")
        }
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

