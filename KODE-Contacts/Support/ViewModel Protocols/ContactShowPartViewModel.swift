//
//  ContactShowPartViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import Foundation

protocol ContactShowPartViewModel {
    var title: String { get }
    var description: String { get }
    var descriptionHasLink: Bool { get }
    func openLink()
    
}
