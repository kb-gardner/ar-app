//
//  Store.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

class Store {
    class var user: User? {
        return Store.shared.user
    }

    static let shared = Store()
        
    class func clear() {
        Store.shared.user = nil
    }

    var user: User?
    var currentDeviceTokens: [String]?
    
}
