//
//  ContactProfileViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import UIKit

protocol ContactProfileViewModel: ContactCreateRedactPartViewModel {
    var data: ProfileViewModelData { get set }
    var didSetupImage: ((UIImage) -> Void)? { get set }
    func showImagePicker()
    func makeDoneAvailable()
    func makeDoneUnavailable()
    
}
