//
//  ContactDetailsCreateRedactViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

protocol ContactCreateRedactViewModelDelegate: AnyObject {
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishCreating contact: Contact)
    
    func contactCreateRedactViewModel(_ contactCreateRedactViewModel: ContactCreateRedactViewModel,
                                      didFinishEditing contact: Contact)
    
    func contactCreateRedactViewModelDidCancelCreating(_ contactCreateRedactViewModel: ContactCreateRedactViewModel)
    
    func contactCreateRedactViewModelDidCancelEditing(_ contactCreateRedactViewModel: ContactCreateRedactViewModel)
}

class ContactCreateRedactViewModel {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    weak var delegate: ContactCreateRedactViewModelDelegate?
    
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    var didDoneAvailable: ((Bool) -> Void)?
    var didAskToFocusNextTextField: (() -> Void)?
    var didAskToShowImagePicker: (() -> Void)?
    var didReceiveError: ((Error) -> Void)?
    var didSetupImage: ((UIImage) -> Void)?
    
    var cellViewModels: [ContactCreateRedactPartViewModel] = []
    
    private var contact: Contact?
    private var contactCreating: ContactCreating
    private var isCreatingContact: Bool
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies, contact: Contact?) {
        self.dependencies = dependencies
        self.contact = contact
        
        isCreatingContact = contact == nil
        contactCreating = contact?.asContactCreating ?? ContactCreating()
    }
    
    // MARK: - Public Methods
    func reloadData() {
        setupViewModels()
    }
    
    func setupImage(_ image: UIImage) {
        contactCreating.avatarImage = image
        didSetupImage?(image)
    }
    
    func saveContact() {
        let newContact: Contact
        do {
            try newContact = formNewContact()
            contact = newContact
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
    
    func cancel() {
        if isCreatingContact {
            delegate?.contactCreateRedactViewModelDidCancelCreating(self)
        } else {
            delegate?.contactCreateRedactViewModelDidCancelEditing(self)
        }
    }
    
    // MARK: - Private Methods
    private func formNewContact() throws -> Contact {
        guard let phoneNumberString = contactCreating.phoneNumber else {
            throw ValidationError.incorrectPhoneNumber
        }
        guard let name = contactCreating.name,
              !name.withoutSpacesAndNewLines.isEmpty else {
                  throw ValidationError.noFirstName
              }
        
        let uuid = contactCreating.uuid ?? UUID().uuidString
        let avatarImagePath: String?
        if FileHandler.saveImageWithKey(contactCreating.avatarImage, key: uuid) {
            avatarImagePath = FileHandler.getSavedImagePath(with: uuid)
        } else {
            avatarImagePath = nil
        }
        let newContact = Contact(name: name,
                                 lastName: contactCreating.lastName,
                                 phoneNumber: phoneNumberString,
                                 avatarImagePath: avatarImagePath,
                                 ringtone: contactCreating.ringtone,
                                 notes: contactCreating.notes,
                                 uuid: uuid)
        return newContact
    }
    
    private func setupViewModels() {
        cellViewModels = []
        setupProfileViewModel()
        setupRingtoneViewModel()
        setupNotesViewModel()
        for index in 0..<cellViewModels.count {
            cellViewModels[index].didAskToFocusNextTextField = { [weak self] in
                self?.didAskToFocusNextTextField?()
            }
        }
        didFinishUpdating?()
    }
    
    private func setupProfileViewModel() {
        let data = ProfileViewModelData(firstTextFieldText: contact?.name,
                                        secondTextFieldText: contact?.lastName,
                                        thirdTextFieldText: contact?.phoneNumber,
                                        avatarImage: FileHandler.getSavedImage(with: contact?.avatarImagePath)
                                        ?? R.image.placeholder())
        let viewModel = ProfileViewModel(data: data)
        cellViewModels.append(viewModel)
        
        self.didSetupImage = { [weak viewModel] image in
            viewModel?.data.avatarImage = image
            viewModel?.didSetupImage?(image)
        }
        
        viewModel.didAskToShowImagePicker = { [weak self] in
            self?.didAskToShowImagePicker?()
        }
        
        viewModel.didUpdateData = { [weak viewModel] in
            self.contactCreating.name = viewModel?.data.firstTextFieldText
            self.contactCreating.lastName = viewModel?.data.secondTextFieldText
            self.contactCreating.phoneNumber = viewModel?.phoneNumberString
        }
        
        guard isCreatingContact else {
            didDoneAvailable?(true)
            return
        }
        
        viewModel.didDoneAvailable = { [weak self] available in
            self?.didDoneAvailable?(available)
        }
        
    }
    
    private func setupRingtoneViewModel() {
        let data = RingtoneViewModelData(pickedRingtone: contact?.ringtone ?? .classic)
        let viewModel = RingtoneViewModel(data: data)
        cellViewModels.append(viewModel)
        
        viewModel.didUpdateData = { [weak viewModel] in
            guard let ringtone = viewModel?.data.pickedRingtone else { return }
            self.contactCreating.ringtone = ringtone
        }
    }
    
    private func setupNotesViewModel() {
        let data = NotesViewModelData(textFieldText: contact?.notes)
        let viewModel = NotesViewModel(data: data)
        cellViewModels.append(viewModel)
        
        viewModel.didUpdateData = { [weak viewModel] in
            self.contactCreating.notes = viewModel?.data.textFieldText
        }
    }
    
}
