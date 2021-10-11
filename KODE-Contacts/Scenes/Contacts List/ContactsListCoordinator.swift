//
//  ContactsListCoordinator.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import UIKit

final class ContactsListCoordinator: Coordinator {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    weak var delegate: Coordinator?
    
    var childCoordinators: [Coordinator]
    
    var rootNavigationController: UINavigationController
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        childCoordinators = []
        
        rootNavigationController = navigationController
        rootNavigationController.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Public Methods
    func start() {
        let contactsListViewModel = ContactsListViewModel(dependencies: dependencies)
        
        let contactsListViewController = ContactsListViewController(viewModel: contactsListViewModel)
        contactsListViewController.title = R.string.localizable.contacts()
        
        rootNavigationController.setViewControllers([contactsListViewController], animated: false)
    }
    
}
