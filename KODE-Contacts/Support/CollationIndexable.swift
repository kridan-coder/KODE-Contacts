//
//  CollationIndexable.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import Foundation

@objc protocol CollationIndexable {
    @objc var collationString: String { get }
    
}

extension ContactCellViewModel: CollationIndexable {
    @objc var collationString: String {
        return self.contact.lastName ?? self.contact.name
    }
    
}
