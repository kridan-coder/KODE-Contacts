//
//  ContactCreateRedactPartViewModel3.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

final class PartViewModel3: ContactCreateRedactPartViewModel3 {
    var data: PartView3Data
    
    var didReloadData: (() -> Void)?
    
    var didAskToFocusNextTextField: (() -> Void)?
    
    init(data: PartView3Data) {
        self.data = data
    }
}
