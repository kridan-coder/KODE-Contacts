//
//  ViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import UIKit

protocol ViewModel {
    var didUpdateData: (() -> Void)? { get set }
    
}

protocol ContactShowPartViewModel: ViewModel {
    var title: String { get set }
    var description: String { get set }
    var descriptionHasLink: Bool { get set }
    func openLink()
    
}

protocol ContactCreateRedactPartViewModel: ViewModel {
    var didAskToFocusNextTextField: (() -> Void)? { get set }
    
}

protocol ContactProfileViewModel: ContactCreateRedactPartViewModel {
    var data: ProfileViewModelData { get set }
    var didSetupImage: ((UIImage) -> Void)? { get set }
    func showImagePicker()
    func makeDoneAvailable()
    func makeDoneUnavailable()
    
}

protocol ContactRingtoneViewModel: ContactCreateRedactPartViewModel {
    var data: RingtoneViewModelData { get set }
    
}

protocol ContactNotesViewModel: ContactCreateRedactPartViewModel {
    var data: NotesViewModelData { get set }
    
}
