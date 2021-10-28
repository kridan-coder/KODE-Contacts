//
//  ContactsListCoordinator.swift
//  KODE-Contacts
//
//  Created by Developer on 11.10.2021.
//

import UIKit

final class ContactsListCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator]
    
    var rootNavigationController: UINavigationController
    
    private let dependencies: AppDependencies
    
    private var contactsListViewModel: ContactsListViewModel?
    
    // MARK: - Init
    init(dependencies: AppDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        childCoordinators = []
        
        rootNavigationController = navigationController
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.backgroundColor = .navigationBarLight
    }
    
    // MARK: Public Methods
    func start() {
        contactsListViewModel = ContactsListViewModel(dependencies: dependencies)
        contactsListViewModel?.delegate = self
        
        let contactsListViewController = ContactsListViewController(viewModel: contactsListViewModel ??
                                                                        ContactsListViewModel(dependencies: dependencies))
        contactsListViewController.title = R.string.localizable.contacts()
        
        rootNavigationController.setViewControllers([contactsListViewController], animated: false)
    }
    
    // MARK: - Private Methods
    private func startDetails(with contact: Contact?) {
        let contactDetailsCoordinator = ContactDetailsCoordinator(dependencies: dependencies,
                                                                  navigationController: rootNavigationController,
                                                                  contact: contact)
        contactDetailsCoordinator.delegate = self
        self.childCoordinators.append(contactDetailsCoordinator)
        contactDetailsCoordinator.start()
    }
    
}

// MARK: - ContactsListViewModelDelegate
extension ContactsListCoordinator: ContactsListViewModelDelegate {
    func contactsListViewModel(_ contactsListViewModel: ContactsListViewModel, didRequestContactDetailsFor contact: Contact) {
        startDetails(with: contact)
    }
    
    func contactListViewModelDidRequestToCreateContact(_ contactsListViewModel: ContactsListViewModel) {
        startDetails(with: nil)
    }
    
}

extension ContactsListCoordinator: ContactDetailsCoordinatorDelegate {
    func contactDetailsCoordinatorDidFinish(_ contactDetailsCoordinator: ContactDetailsCoordinator) {
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.changeBackgroundColor(.navigationBarLight)
        contactsListViewModel?.loadDataFromDatabase()
        removeAllChildCoordinatorsWithType(type(of: contactDetailsCoordinator))
    }
    
}
