//
//  ContactCreateRedactPartViewModel1.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

final class PartViewModel1: ContactCreateRedactPartViewModel1 {
    init(data: PartView1Data) {
        self.data = data
    }
    
    var data: PartView1Data {
        didSet {
            didUpdateTextFields?()
        }
    }
    
    var didUpdateTextFields: (() -> Void)?
    var didAskToFocusNextTextField: (() -> Void)?
}
