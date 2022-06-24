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
    private var fieldType: UITextView.FieldType!
    
    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var valueView: UIView!
    
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
        let valueField: LineTextView = LineTextView.fromNib()
        valueView.addSubview(valueField)
        valueField.setup(title: titleText, value: value, fieldType: fieldType) { [weak self] string in
            self?.value = string
        }
    }
}

private extension EditAccountViewController {
    // MARK: - Navigation
    
    // MARK: - Requests
    
}

// MARK: - Properties
extension EditAccountViewController {
    class func instantiate(title: String, value: String?, fieldType: UITextView.FieldType, onSave: ((String?)->())?) -> EditAccountViewController? {
        let controller = UIStoryboard(name: R.storyboard.editAccountViewController.name, bundle: nil).instantiateViewController(withIdentifier: R.string.localizable.editAccountIdentifier()) as? EditAccountViewController
        controller?.titleText = title
        controller?.value = value
        controller?.fieldType = fieldType
        controller?.onSave = onSave
        return controller
    }
}
