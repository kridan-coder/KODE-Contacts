//
//  ViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import UIKit

protocol ViewModelEditable {
    var didUpdateData: (() -> Void)? { get set }
    
}

protocol ContactHeaderViewModel {
    var image: UIImage? { get }
    var fullName: String { get }
    
}

protocol ContactShowPartViewModel {
    var title: String { get }
    var description: String { get }
    var descriptionHasLink: Bool { get }
    func openLink()
    
}

protocol ContactCreateRedactPartViewModel: ViewModelEditable {
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
