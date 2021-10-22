//
//  ContactCreateRedactPartViewModel2.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

final class RedactViewModel2: ContactCreateRedactPartViewModel2 {
    var data: PartView2Data
    
    var didUpdateData: (() -> Void)?
    
    var didAskToFocusNextTextField: (() -> Void)?
    
    init(data: PartView2Data) {
        self.data = data
    }
}
