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
    var descriptionURL: URL? { get set }
    var didAskToOpenLink: ((URL?) -> Void)? { get set }
    
}

protocol ContactCreateRedactPartViewModel: ViewModel {
    var didAskToFocusNextTextField: (() -> Void)? { get set }
    
}

protocol ContactProfileViewModel: ContactCreateRedactPartViewModel {
    var data: ProfileViewModelData { get set }
    var didAskToShowImagePicker: (() -> Void)? { get set }
    var didDoneAvailable: ((Bool) -> Void)? { get set }
    var didSetupImage: ((UIImage) -> Void)? { get set }
    
}

protocol ContactRingtoneViewModel: ContactCreateRedactPartViewModel {
    var data: RingtoneViewModelData { get set }
    
}

protocol ContactNotesViewModel: ContactCreateRedactPartViewModel {
    var data: NotesViewModelData { get set }
    
}
