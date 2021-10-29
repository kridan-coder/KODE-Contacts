//
//  ContactCreateRedactPartViewModel2.swift
//  KODE-Contacts
//
//  Created by Developer on 15.10.2021.
//

import Foundation

final class RingtoneViewModel: ContactRingtoneViewModel {
    var data: RingtoneViewModelData
    
    var didUpdateData: (() -> Void)?
    
    var didAskToFocusNextTextField: (() -> Void)?
    
    init(data: RingtoneViewModelData) {
        self.data = data
    }
    
}
