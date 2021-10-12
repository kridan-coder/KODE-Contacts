//
//  ContactCreateRedactPartView1.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

class ContactCreateRedactPartView1: UIView {

    // MARK: - Properties
    
    private let contactImageView = UIImageView()
    
    private let nameTextField: UITextField = .emptyTextField
    private let lastNameTextField: UITextField = .emptyTextField
    private let phoneNumberTextField: UITextField = .emptyTextField
    
    // MARK: - Init
    init() {

        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle


}
