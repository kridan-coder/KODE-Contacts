//
//  ContactDetailsCoordinator.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

protocol ContactDetailsCoordinatorDelegate: AnyObject {
    func contactDetailsCoordinatorDidFinish(_ contactDetailsCoordinator: ContactDetailsCoordinator)
}

final class ContactDetailsCoordinator: Coordinator {
    // MARK: - Properties
    weak var delegate: ContactDetailsCoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    
    var rootNavigationController: UINavigationController
    
    private let dependencies: AppDependencies
    
    private var contactShowViewModel: ContactShowViewModel?
    
    private var contact: Contact?
    
    // MARK: - Init
    init(dependencies: AppDependencies, navigationController: UINavigationController, contact: Contact? = nil) {
        self.dependencies = dependencies
        self.contact = contact
        childCoordinators = []
        
        rootNavigationController = navigationController
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.backgroundColor = .navigationBarLight
    }
    
    // MARK: Public Methods
    func start() {
        if let contact = contact {
            startShow(contact: contact)
        } else {
            startCreateRedact()
        }
    }
    
    func finish() {
        rootNavigationController.dismiss(animated: true)
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    // MARK: - Private Methods
    private func startShow(contact: Contact) {
        rootNavigationController.navigationBar.prefersLargeTitles = false
        rootNavigationController.changeBackgroundColor(.almostWhite)
        
        contactShowViewModel = ContactShowViewModel(contact: contact)
        contactShowViewModel?.delegate = self
        
        let contactShowViewController = ContactShowViewController(viewModel: contactShowViewModel ??
                                                                    ContactShowViewModel(contact: contact))
        
        rootNavigationController.pushViewController(contactShowViewController, animated: true)
    }
    
    private func startCreateRedact(contact: Contact? = nil) {
        let contactCreateRedactViewModel = ContactCreateRedactViewModel(dependencies: dependencies, contact: contact)
        contactCreateRedactViewModel.delegate = self
        
        let contactCreateRedactViewController = ContactCreateRedactViewController(viewModel: contactCreateRedactViewModel)
        
        let contactCreateRedactNavigationController =
            UINavigationController.createDefaultNavigationController(backgroundColor: .white)
        contactCreateRedactNavigationController.setViewControllers([contactCreateRedactViewController], animated: false)
        contactCreateRedactNavigationController.presentationController?.delegate = contactCreateRedactViewController
        
        rootNavigationController.present(contactCreateRedactNavigationController, animated: true)
    }
    
}

// MARK: - ContactCreateRedactViewModelDelegate
extension ContactDetailsCoordinator: ContactCreateRedactViewModelDelegate {
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishCreating contact: Contact) {
        finish()
    }
    
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishEditing contact: Contact) {
        self.contact = contact
        contactShowViewModel?.contact = contact
        contactShowViewModel?.reloadData()
        rootNavigationController.dismiss(animated: true)
    }
    
    func contactCreateRedactViewModelDidCancelCreating(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
        finish()
    }
    
    func contactCreateRedactViewModelDidCancelEditing(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
        rootNavigationController.dismiss(animated: true)
    }
    
}

// MARK: - ContactShowViewModelDelegate
extension ContactDetailsCoordinator: ContactShowViewModelDelegate {
    func contactShowViewModelDidCancel(_ contactShowViewModel: ContactShowViewModel) {
        finish()
    }
    
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToEdit contact: Contact) {
        startCreateRedact(contact: contact)
    }
    
}
