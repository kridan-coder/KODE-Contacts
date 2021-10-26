//
//  Contact.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

struct Contact {
    var name: String
    var lastName: String?
    var phoneNumber: String
    var avatarImagePath: String?
    var ringtone: Ringtone
    var notes: String?
    var uuid: String
    
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
