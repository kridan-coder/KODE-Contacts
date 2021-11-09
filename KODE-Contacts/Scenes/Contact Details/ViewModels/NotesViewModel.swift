//
//  NotesViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import UIKit

final class NotesViewModel: ContactNotesViewModel {
    var data: NotesViewModelData
    
    var didUpdateData: (() -> Void)?
    
    var textInputFieldDidAskToFocusNext: ((TextInputField) -> Void)?
    
    var didBecomeActiveTextInputField: ((TextInputField) -> Void)?
    
    var textViewDidAskToAdjustView: (() -> Void)?
    
    init(data: NotesViewModelData) {
        self.data = data
    }
    
    func adjustViewToTextViewWithEnabledScroll() {
        textViewDidAskToAdjustView?()
    }
    
}
