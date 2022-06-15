//
//  UIColorExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/13/22.
//

import Foundation
import UIKit

extension UIColor {
    class var checkboxGray: UIColor {
        return UIColor(hex: "#D0D0D0")
    }
    
    class var menuTextBlue: UIColor {
        return UIColor(hex: "#50A9B0")
    }
    
    class var menuTextGray: UIColor {
        return UIColor(hex: "#707070")
    }
    
    class var menuScanDropShadow: UIColor {
        return UIColor(hex: "#020A2E17")
    }
            
    convenience init(hex: String) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        let netHex = Int(rgbValue)
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
