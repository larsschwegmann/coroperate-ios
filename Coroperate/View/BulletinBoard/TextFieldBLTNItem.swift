/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard

/**
 * An item that displays a text field.
 *
 * This item demonstrates how to create a bulletin item with a text field and how it will behave
 * when the keyboard is visible.
 */

class TextFieldBLTNItem: FeedbackPageBLTNItem {

    @objc public var textField: UITextField!

    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil

    var placeholder: String?
    var keyboardType: UIKeyboardType

    init(title: String, placeholder: String?, keyboardType: UIKeyboardType? = .default) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType ?? .default
        super.init(title: title)
    }

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: self.placeholder, returnKey: .done, delegate: self)
        textField.keyboardType = self.keyboardType
        return [textField]
    }

    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }

    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }

}

// MARK: - UITextFieldDelegate

extension TextFieldBLTNItem: UITextFieldDelegate {

    @objc open func isInputValid(text: String?) -> Bool {

        if text == nil || text!.isEmpty {
            return false
        }

        return true

    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if isInputValid(text: textField.text) {
            textInputHandler?(self, textField.text)
        } else {
            descriptionLabel!.textColor = .red
            descriptionLabel!.text = "You must enter some text to continue."
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }

    }

}
