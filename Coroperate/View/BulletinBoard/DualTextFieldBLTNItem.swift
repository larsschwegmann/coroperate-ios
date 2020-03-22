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

class DualTextFieldBLTNItem: FeedbackPageBLTNItem {

    @objc public var textFieldA: UITextField!
    @objc public var textFieldB: UITextField!

    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil

    var placeholderA: String?
    var placeholderB: String?

    init(title: String, placeholderA: String?, placeholderB: String?) {
        self.placeholderA = placeholderA
        self.placeholderB = placeholderB
        super.init(title: title)
    }

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textFieldA = interfaceBuilder.makeTextField(placeholder: self.placeholderA, returnKey: .done, delegate: self)
        textFieldA.autocorrectionType = .no
        textFieldB = interfaceBuilder.makeTextField(placeholder: self.placeholderB, returnKey: .done, delegate: self)
        textFieldB.autocorrectionType = .no
        return [textFieldA, textFieldB]
    }

    override func tearDown() {
        super.tearDown()
        textFieldA?.delegate = nil
        textFieldB?.delegate = nil
    }

    override func actionButtonTapped(sender: UIButton) {
        textFieldA.resignFirstResponder()
        textFieldB.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }

}

// MARK: - UITextFieldDelegate

extension DualTextFieldBLTNItem: UITextFieldDelegate {

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
