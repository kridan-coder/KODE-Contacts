//
//  ContactCellViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import Foundation

class ContactCellViewModel: ViewModelEditable {
    // MARK: - Properties
    var didUpdateData: (() -> Void)?
    
    var contact: Contact {
        didSet {
            didUpdateData?()
        }
    }
    
    // MARK: - Init
    init(contact: Contact) {
        self.contact = contact
    }
    
    // MARK: - Public Methods
    @objc func sortSelector() -> String {
        contact.lastName ?? contact.name
    }
    
}
