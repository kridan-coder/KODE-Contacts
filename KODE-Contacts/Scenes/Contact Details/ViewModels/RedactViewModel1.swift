//
//  ContactCreateRedactPartViewModel1.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation
import PhoneNumberKit

final class RedactViewModel1: ContactCreateRedactPartViewModel1 {
    // MARK: - Properties
    var data: PartView1Data {
        didSet {
            phoneNumber = try? phoneNumberKit.parse(data.thirdTextFieldText ?? "")
        }
    }
    
    var phoneNumberString: String? {
        guard let safePhoneNumber = phoneNumber else { return nil }
        return phoneNumberKit.format(safePhoneNumber, toType: .international)
        
    }
    
    var didUpdateData: (() -> Void)?
    var didAskToFocusNextTextField: (() -> Void)?
    var didAskToShowImagePicker: (() -> Void)?
    var didFillNeededField: (() -> Void)?
    var didEmptyNeededField: (() -> Void)?
    
    private let phoneNumberKit = PhoneNumberKit()
    private var phoneNumber: PhoneNumber?
    
    // MARK: - Init
    init(data: PartView1Data) {
        self.data = data
    }
    
}
