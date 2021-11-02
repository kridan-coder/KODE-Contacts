//
//  PartView3Data.swift
//  KODE-Contacts
//
//  Created by Developer on 18.10.2021.
//

import Foundation

struct NotesViewModelData {
    let titleLabelText: String
    let textFieldPlaceholder: String?
    var textFieldText: String?
    
    init(titleLabelText: String = R.string.localizable.notes(),
         textFieldPlaceholder: String? = R.string.localizable.wakeUpNeo(),
         textFieldText: String?) {
        self.titleLabelText = titleLabelText
        self.textFieldPlaceholder = textFieldPlaceholder
        self.textFieldText = textFieldText
    }
    
}
