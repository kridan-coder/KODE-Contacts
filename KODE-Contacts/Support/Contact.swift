//
//  Contact.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import Foundation

struct Contact {
    var name: String
    var lastName: String?
    var phoneNumber: String
    var avatarImagePath: String?
    var ringtone: Ringtone
    var notes: String?
    var uuid: String
    
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
                        notes: self.notes)
    }
    
    init(name: String,
         lastname: String? = nil,
         phoneNumber: String,
         avatarImagePath: String? = nil,
         ringtone: Ringtone = .classic,
         notes: String? = nil) {
        self.name = name
        self.lastName = lastname
        self.phoneNumber = phoneNumber
        self.avatarImagePath = avatarImagePath
        self.ringtone = ringtone
        self.notes = notes
        self.uuid = UUID().uuidString
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
