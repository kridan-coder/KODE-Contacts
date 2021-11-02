//
//  UITextField+Text.swift
//  KODE-Contacts
//
//  Created by Developer on 29.10.2021.
//

import UIKit

extension String {
    func updatedText(replacementString: String,
                     replacementRange: NSRange) -> String? {
        guard let stringRange = Range(replacementRange, in: self) else { return nil }
        return self.replacingCharacters(in: stringRange, with: replacementString)
    }
    
}
