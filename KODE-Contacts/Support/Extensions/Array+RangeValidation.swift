//
//  Array+RangeValidation.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import Foundation

extension Array {
    func indexOutOfRange(_ index: Int) -> Bool {
        return index < 0 || index >= count
    }
    
    func element(at index: Int) -> Element? {
        guard !indexOutOfRange(index) else { return nil }
        return self[index]
    }
    
}
