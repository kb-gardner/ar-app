//
//  UIViewExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/24/22.
//

import UIKit

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func embed(in containerView: UIView?, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        guard let containerView = containerView else { return }
        containerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailing),
            self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottom)
        ])
    }
    
    func removeSubviews() {
        self.subviews.forEach({ $0.removeFromSuperview()})
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func applyDropShadow(x: CGFloat, y: CGFloat, blur: CGFloat, color: CGColor) {
        self.layer.masksToBounds = true
        self.layer.shadowColor = color
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = blur / 2
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }

}
