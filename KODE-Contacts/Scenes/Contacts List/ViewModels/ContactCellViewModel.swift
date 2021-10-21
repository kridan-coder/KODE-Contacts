//
//  ContactCellViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import Foundation

class ContactCellViewModel: ViewModel {
    var didReloadData: (() -> Void)?
    
    var data: Contact {
        didSet {
            didReloadData?()
        }
    }
    
    init(data: Contact) {
        self.data = data
    }
}
