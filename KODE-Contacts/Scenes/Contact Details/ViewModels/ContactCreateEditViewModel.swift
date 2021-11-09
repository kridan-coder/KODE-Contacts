//
//  ContactDetailsCreateEditViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

enum CreateEditState {
    case create
    case edit(contact: Contact)
    
    init(contact: Contact?) {
        self = (contact != nil) ? .edit(contact: contact!) : .create
    }
}

protocol ContactCreateEditViewModelDelegate: AnyObject {
    func contactCreateEditViewModel(_ contactCreateEditViewModel: ContactCreateEditViewModel,
                                    didFinishCreating contact: Contact)
    
    func contactCreateEditViewModel(_ contactCreateEditViewModel: ContactCreateEditViewModel,
                                    didFinishEditing contact: Contact)
    
    func contactCreateEditViewModelDidCancelCreating(_ contactCreateEditViewModel: ContactCreateEditViewModel)
    
    func contactCreateEditViewModelDidCancelEditing(_ contactCreateEditViewModel: ContactCreateEditViewModel)
    
    func contactCreateEditViewModelDidAskToShowImagePicker(_ contactCreateEditViewModel: ContactCreateEditViewModel)
    
}

class ContactCreateEditViewModel {
    // MARK: - Types
    typealias Dependencies = HasCoreDataClientProvider
    
    // MARK: - Properties
    weak var delegate: ContactCreateEditViewModelDelegate?
    
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    var didDoneAvailable: ((Bool) -> Void)?
    var didAskToFocusNextTextInput: ((TextInputField) -> Void)?
    var didBecomeActiveTextInput: ((TextInputField) -> Void)?
    var didAskToShowImagePicker: (() -> Void)?
    var didReceiveError: ((Error) -> Void)?
    var didSetupImage: ((UIImage) -> Void)?
    var didAskToAdjustView: (() -> Void)?
    
    var cellViewModels: [ContactCreateEditPartViewModel] = []
    
    private var contact: Contact?
    private var contactCreating: ContactCreating
    private var state: CreateEditState
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies, state: CreateEditState) {
        self.dependencies = dependencies
        self.state = state
        
        switch state {
        case .edit(let contact):
            self.contact = contact
        default:
            break
        }

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
        do {
            try createOrEditContact()
        } catch {
            didReceiveError?(error)
        }
    }
    
    func cancel() {
        switch state {
        case .create:
            delegate?.contactCreateEditViewModelDidCancelCreating(self)
        case .edit:
            delegate?.contactCreateEditViewModelDidCancelEditing(self)
        }
    }
    
    func showImagePicker() {
        delegate?.contactCreateEditViewModelDidAskToShowImagePicker(self)
    }
    
    // MARK: - Private Methods
    private func createOrEditContact() throws {
        let contact = try formNewContact()
        switch state {
        case .create:
            try dependencies.coreDataClient.createContact(contact)
            delegate?.contactCreateEditViewModel(self, didFinishCreating: contact)
        case .edit:
            self.contact = contact
            try dependencies.coreDataClient.updateContact(contact)
            delegate?.contactCreateEditViewModel(self, didFinishEditing: contact)
        }
    }
    
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
        
        for viewModel in cellViewModels {
            viewModel.didBecomeActiveTextInputField = { [weak self] textInput in
                self?.didBecomeActiveTextInput?(textInput)
            }
            viewModel.textInputFieldDidAskToFocusNext = { [weak self] textInput in
                self?.didAskToFocusNextTextInput?(textInput)
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
        
        switch state {
        case .create:
            didDoneAvailable?(true)
        case .edit:
            viewModel.didDoneAvailable = { [weak self] available in
                self?.didDoneAvailable?(available)
            }
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
        
        viewModel.textViewDidAskToAdjustView = {
            self.didAskToAdjustView?()
        }
    }
    
}
