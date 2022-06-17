//
//  UIImageExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/17/22.
//

import Foundation
import UIKit

extension UIImage {
    func addTitleBelow(text: String, _ selected: Bool) -> UIImage? {
        let text = NSString(string: text)
        let fontAttributes = [
            NSAttributedString.Key.font: UIFont.menuTitleFont!,
            NSAttributedString.Key.foregroundColor: selected ? UIColor.menuTextBlue : UIColor.menuTextGray
        ]
        let scale = UIScreen.main.scale
        let textSize = text.size(withAttributes: fontAttributes)
        let yOffset: CGFloat = 25 - size.height
        let xOffset: CGFloat = (textSize.width - size.width) / 2
        UIGraphicsBeginImageContextWithOptions(CGSize(width: textSize.width, height: size.height + textSize.height + yOffset), false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(at: CGPoint(x: xOffset, y: yOffset / 2))
        text.draw(at: CGPoint(x: 0, y: size.height + yOffset), withAttributes: fontAttributes)
        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    }
}
