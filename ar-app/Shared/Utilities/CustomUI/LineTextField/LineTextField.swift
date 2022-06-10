//
//  LineTextField.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/31/22.
//

import Foundation
import UIKit

final class LineTextView: UIView {
    private var onEndEditing: ((String?)->())?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var titleBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = superview!.frame
        center = CGPoint(x: superview!.frame.size.width  / 2,
                                     y: superview!.frame.size.height / 2)
    }
    
    func setup(title: String?, value: String?, onEndEditing: ((String?)->())?) {
        textView.delegate = self
        titleLabel.text = title
        self.onEndEditing = onEndEditing
        if let value = value {
            textView.text = value
            openTextView()
        }
    }
    
    func openTextView() {
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 12)
        titleTopLayoutConstraint.isActive = true
        titleBottomLayoutConstraint.isActive = false
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    func closeTextView() {
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 15)
        titleTopLayoutConstraint.isActive = false
        titleBottomLayoutConstraint.isActive = true
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
}

extension LineTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        openTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.hasText {
            onEndEditing?(textView.text)
        } else {
            closeTextView()
            onEndEditing?(nil)
        }
    }
}
