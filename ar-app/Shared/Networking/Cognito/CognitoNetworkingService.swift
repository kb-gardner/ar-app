//
//  CognitoNetworkingService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/23/22.
//

import Foundation
import AWSMobileClient

class CognitoNetworkingService {
    class func signUp(username: String, password: String, email: String, completion: @escaping ((Error?)->())) {
        AWSMobileClient.default().signUp(username: username, password: password) { result, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    class func login(password: String, email: String, completion: @escaping ((Error?)->())) {
        AWSMobileClient.default().signIn(username: email, password: password) { result, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    class func forgotPassword(email: String, completion: @escaping ((Error?)->())) {
        AWSMobileClient.default().forgotPassword(username: email) { result, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    class func submitForgotPasswordCode(email: String, password: String, code: String, completion: @escaping ((Error?)->())) {
        AWSMobileClient.default().confirmForgotPassword(username: email, newPassword: password, confirmationCode: code) { result, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}