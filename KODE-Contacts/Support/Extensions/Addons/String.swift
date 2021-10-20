//
//  String.swift
//  KODE-Contacts
//
//  Created by Developer on 20.10.2021.
//

import Foundation

extension String {
    // TODO: - Think about better validation if possible
    var validatedForSQLQuery: String {
        var safeText = self
        safeText = safeText.replacingOccurrences(of: "\"", with: "")
        return safeText
    }
}
