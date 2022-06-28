//
//  UserDefaultsExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/28/22.
//

import Foundation

extension UserDefaults {
    
    private enum UserDefaultsKey: String {
        case isAuth, hasAuth
    }
    
    class var isAuth: Bool {
        get {
            return standard.bool(forKey: UserDefaultsKey.isAuth.rawValue)
         }
        set {
            standard.set(newValue, forKey: UserDefaultsKey.isAuth.rawValue)
        }
    }
    
    class var hasAuth: Bool {
        get {
            return standard.bool(forKey: UserDefaultsKey.hasAuth.rawValue)
         }
        set {
            standard.set(newValue, forKey: UserDefaultsKey.hasAuth.rawValue)
        }
    }
    
}
