//
//  RingtoneViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import UIKit

final class RingtoneViewModel: ContactRingtoneViewModel {
    var textInputFieldDidAskToFocusNext: ((TextInputField) -> Void)?
    
    var didBecomeActiveTextInputField: ((TextInputField) -> Void)?
    
    var data: RingtoneViewModelData
    
    var didUpdateData: (() -> Void)?
    
    init(data: RingtoneViewModelData) {
        self.data = data
    }
    
}
