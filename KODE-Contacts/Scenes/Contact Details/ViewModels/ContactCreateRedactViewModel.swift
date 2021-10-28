//
//  ContactDetailsCreateRedactViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

protocol ContactCreateRedactViewModelDelegate: AnyObject {
    func contactCreateRedactViewModel
    (_ contactCreateRedactViewModel: ContactCreateRedactViewModel, didFinishCreating contact: Contact)
    
    func contactCreateRedactViewModel
    (_ contactCreateRedactViewModel: ContactCreateRedactViewModel, didFinishEditing contact: Contact)
    
    func contactCreateRedactViewModelDidCancelCreating
    (_ contactCreateRedactViewModel: ContactCreateRedactViewModel)
    
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
    var didFillNeededField: (() -> Void)?
    var didEmptyNeededField: (() -> Void)?
    var didAskToFocusNextTextField: (() -> Void)?
    var didAskToShowImagePicker: (() -> Void)?
    var didReceiveError: ((Error) -> Void)?
    
    var cellViewModels: [ContactCreateRedactPartViewModel] = []
    
    private var partViewModel1: RedactViewModel1
    private var partViewModel2: RedactViewModel2
    private var partViewModel3: RedactViewModel3
    
    private var contact: Contact?
    private var isCreatingContact: Bool
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies, contact: Contact?) {
        self.dependencies = dependencies
        self.contact = contact
        
        isCreatingContact = contact == nil
        
        partViewModel1 = RedactViewModel1(data: PartView1Data())
        partViewModel2 = RedactViewModel2(data: PartView2Data())
        partViewModel3 = RedactViewModel3(data: PartView3Data())
    }
    
    // MARK: - Public Methods
    func reloadData() {
        setupViewModels()
    }
    
    func setupImage(_ image: UIImage) {
        partViewModel1.data.avatarImage = image
        partViewModel1.didUpdateData?()
    }
    
    func editContactDidFinish() {
        let newContact: Contact
        do {
            try newContact = formNewContact()
        } catch let error {
            didReceiveError?(error)
            return
        }
        
        if isCreatingContact {
            
            do {
                try dependencies.coreDataClient.createContact(newContact)
                delegate?.contactCreateRedactViewModel(self, didFinishCreating: newContact)
            } catch let error {
                didReceiveError?(error)
                return
            }
            
        } else {
            
            do {
                try dependencies.coreDataClient.updateContact(newContact)
                delegate?.contactCreateRedactViewModel(self, didFinishEditing: newContact)
            } catch let error {
                didReceiveError?(error)
                return
            }
        }
    }
    
    func editContactDidCancel() {
        if isCreatingContact {
            delegate?.contactCreateRedactViewModelDidCancelCreating(self)
        } else {
            delegate?.contactCreateRedactViewModelDidCancelEditing(self)
        }
    }
    
    // MARK: - Private Methods
    private func formNewContact() throws -> Contact {
        guard let phoneNumberString = partViewModel1.phoneNumberString else {
            throw ValidationError.incorrectPhoneNumber
        }
        guard let name = partViewModel1.data.firstTextFieldText,
              !name.withoutSpaces.isEmpty else {
            throw ValidationError.noFirstName
        }
        
        contact?.name = name
        contact?.phoneNumber = phoneNumberString
        var newContact = contact ?? Contact(name: name, phoneNumber: phoneNumberString)
        newContact.lastName = partViewModel1.data.secondTextFieldText
        newContact.ringtone = partViewModel2.data.pickedRingtone
        newContact.avatarImagePath = FileHandler.saveImageAndReturnFilePath(partViewModel1.data.avatarImage,
                                                                            with: newContact.uuid)
        newContact.notes = partViewModel3.data.textFieldText
        return newContact
    }
    
    private func setupViewModels() {
        cellViewModels = []
        partViewModel1.data = PartView1Data(firstTextFieldText: contact?.name,
                                            secondTextFieldText: contact?.lastName,
                                            thirdTextFieldText: contact?.phoneNumber,
                                            avatarImage: FileHandler.getSavedImage(with: contact?.avatarImagePath)
                                                ?? .placeholderAdd)
        
        partViewModel2.data = PartView2Data(pickedRingtone: contact?.ringtone ?? .classic)
        partViewModel3.data = PartView3Data(textFieldText: contact?.notes)
        cellViewModels.append(partViewModel1)
        cellViewModels.append(partViewModel2)
        cellViewModels.append(partViewModel3)
        bindToViewModels()
        didFinishUpdating?()
    }
    
    private func bindToViewModels() {
        partViewModel1.didAskToShowImagePicker = { [weak self] in
            self?.didAskToShowImagePicker?()
        }
        partViewModel1.didFillNeededField = { [weak self] in
            self?.didFillNeededField?()
        }
        partViewModel1.didEmptyNeededField = { [weak self] in
            self?.didEmptyNeededField?()
        }
        
        for index in 0..<cellViewModels.count {
            cellViewModels[index].didAskToFocusNextTextField = { [weak self] in
                self?.didAskToFocusNextTextField?()
            }
        }
    }
    
}
