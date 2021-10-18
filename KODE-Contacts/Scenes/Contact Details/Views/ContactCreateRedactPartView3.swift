//
//  ContactCreateRedactPartView3.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit
import SnapKit

final class ContactCreateRedactPartView3: DefaultCellView {
    // MARK: - Properties
    private var viewModel: ContactCreateRedactPartViewModel3?
    
    override func initalizeDescriptionTextViewUI() {
        super.initalizeDescriptionTextViewUI()
        descriptionTextField.isUserInteractionEnabled = true
        descriptionTextField.delegate = self
    }
    
    // MARK: - Public Methods
    
    func configure(with viewModel: ContactCreateRedactPartViewModel3) {
        self.viewModel = viewModel
        setupData()
        self.viewModel?.didReloadData = {
            self.setupData()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupData() {
        titleLabel.text = viewModel?.data.titleLabelText
        descriptionTextField.placeholder = viewModel?.data.textFieldPlaceholder
        descriptionTextField.text = viewModel?.data.textFieldText
    }
    
}

// MARK: - UITextFieldDelegate
extension ContactCreateRedactPartView3: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard UITextField.updatedTextIsValid(currentText: textField.text ?? "",
                                             replacementString: string,
                                             replacementRange: range,
                                             limit: 255) else { return false }
        updateViewModelData(with: textField)
        return true
    }
    
    // Helpers
    private func updateViewModelData(with textField: UITextField) {
        viewModel?.data.textFieldText = textField.text
    }
}
