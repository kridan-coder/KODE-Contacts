//
//  ShowViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 22.10.2021.
//

import Foundation

final class ShowViewModel: ContactShowPartViewModel {
    var didUpdateData: (() -> Void)?
    
    var title: String
    var description: String
    var descriptionIsClickable: Bool
    
    init(title: String, description: String, descriptionIsClickable: Bool) {
        self.title = title
        self.description = description
        self.descriptionIsClickable = descriptionIsClickable
    }
}
