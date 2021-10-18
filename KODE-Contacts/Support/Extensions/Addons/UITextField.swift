//
//  UITextField.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

extension UITextField {
    static var emptyTextField: UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        return textField
    }
    
    static func updatedTextIsValid(currentText: String,
                                        replacementString: String,
                                        replacementRange: NSRange,
                                        limit: Int) -> Bool {

        guard let stringRange = Range(replacementRange, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementString)
        return updatedText.count <= limit
    }
}
