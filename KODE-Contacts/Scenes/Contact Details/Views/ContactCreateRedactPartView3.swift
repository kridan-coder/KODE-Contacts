//
//  ContactCreateRedactPartView3.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit
import SnapKit

final class ContactCreateRedactPartView3: DefaultCellView {
    override func initalizeDescriptionTextViewUI() {
        super.initalizeDescriptionTextViewUI()
        descriptionTextField.isUserInteractionEnabled = true
        // TODO: - Get rid of test code
        descriptionTextField.text = "Wake up, Neo..."
        titleLabel.text = "Notes"
    }
    
}
