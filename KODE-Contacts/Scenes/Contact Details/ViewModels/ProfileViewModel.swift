//
//  ContactCreateRedactPartViewModel1.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation
import PhoneNumberKit

final class ProfileViewModel: ContactProfileViewModel {
    // MARK: - Properties
    var data: ProfileViewModelData {
        didSet {
            phoneNumber = try? phoneNumberKit.parse(data.thirdTextFieldText ?? "")
        }
    }
    
    var phoneNumberString: String? {
        guard let safePhoneNumber = phoneNumber else { return nil }
        return phoneNumberKit.format(safePhoneNumber, toType: .international)
    }
    
    var didUpdateData: (() -> Void)?
    var didSetupImage: ((UIImage) -> Void)?
    var didAskToFocusNextTextField: (() -> Void)?
    var didAskToShowImagePicker: (() -> Void)?
    var didDoneAvailable: ((Bool) -> Void)?
    
    private let phoneNumberKit = PhoneNumberKit()
    private var phoneNumber: PhoneNumber?
    
    // MARK: - Init
    init(data: ProfileViewModelData) {
        self.data = data
    }
    
    // MARK: - Public Methods
    func showImagePicker() {
        didAskToShowImagePicker?()
    }
    
    func makeDoneAvailable() {
        didDoneAvailable?(true)
    }
    
    func makeDoneUnavailable() {
        didDoneAvailable?(false)
    }
}
