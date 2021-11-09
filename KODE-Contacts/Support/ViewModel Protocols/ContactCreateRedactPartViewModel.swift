//
//  ContactCreateEditPartViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import UIKit

protocol ContactCreateEditPartViewModel: ViewModelEditable {
    var textFieldDidAskToFocusNext: ((UITextField) -> Void)? { get set }
    var didBecomeActiveTextField: ((UITextField) -> Void)? { get set }
    
}
