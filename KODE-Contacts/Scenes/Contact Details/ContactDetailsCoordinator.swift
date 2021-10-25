//
//  ContactDetailsCoordinator.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

final class ContactDetailsCoordinator: Coordinator {
    // MARK: - Properties
    weak var delegate: Coordinator?
    
    var childCoordinators: [Coordinator]
    
    var rootNavigationController: UINavigationController
    
    var didFinish: (() -> Void)?
    
    var contactShowViewModel: ContactShowViewModel?
    
    private let dependencies: AppDependencies
    
    private let contact: Contact?
    
    // MARK: - Init
    init(dependencies: AppDependencies, navigationController: UINavigationController, contact: Contact? = nil) {
        self.dependencies = dependencies
        self.contact = contact
        childCoordinators = []
        
        rootNavigationController = navigationController
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.backgroundColor = .navigationBarLightAppearance
    }
    
    // MARK: Public Methods
    func start() {
        if let contact = contact {
            startShow(contact: contact)
        } else {
            startCreateRedact(contact: contact)
        }
        
    }
    
    func finish() {
        didFinish?()
        rootNavigationController.dismiss(animated: true)
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.barTintColor = .white
        delegate?.removeAllChildCoordinatorsWithType(type(of: self))
    }
    
    // MARK: - Private Methods
    private func startShow(contact: Contact) {
        rootNavigationController.navigationBar.prefersLargeTitles = false
        rootNavigationController.navigationBar.barTintColor = .almostWhite
        
        contactShowViewModel = ContactShowViewModel(contact: contact)
        //contactShowViewModel.delegate = self
        
        let contactShowViewController = ContactShowViewController(viewModel: contactShowViewModel ?? ContactShowViewModel(contact: contact))
        
        rootNavigationController.pushViewController(contactShowViewController, animated: true)
    }
    
    private func startCreateRedact(contact: Contact?) {
        let contactCreateRedactViewModel = ContactCreateRedactViewModel(dependencies: dependencies, contact: contact)
        contactCreateRedactViewModel.delegate = self
        
        let contactCreateRedactViewController = ContactCreateRedactViewController(viewModel: contactCreateRedactViewModel)
        
        let contactCreateRedactNavigationController: UINavigationController = .transparentNavigationController
        contactCreateRedactNavigationController.setViewControllers([contactCreateRedactViewController], animated: false)
        contactCreateRedactNavigationController.presentationController?.delegate = contactCreateRedactViewController
        
        rootNavigationController.present(contactCreateRedactNavigationController, animated: true)
    }
    
}

// MARK: - ContactCreateRedactViewModelDelegate

extension ContactDetailsCoordinator: ContactCreateRedactViewModelDelegate {
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishEditing contact: Contact) {
        contactShowViewModel?.reloadData()
        rootNavigationController.dismiss(animated: true)
    }
    
    func contactCreateRedactViewModelDidCancelEditing(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
        rootNavigationController.dismiss(animated: true)
    }
    
}

extension ContactDetailsCoordinator: ContactShowViewModelDelegate {
    func contactShowViewModelDidCancel(_ contactShowViewModel: ContactShowViewModel) {
        finish()
    }
    
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToEdit contact: Contact) {
        startCreateRedact(contact: contact)
    }
    
}
