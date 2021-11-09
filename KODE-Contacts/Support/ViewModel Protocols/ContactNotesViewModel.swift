//
//  ContactNotesViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import Foundation

protocol ContactNotesViewModel: ContactCreateEditPartViewModel {
    var data: NotesViewModelData { get set }
    
}
