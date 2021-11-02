//
//  ContactShowViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import Foundation

protocol ContactShowViewModelDelegate: AnyObject {
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToOpen url: URL)
    func contactShowViewModel(_ contactShowViewModel: ContactShowViewModel, didAskToEdit contact: Contact)
    func contactShowViewModelDidCancel(_ contactShowViewModel: ContactShowViewModel)
}

final class ContactShowViewModel {
    // MARK: - Properties
    var didFinishUpdating: (() -> Void)?
    
    var showViewModels: [ShowViewModel] = []
    
    var headerViewModel: ContactHeaderViewModel?
    
    var contact: Contact
    
    weak var delegate: ContactShowViewModelDelegate?
    
    // MARK: - Init
    init(contact: Contact) {
        self.contact = contact
    }
    
    // MARK: - Public Methods
    func reloadData() {
        setupViewModels()
        bindToViewModels()
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
                                          fullName: contact.fullName)
        
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
    
    private func bindToViewModels() {
        for viewModel in showViewModels {
            viewModel.didAskToOpenLink = { [weak self] url in
                self?.requestToOpenLink(link: url)
            }
        }
    }
    
    private func requestToOpenLink(link: URL?) {
        guard let safeLink = link else { return }
        delegate?.contactShowViewModel(self, didAskToOpen: safeLink)
    }
    
}
