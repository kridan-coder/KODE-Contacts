//
//  ContactCreateEditPartViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import UIKit

protocol ContactCreateEditPartViewModel: ViewModelEditable {
    var textInputFieldDidAskToFocusNext: ((TextInputField) -> Void)? { get set }
    var didBecomeActiveTextInputField: ((TextInputField) -> Void)? { get set }
    
}
