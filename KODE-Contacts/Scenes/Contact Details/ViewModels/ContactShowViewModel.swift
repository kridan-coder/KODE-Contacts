//
//  ContactShowViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import Foundation

protocol ContactShowViewModelDelegate: AnyObject {
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToEdit contact: Contact)
    func contactShowViewModelDidCancel(_ contactShowViewModel: ContactShowViewModel)
}

final class ContactShowViewModel {
    // MARK: - Properties
    var didFinishUpdating: (() -> Void)?
    
    var showViewModels: [ShowViewModel] = []
    
    var headerViewModel: HeaderViewModel?
    
    var contact: Contact
    
    var fullName: String {
        if let lastName = contact.lastName {
            return contact.name + " " + lastName
        } else {
            return contact.name
        }
    }
    
    weak var delegate: ContactShowViewModelDelegate?
    
    // MARK: - Init
    init(contact: Contact) {
        self.contact = contact
    }
    
    // MARK: - Public Methods
    func reloadData() {
        setupViewModels()
        didFinishUpdating?()
    }
    
    func requestToEdit() {
        delegate?.contactShowViewModel(self, didAskToEdit: contact)
    }
    
    func requestToCancel() {
        delegate?.contactShowViewModelDidCancel(self)
    }
    
    // MARK: - Private Methods
    private func setupViewModels() {
        let image = FileHandler.getSavedImage(with: contact.avatarImagePath)
        headerViewModel = HeaderViewModel(image: image,
                                          fullName: fullName)
        
        showViewModels = []
        let showPhoneViewModel = ShowViewModel(title: R.string.localizable.phone(),
                                               description: contact.phoneNumber)
        showViewModels.append(showPhoneViewModel)
        
        let showRingtoneViewModel = ShowViewModel(title: R.string.localizable.ringtone(),
                                                  description: contact.ringtone.localizedString)
        showViewModels.append(showRingtoneViewModel)
        
        guard let notes = contact.notes,
              !notes.isEmpty else { return }
        let showNotesViewModel = ShowViewModel(title: R.string.localizable.notes(),
                                               description: notes)
        showViewModels.append(showNotesViewModel)
    }
    
}
