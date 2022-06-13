//
//  UIButtonExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/13/22.
//

import Foundation
import UIKit

extension UIButton {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -20, dy: -20).contains(point)
    }
}
