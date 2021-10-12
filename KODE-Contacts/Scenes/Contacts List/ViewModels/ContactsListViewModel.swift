//
//  ContactsListViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import Foundation

protocol ContactsListViewModelDelegate: AnyObject {
    func contactsListViewModel(_ contactsListViewModel: ContactsListViewModel, didRequestContactDetailsFor contact: Contact?)
}

class ContactsListViewModel {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    weak var delegate: ContactsListViewModelDelegate?
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func addButtonPressed() {
        delegate?.contactsListViewModel(self, didRequestContactDetailsFor: nil)
    }
    
}
