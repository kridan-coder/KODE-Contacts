//
//  PartView2Data.swift
//  KODE-Contacts
//
//  Created by Developer on 18.10.2021.
//

import Foundation

struct PartView2Data {
    var titleLabelText: String = R.string.localizable.ringtone()
    var pickerViewDataSet: [Ringtone] = Ringtone.allCases
    var pickedRingtone: Ringtone = .classic
}
