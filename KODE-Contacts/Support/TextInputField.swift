//
//  TextInputField.swift
//  KODE-Contacts
//
//  Created by Daniil on 10.11.2021.
//

import UIKit

protocol TextInputField: UIView, UITextInput {
    var returnKeyType: UIReturnKeyType { get set }
    func becomeFirstResponder() -> Bool
    func resignFirstResponder() -> Bool
}

extension TextInputField where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.frame == rhs.frame
    }
}

extension UITextField: TextInputField {}

extension UITextView: TextInputField {}
