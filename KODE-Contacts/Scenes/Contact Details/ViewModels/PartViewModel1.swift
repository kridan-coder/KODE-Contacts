//
//  ContactCreateRedactPartViewModel1.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

final class PartViewModel1: ContactCreateRedactPartViewModel1 {
    var data: PartView1Data
    
    var didReloadData: (() -> Void)?
    var didAskToFocusNextTextField: (() -> Void)?
    var didAskToShowImagePicker: (() -> Void)?
    
    init(data: PartView1Data) {
        self.data = data
    }
}
