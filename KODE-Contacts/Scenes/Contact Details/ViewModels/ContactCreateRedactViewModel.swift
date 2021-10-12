//
//  ContactDetailsCreateRedactViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import Foundation

protocol ContactCreateRedactViewModelDelegate: AnyObject {
    func contactCreateRedactViewModel
    (_ contactCreateRedactViewModel: ContactCreateRedactViewModel, didFinishEditing contact: Contact)
    
    func contactCreateRedactViewModelDidCancelEditing
    (_ contactCreateRedactViewModel: ContactCreateRedactViewModel)
}

class ContactCreateRedactViewModel {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    weak var delegate: ContactCreateRedactViewModelDelegate?
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func editContactDidFinish() {
        // TODO: - Replace dummy with real data
        delegate?.contactCreateRedactViewModel(self, didFinishEditing: Contact(name: "Peter",
                                                                               lastName: "Griffin",
                                                                               phoneNumber: "82213252313",
                                                                               avatar: "Cutie"))
    }
    
    func editContactDidCancel() {
        delegate?.contactCreateRedactViewModelDidCancelEditing(self)
    }
    
}
