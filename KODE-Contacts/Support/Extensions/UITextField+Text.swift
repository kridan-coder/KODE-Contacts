//
//  UITextField+Text.swift
//  KODE-Contacts
//
//  Created by Developer on 29.10.2021.
//

import UIKit

extension UITextField {
    static func updatedText(currentText: String?,
                            replacementString: String,
                            replacementRange: NSRange) -> String? {
        guard let safeCurrentText = currentText,
              let stringRange = Range(replacementRange, in: safeCurrentText) else { return nil }
        return safeCurrentText.replacingCharacters(in: stringRange, with: replacementString)
    }
    
}
