//
//  EmailFieldBLTNItem.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 22.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import BLTNBoard

class PasswordFieldBLTNItem: TextFieldBLTNItem {

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: self.placeholder, returnKey: .done, delegate: self)
        textField.isSecureTextEntry = true
        return [textField]
    }

}
