//
//  String.swift
//  KODE-Contacts
//
//  Created by Developer on 20.10.2021.
//

import Foundation

extension String {
    var withoutSpacesAndNewLines: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
