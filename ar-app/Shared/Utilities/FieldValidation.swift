//
//  FieldValidation.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/24/22.
//

import Foundation
import UIKit

class FieldValidation {
    class func validateFields(email: UITextField? = nil, phone: UITextField? = nil, password: UITextField? = nil, completion: ((UIAlertController?)->())) -> Bool {
        if let email = email {
            guard email.text?.isValidEmail == true else {
                let alert = UIAlertController(title: R.string.localizable.validationErrorValidationEmailTitle(), message: R.string.localizable.validationErrorValidationEmailMessage(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                completion(alert)
                return false
            }
        }
        if let password = password {
            guard password.text?.isValidPassword == true else {
                let alert = UIAlertController(title: R.string.localizable.validationErrorValidationPasswordTitle(), message: R.string.localizable.validationErrorValidationPasswordMessage(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                completion(alert)
                return false
            }
        }
        if let phone = phone {
            guard phone.text?.isValidPhoneNumber == true else {
                let alert = UIAlertController(title: R.string.localizable.validationErrorValidationPhoneTitle(), message: R.string.localizable.validationErrorValidationPhoneMessage(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
                completion(alert)
                return false
            }
        }
        return true
    }
}
