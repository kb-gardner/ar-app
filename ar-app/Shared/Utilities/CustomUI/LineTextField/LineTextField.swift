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
    private var showPassword = false
    private var fieldType: UITextView.FieldType!
    private let phoneMask = "(XXX) XXX-XXXX"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var titleBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var eyeButton: UIButton!
    
    @IBAction func eyeClicked(_ sender: Any) {
        if showPassword {
            eyeButton.setImage(R.image.showPassword(), for: .normal)
        } else {
            eyeButton.setImage(R.image.hidePassword(), for: .normal)
        }
        showPassword.toggle()
        textField.isSecureTextEntry.toggle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = superview!.frame
        center = CGPoint(x: superview!.frame.size.width  / 2,
                                     y: superview!.frame.size.height / 2)
    }
    
    func setup(title: String?, value: String?, fieldType: UITextView.FieldType, onEndEditing: ((String?)->())?) {
        textView.delegate = self
        textField.delegate = self
        titleLabel.text = title
        self.onEndEditing = onEndEditing
        self.fieldType = fieldType
        textView.keyboardType = fieldType.keyboardType
        textField.keyboardType = fieldType.keyboardType
        textView.textContentType = fieldType.contentType
        textField.textContentType = fieldType.contentType
        textView.autocapitalizationType = fieldType.capitalization
        textField.autocapitalizationType = fieldType.capitalization
        setEyeButton(isPassword: fieldType == .password)
        setSecureTextEntry(isPassword: fieldType == .password)
        setTextEnvironment(canMultiLine: fieldType == .address)
        if let value = value {
            textView.text = value
            textField.text = value
            openTextSpace()
        }
    }
    
}

private extension LineTextView {
    func setEyeButton(isPassword: Bool) {
        eyeButton.isHidden = !isPassword
    }
    
    func setSecureTextEntry(isPassword: Bool) {
        textField.isSecureTextEntry = isPassword
    }
    
    func setTextEnvironment(canMultiLine: Bool) {
        textView.isHidden = !canMultiLine
        textField.isHidden = canMultiLine
    }
    
    func openTextSpace() {
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 12)
        titleTopLayoutConstraint.isActive = true
        titleBottomLayoutConstraint.isActive = false
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    func closeTextSpace() {
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 15)
        titleTopLayoutConstraint.isActive = false
        titleBottomLayoutConstraint.isActive = true
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    private func format(phone: String?) -> String {
        guard let phone = phone else { return "" }
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in phoneMask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
}

extension LineTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        openTextSpace()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.hasText {
            onEndEditing?(textView.text)
        } else {
            closeTextSpace()
            onEndEditing?(nil)
        }
    }
}

extension LineTextView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        openTextSpace()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch fieldType {
        case .phone:
            let new = textField.text! as NSString
            let newText = new.replacingCharacters(in: range, with: string)
            textField.text = format(phone: newText)
            return false
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText {
            switch fieldType {
            case .phone:
                onEndEditing?(textField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
            default:
                onEndEditing?(textField.text)
            }
        } else {
            closeTextSpace()
            onEndEditing?(nil)
        }
    }
}
