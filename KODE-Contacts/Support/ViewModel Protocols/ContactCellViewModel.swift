//
//  ContactCellViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 08.11.2021.
//

import Foundation

protocol ContactCellViewModel: ViewModelEditable {
    var attributedString: NSAttributedString { get }
}
