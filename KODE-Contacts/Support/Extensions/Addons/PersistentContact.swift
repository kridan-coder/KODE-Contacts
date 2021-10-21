//
//  ObjectWithID.swift
//  KODE-Contacts
//
//  Created by Developer on 19.10.2021.
//

import CoreData

extension PersistentContact {
    
    func setupWithContact(_ contact: Contact) {
        self.phoneNumber = contact.phoneNumber
        self.avatarImagePath = contact.avatarImagePath
        self.lastName = contact.lastName
        self.notes = contact.notes
        self.ringtone = contact.ringtone.rawValue
        self.name = contact.name
        self.uuid = contact.uuid
    }
    
    var asContact: Contact {
        Contact(from: self)
    }
}
