//
//  PartView2Data.swift
//  KODE-Contacts
//
//  Created by Developer on 18.10.2021.
//

import Foundation

struct RingtoneViewModelData {
    var titleLabelText: String = R.string.localizable.ringtone()
    let pickerViewDataSet: [Ringtone] = Ringtone.allCases
    var pickedRingtone: Ringtone = .classic
    
}
