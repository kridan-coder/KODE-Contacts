//
//  ContactCellViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import Foundation

class ContactCellViewModel: ViewModel {
    var didUpdateData: (() -> Void)?
    
    var contact: Contact {
        didSet {
            didUpdateData?()
        }
    }
    
    init(contact: Contact) {
        self.contact = contact
    }
    
}
