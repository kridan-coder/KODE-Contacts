//
//  ContactsListViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import UIKit

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
                self?.loadDataFromDatabase()
            }
        }
    }
    
    var didUpdateData: (() -> Void)?
    
    var sections: [(Int, [ContactCellViewModel])] = []
    var titles: [String] = []
    
    private let collation = UILocalizedIndexedCollation.current()
    private let sortSelector = #selector(getter: CollationIndexable.collationString)
    private var sectionsDictionary: [Int: [ContactCellViewModel]] = [:]
    private var contacts: [ContactCellViewModel] = []
    private var filteredContacts: [ContactCellViewModel] = []
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func selectedRowAt(_ indexPath: IndexPath) {
        let contact = sections[indexPath.section].1[indexPath.row]
        delegate?.contactsListViewModel(self, didRequestContactDetailsFor: contact.data)
    }
    
    func filterContacts(with text: String) {
        guard !text.isEmpty else {
            discardFiltering()
            return
        }
        filteredContacts = contacts.filter {
            guard let safeLastName = $0.data.lastName else { return $0.data.name.replacingOccurrences(of: " ", with: "").contains(text) }
            return safeLastName.replacingOccurrences(of: " ", with: "").contains(text) || $0.data.name.replacingOccurrences(of: " ", with: "").contains(text)
        }
        setupData()
        didUpdateData?()
    }
    
    func discardFiltering() {
        filteredContacts = contacts
        setupData()
        didUpdateData?()
    }
    
    func deleteContact(at indexPath: IndexPath) throws {
        let contact = sections[indexPath.section].1[indexPath.row]
        do {
            try dependencies.coreDataClient.deleteContact(contact.data)
        } catch let error {
            throw error
        }
        contacts = contacts.filter { $0.data.uuid != contact.data.uuid }
        filteredContacts = contacts
        setupData()
    }
    
    func addButtonPressed() {
        delegate?.contactsListViewModel(self, didRequestContactDetailsFor: nil)
    }
    
    func loadDataFromDatabase() {
        let contacts = dependencies.coreDataClient.getAllContacts()
        self.contacts = contacts.map { ContactCellViewModel(data: $0) }
        filteredContacts = self.contacts
        setupData()
        didUpdateData?()
    }
    
    // MARK: - Private Methods
    private func setupData() {
        sectionsDictionary = [:]
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
        sections = sectionsDictionary.sorted { $0.key < $1.key }
        for item in sections {
            titles.append(collation.sectionIndexTitles[item.0])
        }
    }
    
}
