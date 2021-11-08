//
//  ContactCreateRedactPartViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import Foundation

protocol ContactCreateRedactPartViewModel: ViewModelEditable {
    var didAskToFocusNextTextField: (() -> Void)? { get set }
    
}
