//
//  ContactNotesViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import Foundation

protocol ContactNotesViewModel: ContactCreateRedactPartViewModel {
    var data: NotesViewModelData { get set }
    
}
