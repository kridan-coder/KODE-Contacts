//
//  ContactsListViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import UIKit

protocol ContactsListViewModelDelegate: AnyObject {
    func contactsListViewModel(_ contactsListViewModel: ContactsListViewModel, didRequestContactDetailsFor contact: Contact)
    func contactListViewModelDidRequestToCreateContact(_ contactsListViewModel: ContactsListViewModel)
}

class ContactsListViewModel: ViewModel {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    weak var delegate: ContactsListViewModelDelegate?
    
    var didUpdateData: (() -> Void)?
    var didReceiveError: ((Error) -> Void)?
    var didRemoveRow: ((IndexPath) -> Void)?
    var didRemoveSection: ((IndexPath) -> Void)?
    
    var sections: [[ContactCellViewModel]] = []
    var titles: [String] = []
    
    private let collation = UILocalizedIndexedCollation.current()
    private let sortSelector = #selector(getter: CollationIndexable.collationString)
    private var contacts: [ContactCellViewModel] = []
    private var filteredContacts: [ContactCellViewModel] = []
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func selectedRowAt(_ indexPath: IndexPath) {
        let contact = sections[indexPath.section][indexPath.row]
        delegate?.contactsListViewModel(self, didRequestContactDetailsFor: contact.contact)
    }
    
    func filterContacts(with text: String) {
        guard !text.isEmpty else {
            discardFiltering()
            return
        }
        filteredContacts = contacts.filter {
            guard let safeLastName = $0.contact.lastName else {
                return $0.contact.name.withoutSpaces.contains(text)
            }
            return safeLastName.withoutSpaces.contains(text)
                || $0.contact.name.withoutSpaces.contains(text)
        }
        setupData()
        didUpdateData?()
    }
    
    func discardFiltering() {
        filteredContacts = contacts
        setupData()
        didUpdateData?()
    }
    
    func deleteContact(at indexPath: IndexPath) {
        let contact = sections[indexPath.section][indexPath.row]
        let needsToRemoveSection = sections[indexPath.section].count == 1
        do {
            try dependencies.coreDataClient.deleteContact(contact.contact)
        } catch let error {
            didReceiveError?(error)
            return
        }
        contacts = contacts.filter { $0.contact.uuid != contact.contact.uuid }
        filteredContacts = contacts
        setupData()
        
        if needsToRemoveSection {
            didRemoveSection?(indexPath)
        } else {
            didRemoveRow?(indexPath)
        }
    }
    
    func addContact() {
        delegate?.contactListViewModelDidRequestToCreateContact(self)
    }
    
    func loadDataFromDatabase() {
        let contacts = dependencies.coreDataClient.getAllContacts()
        self.contacts = contacts.map { ContactCellViewModel(contact: $0) }
        filteredContacts = self.contacts
        setupData()
        didUpdateData?()
    }
    
    // MARK: - Private Methods
    private func setupData() {
        var sectionsDictionary: [Int: [ContactCellViewModel]] = [:]
        sections = []
        titles = []
        filteredContacts = collation.sortedArray(from: filteredContacts,
                                                 collationStringSelector: sortSelector) as? [ContactCellViewModel] ?? []
        for contact in filteredContacts {
            let sectionNumber = collation.section(for: contact, collationStringSelector: sortSelector)
            if sectionsDictionary[sectionNumber] == nil {
                sectionsDictionary[sectionNumber] = []
            }
            sectionsDictionary[sectionNumber]?.append(contact)
        }
        let sortedSections = sectionsDictionary.sorted { $0.key < $1.key }
        for section in sortedSections {
            sections.append(section.value)
        }
        for section in sortedSections {
            titles.append(collation.sectionIndexTitles[section.key])
        }
    }
    
}
