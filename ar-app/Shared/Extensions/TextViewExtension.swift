//
//  TextViewExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/13/22.
//

import Foundation
import UIKit

extension UITextView {
    enum FieldType {
        case email, password, phone, code, name, address
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .email:
                return .emailAddress
            case .phone:
                return .phonePad
            case .code:
                return .numberPad
            default:
                return .default
            }
        }
        
        var contentType: UITextContentType {
            switch self {
            case .email:
                return .emailAddress
            case .password:
                return .password
            case .phone:
                return .telephoneNumber
            case .code:
                return .oneTimeCode
            case .name:
                return .name
            case .address:
                return .fullStreetAddress
            }
        }
        
        var capitalization: UITextAutocapitalizationType {
            switch self {
            case .name:
                return .words
            case .address:
                return .words
            default:
                return .none
            }
        }
    }
}
