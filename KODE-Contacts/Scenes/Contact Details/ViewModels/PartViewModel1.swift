//
//  ContactCreateRedactPartViewModel1.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation
import PhoneNumberKit

final class PartViewModel1: ContactCreateRedactPartViewModel1 {
    private let phoneNumberKit = PhoneNumberKit()
    
    var data: PartView1Data {
        didSet {
            phoneNumber = try? phoneNumberKit.parse(data.thirdTextFieldText ?? "")
        }
    }
    
    private var phoneNumber: PhoneNumber?
    
    var phoneNumberString: String? {
        guard let safePhoneNumber = phoneNumber else { return nil }
        return phoneNumberKit.format(safePhoneNumber, toType: .international)
        
    }
    
    var didReloadData: (() -> Void)?
    var didAskToFocusNextTextField: (() -> Void)?
    var didAskToShowImagePicker: (() -> Void)?
    
    init(data: PartView1Data) {
        self.data = data
    }
}
