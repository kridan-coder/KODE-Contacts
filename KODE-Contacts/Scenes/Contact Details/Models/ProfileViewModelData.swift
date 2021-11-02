//
//  PartView1Data.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import UIKit

struct ProfileViewModelData {
    let firstTextFieldPlaceholder: String?
    let secondTextFieldPlaceholder: String?
    let thirdTextFieldPlaceholder: String?
    var firstTextFieldText: String?
    var secondTextFieldText: String?
    var thirdTextFieldText: String?
    var avatarImage: UIImage?
    
    init(firstTextFieldPlaceholder: String? = R.string.localizable.firstName(),
         secondTextFieldPlaceholder: String? = R.string.localizable.lastName(),
         thirdTextFieldPlaceholder: String? = R.string.localizable.phone(),
         firstTextFieldText: String?,
         secondTextFieldText: String?,
         thirdTextFieldText: String?,
         avatarImage: UIImage?) {
        self.firstTextFieldPlaceholder = firstTextFieldPlaceholder
        self.secondTextFieldPlaceholder = secondTextFieldPlaceholder
        self.thirdTextFieldPlaceholder = thirdTextFieldPlaceholder
        self.firstTextFieldText = firstTextFieldText
        self.secondTextFieldText = secondTextFieldText
        self.thirdTextFieldText = thirdTextFieldText
        self.avatarImage = avatarImage
    }
    
}
