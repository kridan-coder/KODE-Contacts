//
//  ContactDetailsCreateRedactViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import Foundation

protocol ContactCreateRedactViewModelDelegate: AnyObject {
    func contactCreateRedactViewModel
    (_ contactCreateRedactViewModel: ContactCreateRedactViewModel, didFinishEditing contact: Contact)
    
    func contactCreateRedactViewModelDidCancelEditing
    (_ contactCreateRedactViewModel: ContactCreateRedactViewModel)
}

class ContactCreateRedactViewModel {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    weak var delegate: ContactCreateRedactViewModelDelegate?
    
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    var didAskToFocusNextTextField: (() -> Void)?
    
    var cellViewModels: [ContactCreateRedactPartViewModel] = []
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        setupViewModels()
    }
    
    func editContactDidFinish() {
        // TODO: - Replace dummy with real data
        delegate?.contactCreateRedactViewModel(self, didFinishEditing: Contact(name: "Peter",
                                                                               lastName: "Griffin",
                                                                               phoneNumber: "82213252313",
                                                                               avatarImage: "Cutie"))
    }
    
    func editContactDidCancel() {
        delegate?.contactCreateRedactViewModelDidCancelEditing(self)
    }
    
    // MARK: - Private Methods
    private func setupViewModels() {
        cellViewModels = []
        cellViewModels.append(PartViewModel1(data: PartView1Data()))
        cellViewModels.append(PartViewModel2())
        cellViewModels.append(PartViewModel3())
        
        for index in 0..<cellViewModels.count {
            cellViewModels[index].didAskToFocusNextTextField = {
                self.didAskToFocusNextTextField?()
            }
        }
        
        didFinishUpdating?()
    }
    
}
