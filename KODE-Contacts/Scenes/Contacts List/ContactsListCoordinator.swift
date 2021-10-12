//
//  ContactsListCoordinator.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import UIKit

final class ContactsListCoordinator: Coordinator {
    // MARK: - Properties
    weak var delegate: Coordinator?
    
    var childCoordinators: [Coordinator]
    
    var rootNavigationController: UINavigationController
    
    private let dependencies: AppDependencies
    
    // MARK: - Init
    init(dependencies: AppDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        childCoordinators = []
        
        rootNavigationController = navigationController
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.backgroundColor = .navigationBarLightAppearance
    }
    
    // MARK: Public Methods
    func start() {
        let contactsListViewModel = ContactsListViewModel(dependencies: dependencies)
        contactsListViewModel.delegate = self
        
        let contactsListViewController = ContactsListViewController(viewModel: contactsListViewModel)
        contactsListViewController.title = R.string.localizable.contacts()
        
        rootNavigationController.setViewControllers([contactsListViewController], animated: false)
    }
    
}

// MARK: - ContactsListViewModelDelegate

extension ContactsListCoordinator: ContactsListViewModelDelegate {
    func contactsListViewModel(_ contactsListViewModel: ContactsListViewModel, didRequestContactDetailsFor contact: Contact?) {
        let contactDetailsCoordinator = ContactDetailsCoordinator(dependencies: dependencies,
                                                                  navigationController: rootNavigationController,
                                                                  contact: contact)
        contactDetailsCoordinator.delegate = self
        self.childCoordinators.append(contactDetailsCoordinator)
        contactDetailsCoordinator.start()
    }
    
}
