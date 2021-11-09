//
//  ContactCellViewModel.swift
//  KODE-Contacts
//
//  Created by Developer on 21.10.2021.
//

import UIKit

class CellViewModel: ContactCellViewModel {
    // MARK: - Properties
    var didUpdateData: (() -> Void)?
    
    var contact: Contact {
        didSet {
            didUpdateData?()
        }
    }
    
    lazy var attributedString: NSAttributedString = {
        let textRange = (contact.fullName as NSString).range(of: contact.lastName ?? contact.name, options: [.backwards])
        let attributedString = NSMutableAttributedString(string: contact.fullName,
                                                         attributes: [NSAttributedString.Key.font: UIFont.contactName])
        
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.contactLastName], range: textRange)
        return attributedString
    }()
    
    // MARK: - Init
    init(contact: Contact) {
        self.contact = contact
    }
    
    // MARK: - Public Methods
    @objc func sortSelector() -> String {
        contact.lastName ?? contact.name
    }
    
}
