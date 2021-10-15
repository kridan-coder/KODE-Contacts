//
//  ContactCreateRedactPartViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

protocol ContactCreateRedactPartViewModel {
    var didAskToFocusNextTextField: (() -> Void)? { get set }
    var didUpdateTextFields: (() -> Void)? { get set }
}

protocol ContactCreateRedactPartViewModel1: ContactCreateRedactPartViewModel {
    var data: PartView1Data { get set }
}

protocol ContactCreateRedactPartViewModel2: ContactCreateRedactPartViewModel {}

protocol ContactCreateRedactPartViewModel3: ContactCreateRedactPartViewModel {}
