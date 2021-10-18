//
//  Ringtone.swift
//  KODE-Contacts
//
//  Created by Developer on 18.10.2021.
//

import Foundation

enum Ringtone: String, CaseIterable {
    case classic, oldPhone, sencha, signal, waves
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
