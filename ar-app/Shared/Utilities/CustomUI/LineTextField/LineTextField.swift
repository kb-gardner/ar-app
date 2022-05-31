//
//  LineTextField.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/31/22.
//

import Foundation
import UIKit

class LineTextView: UIView {
    private var onEndEditing: ((String?)->())?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var titleBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.delegate = self
    }
    
    func setup(textSize: CGFloat, textColor: UIColor, title: String?, value: String?, onEndEditing: ((String?)->())?) {
        titleLabel.text = title
        textView.textColor = textColor
        textView.font = UIFont(name: "Helvetica Neue", size: textSize)
        self.onEndEditing = onEndEditing
        if let value = value {
            textView.text = value
            openTextView()
        }
    }
    
    func openTextView() {
        titleTopLayoutConstraint.isActive = true
        titleBottomLayoutConstraint.isActive = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    func closeTextView() {
        titleTopLayoutConstraint.isActive = false
        titleBottomLayoutConstraint.isActive = true
        UIView.animate(withDuration: 0.3) { [weak self] in
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
