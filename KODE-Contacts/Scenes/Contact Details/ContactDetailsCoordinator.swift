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
    
    private let dependencies: AppDependencies
    
    private let contact: Contact?
    
    // MARK: - Init
    init(dependencies: AppDependencies, navigationController: UINavigationController, contact: Contact?) {
        self.dependencies = dependencies
        self.contact = contact
        childCoordinators = []
        
        rootNavigationController = navigationController
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.backgroundColor = .navigationBarLightAppearance
    }
    
    // MARK: Public Methods
    func start() {
        let contactCreateRedactViewModel = ContactCreateRedactViewModel(dependencies: dependencies, contact: contact)
        contactCreateRedactViewModel.delegate = self
        
        let contactCreateRedactViewController = ContactCreateRedactViewController(viewModel: contactCreateRedactViewModel)
        
        let contactCreateRedactNavigationController: UINavigationController = .transparentNavigationController
        contactCreateRedactNavigationController.setViewControllers([contactCreateRedactViewController], animated: false)
        contactCreateRedactNavigationController.presentationController?.delegate = contactCreateRedactViewController
        
        rootNavigationController.present(contactCreateRedactNavigationController, animated: true)
    }
    
    func finish() {
        didFinish?()
        rootNavigationController.dismiss(animated: true)
        delegate?.removeAllChildCoordinatorsWithType(type(of: self))
    }

}

// MARK: - ContactCreateRedactViewModelDelegate

extension ContactDetailsCoordinator: ContactCreateRedactViewModelDelegate {
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishEditing contact: Contact) {
        finish()
    }
    
    func contactCreateRedactViewModelDidCancelEditing(_ contactCreateRedactViewModel: ContactCreateRedactViewModel) {
        finish()
    }
    
}
