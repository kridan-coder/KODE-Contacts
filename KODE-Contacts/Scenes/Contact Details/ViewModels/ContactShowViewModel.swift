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
    var didFinishUpdating: (() -> Void)?
    
    var showViewModels: [ShowViewModel] = []
    
    var headerViewModel: HeaderViewModel
    
    private var contact: Contact
    
    weak var delegate: ContactShowViewModelDelegate?
    
    // MARK: - Init
    init(contact: Contact) {
        self.contact = contact
        
        let fullName: String
        if let lastName = contact.lastName {
            fullName = contact.name + " " + lastName
        } else {
            fullName = contact.name
        }
        let image = FileHandler.getSavedImage(with: contact.avatarImagePath)
        headerViewModel = HeaderViewModel(image: image,
                                          fullName: fullName)
        
    }
    
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
    
    private func setupViewModels() {
        let image = FileHandler.getSavedImage(with: contact.avatarImagePath)
        
        let fullName: String
        if let lastName = contact.lastName {
            fullName = contact.name + " " + lastName
        } else {
            fullName = contact.name
        }
        
        headerViewModel = HeaderViewModel(image: image,
                                          fullName: fullName)
        
        showViewModels = []
        let showPhoneViewModel = ShowViewModel(title: R.string.localizable.phone(),
                                               description: contact.phoneNumber,
                                               descriptionIsClickable: true)
        showViewModels.append(showPhoneViewModel)
        
        let showRingtoneViewModel = ShowViewModel(title: R.string.localizable.ringtone(),
                                                  description: contact.ringtone.localizedString,
                                                  descriptionIsClickable: false)
        showViewModels.append(showRingtoneViewModel)
        
        guard let notes = contact.notes else { return }
        let showNotesViewModel = ShowViewModel(title: R.string.localizable.notes(),
                                               description: notes,
                                               descriptionIsClickable: false)
        showViewModels.append(showNotesViewModel)
    }
    
}
