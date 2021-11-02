//
//  Contact.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import Foundation

struct Contact {
    let name: String
    let lastName: String?
    let phoneNumber: String
    let avatarImagePath: String?
    let ringtone: Ringtone
    let notes: String?
    let uuid: String
    
    var fullName: String {
        if let lastName = self.lastName {
            return name + " " + lastName
        } else {
            return name
        }
    }
    
    var asContactCreating: ContactCreating? {
        ContactCreating(name: self.name,
                        lastName: self.lastName,
                        phoneNumber: self.phoneNumber,
                        avatarImage: FileHandler.getSavedImage(with: avatarImagePath),
                        ringtone: self.ringtone,
                        notes: self.notes,
                        uuid: self.uuid)
    }
    
    init(name: String,
         lastName: String? = nil,
         phoneNumber: String,
         avatarImagePath: String? = nil,
         ringtone: Ringtone = .classic,
         notes: String? = nil,
         uuid: String) {
        self.name = name
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.avatarImagePath = avatarImagePath
        self.ringtone = ringtone
        self.notes = notes
        self.uuid = uuid
    }
    
    init(from persistentContact: PersistentContact) {
        name = persistentContact.name ?? ""
        lastName = persistentContact.lastName
        phoneNumber = persistentContact.phoneNumber ?? ""
        avatarImagePath = persistentContact.avatarImagePath
        ringtone = Ringtone(rawValue: persistentContact.ringtone ?? "") ?? .classic
        notes = persistentContact.notes
        uuid = persistentContact.uuid ?? UUID().uuidString
    }
    
}
