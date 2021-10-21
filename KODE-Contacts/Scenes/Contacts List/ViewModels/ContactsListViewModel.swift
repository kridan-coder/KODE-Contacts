//
//  ContactsListViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import Foundation

protocol ContactsListViewModelDelegate: AnyObject {
    var didUpdate: (() -> Void)? { get set }
    func contactsListViewModel(_ contactsListViewModel: ContactsListViewModel, didRequestContactDetailsFor contact: Contact?)
}

class ContactsListViewModel: ViewModel {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    weak var delegate: ContactsListViewModelDelegate? {
        didSet {
            delegate?.didUpdate = { [weak self] in
                self?.reloadData()
            }
        }
    }
    
    var contacts: [ContactCellViewModel] = []
    
    var didReloadData: (() -> Void)?
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func deleteContact(at index: Int) throws {
        do {
            try dependencies.coreDataClient.deleteContact(contacts[index].data)
            contacts.remove(at: index)
        } catch let error {
            throw error
        }
    }
    
    func addButtonPressed() {
        delegate?.contactsListViewModel(self, didRequestContactDetailsFor: nil)
    }
    
    func reloadData() {
        let contacts = dependencies.coreDataClient.getAllContacts()
        self.contacts = contacts.map { ContactCellViewModel(data: $0) }
        didReloadData?()
    }
    
}
