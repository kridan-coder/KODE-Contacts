//
//  ContactCreateRedactPartView3.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit
import SnapKit

final class ContactCreateRedactPartView3: DefaultRedactViewCell {
    // MARK: - Properties
    private var viewModel: ContactCreateRedactPartViewModel3?
    
    // MARK: - Additional setup
    override func additionalSetup() {
        additionallynitalizeDescriptionTextViewUI()
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: ContactCreateRedactPartViewModel3) {
        self.viewModel = viewModel
        setupData()
        self.viewModel?.didUpdateData = {
            self.setupData()
        }
    }
    
    // MARK: - Private Methods
    private func setupData() {
        titleLabel.text = viewModel?.data.titleLabelText
        descriptionTextField.placeholder = viewModel?.data.textFieldPlaceholder
        descriptionTextField.text = viewModel?.data.textFieldText
    }
    
    private func additionallynitalizeDescriptionTextViewUI() {
        descriptionTextField.isUserInteractionEnabled = true
        descriptionTextField.delegate = self
        descriptionTextField.returnKeyType = .done
    }
    
}

// MARK: - UITextFieldDelegate
extension ContactCreateRedactPartView3: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = UITextField.updatedText(currentText: textField.text,
                                                  replacementString: string,
                                                  replacementRange: range) ?? ""
        
        guard updatedText.count <= Constants.maxCharacterCount else { return false }
        
        updateViewModelData(currentTextField: textField, updatedText: updatedText)
        return true
    }
    
    // Helpers
    private func updateViewModelData(currentTextField: UITextField, updatedText: String) {
        viewModel?.data.textFieldText = updatedText
    }
    
}

// MARK: - Constants
private extension Constants {
    static let maxCharacterCount = 100
    
}
