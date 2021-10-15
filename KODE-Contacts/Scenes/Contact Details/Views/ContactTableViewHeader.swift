//
//  ContactTableViewHeader.swift
//  KODE-Contacts
//
//  Created by Developer on 12.10.2021.
//

import UIKit

class ContactTableViewHeader: UIView {
    // MARK: - Properties
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func initializeUI() {
    }
    
    private func createConstraints() {
    }
}
