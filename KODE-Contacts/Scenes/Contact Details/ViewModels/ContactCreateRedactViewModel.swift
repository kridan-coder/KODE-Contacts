//
//  ContactDetailsCreateRedactViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

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
    var didAskToShowImagePicker: (() -> Void)?
    var didReceiveError: ((Error) -> Void)?
    
    var partViewModel1: PartViewModel1
    var partViewModel2: PartViewModel2
    var partViewModel3: PartViewModel3
    var cellViewModels: [ContactCreateRedactPartViewModel] = []
    
    var contact: Contact?
    var isCreatingContact: Bool
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies, contact: Contact?) {
        self.dependencies = dependencies
        self.contact = contact
        
        isCreatingContact = contact == nil
        
        partViewModel1 = PartViewModel1(data: PartView1Data())
        partViewModel2 = PartViewModel2(data: PartView2Data())
        partViewModel3 = PartViewModel3(data: PartView3Data())
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        setupViewModels()
    }
    
    func setupImage(_ image: UIImage) {
        partViewModel1.data.avatarImage = image
        partViewModel1.didReloadData?()
    }
    
    func editContactDidFinish() {
        guard let phoneNumberString = partViewModel1.phoneNumberString else {
            didReceiveError?(ValidationError.incorrectPhoneNumber)
            return
        }
        guard let name = partViewModel1.data.firstTextFieldText,
              !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            didReceiveError?(ValidationError.noFirstName)
            return
        }
        
        var newContact = contact ?? Contact(name: name, phoneNumber: phoneNumberString)
        newContact.lastName = partViewModel1.data.secondTextFieldText
        newContact.ringtone = partViewModel2.data.pickedRingtone
        newContact.avatarImagePath = FileHandler.saveImageAndReturnFilePath(partViewModel1.data.avatarImage,
                                                                            with: newContact.phoneNumber)
        newContact.notes = partViewModel3.data.textFieldText
        
        dependencies.coreDataClient.createContact(newContact)
        print(dependencies.coreDataClient.getAllContacts())
        delegate?.contactCreateRedactViewModel(self, didFinishEditing: newContact)
    }
    
    func editContactDidCancel() {
        delegate?.contactCreateRedactViewModelDidCancelEditing(self)
    }
    
    // MARK: - Private Methods
    private func setupViewModels() {
        cellViewModels = []
        partViewModel1.data = PartView1Data(firstTextFieldPlaceholder: R.string.localizable.firstName(),
                                            secondTextFieldPlaceholder: R.string.localizable.lastName(),
                                            thirdTextFieldPlaceholder: R.string.localizable.phone(),
                                            firstTextFieldText: contact?.name,
                                            secondTextFieldText: contact?.lastName,
                                            thirdTextFieldText: contact?.phoneNumber)
        
        partViewModel2.data = PartView2Data(pickedRingtone: contact?.ringtone ?? .classic)
        partViewModel3.data = PartView3Data(textFieldText: contact?.notes)
        cellViewModels.append(partViewModel1)
        cellViewModels.append(partViewModel2)
        cellViewModels.append(partViewModel3)
        bindToViewModels()
        didFinishUpdating?()
    }
    
    private func bindToViewModels() {
        partViewModel1.didAskToShowImagePicker = {
            self.didAskToShowImagePicker?()
        }
        
        for index in 0..<cellViewModels.count {
            cellViewModels[index].didAskToFocusNextTextField = {
                self.didAskToFocusNextTextField?()
            }
        }
    }
    
}
