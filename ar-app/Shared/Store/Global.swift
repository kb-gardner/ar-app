//
//  Global.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/6/22.
//

import Foundation

class Global {
    struct Environment {
        static let isDev = true
    }
    
    struct ServerAPI {
        static var url: String {
            return Environment.isDev ? "https://06ptrua91m.execute-api.us-west-2.amazonaws.com/dev/" : ""
        }
    }
    
    static var materialFtScanKey = "can-scan"
    
}
