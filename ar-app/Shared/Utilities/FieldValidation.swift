//
//  FieldValidation.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/24/22.
//

import Foundation
import UIKit

class FieldValidation {
    class func validateFields(email: String? = nil, phone: String? = nil, password: String? = nil, confirmPassword: String? = nil, authCode: String? = nil, checkEmail: Bool? = false, checkPhone: Bool? = false, checkPassword: Bool? = false, checkConfirmPassword: Bool = false, checkAuthCode: Bool = false, completion: ((UIAlertController?)->())) -> Bool {
        if checkEmail == true {
            guard let email = email, email.isValidEmail == true else {
                let alert = UIAlertController(title: R.string.localizable.validationErrorValidationEmailTitle(), message: R.string.localizable.validationErrorValidationEmailMessage(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                completion(alert)
                return false
            }
        }
        if checkAuthCode == true {
            guard authCode != nil, authCode?.isEmpty == false else {
                let alert = UIAlertController(title: R.string.localizable.validationErrorValidationAuthCodeTitle(), message: R.string.localizable.validationErrorValidationAuthCodeMessage(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                completion(alert)
                return false
            }
        }
        if checkPassword == true {
            guard let password = password, password.isValidPassword == true else {
                let alert = UIAlertController(title: R.string.localizable.validationErrorValidationPasswordTitle(), message: R.string.localizable.validationErrorValidationPasswordMessage(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                completion(alert)
                return false
            }
        }
        if checkPhone == true {
            guard let phone = phone, phone.isValidPhoneNumber == true else {
                let alert = UIAlertController(title: R.string.localizable.validationErrorValidationPhoneTitle(), message: R.string.localizable.validationErrorValidationPhoneMessage(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                completion(alert)
                return false
            }
        }
        if checkConfirmPassword == true {
            guard let confirmPassword = confirmPassword, confirmPassword.isValidPassword == true, confirmPassword == password else {
                let alert = UIAlertController(title: R.string.localizable.validationErrorValidationConfirmPasswordTitle(), message: R.string.localizable.validationErrorValidationConfirmPasswordMessage(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                completion(alert)
                return false
            }
        }
        return true
    }
}
