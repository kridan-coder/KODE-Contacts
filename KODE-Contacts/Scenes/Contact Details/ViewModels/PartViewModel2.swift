//
//  ContactCreateRedactPartViewModel2.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

final class PartViewModel2: ContactCreateRedactPartViewModel2 {
    var didUpdateTextFields: (() -> Void)?
    
    var didAskToFocusNextTextField: (() -> Void)?
}
