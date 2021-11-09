//
//  RingtoneViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import UIKit

final class RingtoneViewModel: ContactRingtoneViewModel {
    var data: RingtoneViewModelData
    
    var didUpdateData: (() -> Void)?
    
    var textFieldDidAskToFocusNext: ((UITextField) -> Void)?
    var didBecomeActiveTextField: ((UITextField) -> Void)?
    
    init(data: RingtoneViewModelData) {
        self.data = data
    }
    
}
