//
//  NSErrorExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

extension NSError {
    class func standard(message: String?, code: Int = 0) -> NSError {
        return NSError(domain: "self", code: code, userInfo: [NSLocalizedDescriptionKey: message ?? ""])
    }
}
