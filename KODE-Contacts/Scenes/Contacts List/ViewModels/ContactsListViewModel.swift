//
//  ContactsListViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import Foundation

class ContactsListViewModel {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
