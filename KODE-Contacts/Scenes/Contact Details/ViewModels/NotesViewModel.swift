//
//  ContactCreateRedactPartViewModel3.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

final class NotesViewModel: ContactNotesViewModel {
    var data: NotesViewModelData
    
    var didUpdateData: (() -> Void)?
    
    var didAskToFocusNextTextField: (() -> Void)?
    
    init(data: NotesViewModelData) {
        self.data = data
    }
    
}
