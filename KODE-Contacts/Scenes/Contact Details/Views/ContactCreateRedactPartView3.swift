//
//  ContactCreateRedactPartView3.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit
import SnapKit

final class ContactCreateRedactPartView3: DefaultViewCell {
    // MARK: - Properties
    private var viewModel: ContactCreateRedactPartViewModel3?
    
    override func initalizeDescriptionTextViewUI() {
        super.initalizeDescriptionTextViewUI()
        descriptionTextField.isUserInteractionEnabled = true
        descriptionTextField.delegate = self
        descriptionTextField.returnKeyType = .done
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
        
            guard updatedText.count <= 18 else { return false }
        
            updateViewModelData(currentTextField: textField, updatedText: updatedText)
            return true
    }
    
    // Helpers
    private func updateViewModelData(currentTextField: UITextField, updatedText: String) {
        viewModel?.data.textFieldText = updatedText
    }
    
}
