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
    
    static func updatedText(currentText: String?,
                            replacementString: String,
                            replacementRange: NSRange) -> String? {
        guard let safeCurrentText = currentText,
              let stringRange = Range(replacementRange, in: safeCurrentText) else { return nil }
        return safeCurrentText.replacingCharacters(in: stringRange, with: replacementString)
    }
    
}
