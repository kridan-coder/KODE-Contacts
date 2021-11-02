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
    
    var didUpdateContact: ((Contact) -> Void)?
    
    var rootNavigationController: UINavigationController
    
    private let dependencies: AppDependencies
    
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
    
    // MARK: - Private Methods
    private func startShow(contact: Contact) {
        rootNavigationController.navigationBar.prefersLargeTitles = false
        rootNavigationController.changeBackgroundColor(.almostWhite)
        
        let contactShowViewModel = ContactShowViewModel(contact: contact)
        contactShowViewModel.delegate = self
        didUpdateContact = { [weak contactShowViewModel] contact in
            contactShowViewModel?.contact = contact
            contactShowViewModel?.reloadData()
        }
        
        let contactShowViewController = ContactShowViewController(viewModel: contactShowViewModel)
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
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishEditing contact: Contact) {
        self.contact = contact
        didUpdateContact?(contact)
        rootNavigationController.dismiss(animated: true)
    }
    
    func contactCreateRedactViewModelDidCancelCreating(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    func contactCreateRedactViewModelDidCancelEditing(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
        rootNavigationController.dismiss(animated: true)
    }
    
}

// MARK: - ContactShowViewModelDelegate
extension ContactDetailsCoordinator: ContactShowViewModelDelegate {
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToOpen url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func contactShowViewModelDidCancel(_ contactShowViewModel: ContactShowViewModel) {
        delegate?.contactDetailsCoordinatorDidFinish(self)
    }
    
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToEdit contact: Contact) {
        startCreateRedact(contact: contact)
    }
    
}
