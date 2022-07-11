//
//  EditAccountViewController.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/24/22.
//

import Foundation
import UIKit

class EditAccountViewController: UIViewController {
    // MARK: - Properties
    private var onSave: ((String?)->())?
    private var value: String?
    private var titleText: String?
    private var isTextView: Bool? = false
    private var fieldType: UITextView.FieldType!
    
    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var valueView: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var saveButtonTopLineViewConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction func saveClicked(_ sender: Any) {
        onSave?(value)
        dismiss(animated: true)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 8
        titleLabel.text = titleText?.uppercased()
        if isTextView == true {
            textView.text = value
            textView.sizeToFit()
            textView.translatesAutoresizingMaskIntoConstraints = true
            textView.delegate = self
            textView.isHidden = false
            valueView.isHidden = true
            saveButtonTopLineViewConstraint.constant = 150
        } else {
            let valueField: LineTextView = LineTextView.fromNib()
            valueView.addSubview(valueField)
            valueField.setup(title: titleText, value: value, fieldType: fieldType) { [weak self] string in
                self?.value = string
            }
            textView.isHidden = true
            valueView.isHidden = false
            saveButtonTopLineViewConstraint.constant = 50
        }
        view.layoutIfNeeded()
    }
}

private extension EditAccountViewController {
    func refreshConstraints() {
        
    }
    
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

extension EditAccountViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height < 150 {
            textView.sizeToFit()
        }
    }
}

// MARK: - Properties
extension EditAccountViewController {
    class func instantiate(title: String, value: String?, fieldType: UITextView.FieldType, isTextView: Bool? = false, onSave: ((String?)->())?) -> EditAccountViewController? {
        let controller = UIStoryboard(name: R.storyboard.editAccountViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.editAccountIdentifier()) as? EditAccountViewController
        controller?.titleText = title
        controller?.value = value
        controller?.fieldType = fieldType
        controller?.onSave = onSave
        controller?.isTextView = isTextView
        return controller
    }
}
