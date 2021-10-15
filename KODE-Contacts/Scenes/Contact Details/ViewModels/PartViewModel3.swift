//
//  ContactCreateRedactPartViewModel3.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

final class PartViewModel3: ContactCreateRedactPartViewModel3 {
    var didUpdateTextFields: (() -> Void)?
    
    var didAskToFocusNextTextField: (() -> Void)?
}
