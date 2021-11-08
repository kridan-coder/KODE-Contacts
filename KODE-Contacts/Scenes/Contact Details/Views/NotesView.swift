//
//  ContactCreateRedactPartView3.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit
import SnapKit

final class NotesView: EditingInfoViewWithTextView {
    // MARK: - Properties
    private var viewModel: ContactNotesViewModel?
    
    // MARK: - Additional setup
    override func additionalSetup() {
        additionallInitalizeDescriptionTextViewUI()
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: ContactNotesViewModel) {
        self.viewModel = viewModel
        setupData()
    }
    
    // MARK: - Private Methods
    private func setupData() {
        titleLabel.text = viewModel?.data.titleLabelText
        guard let text = viewModel?.data.textFieldText else {
            descriptionTextView.placeholder = viewModel?.data.textFieldPlaceholder
            return
        }
        descriptionTextView.text = text
    }
    
    private func setupCorrectDescriptionTextViewHeight() {
        // TODO: - The following code does not work as expected. Need to make height correct when there is a text initially.
        descriptionTextView.text = viewModel?.data.textFieldText
        descriptionTextView.textContainer.maximumNumberOfLines = 5
        descriptionTextView.setupScrollAppearance()
        descriptionTextView.sizeToFit()
        descriptionTextView.textContainer.maximumNumberOfLines = 0
    }
    
    private func additionallInitalizeDescriptionTextViewUI() {
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.delegate = self
        descriptionTextView.returnKeyType = .done
    }
    
}

// MARK: - UITextFieldDelegate
extension NotesView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        descriptionTextView.setupScrollAppearance()
        let updatedText = descriptionTextView.text?.updatedText(replacementString: text,
                                                                replacementRange: range) ?? ""
        
        guard updatedText.count <= Constants.maxCharacterCount else { return false }
        
        updateViewModelData(currentTextView: textView, updatedText: updatedText)
        return true
    }
    
    // Helpers
    private func updateViewModelData(currentTextView: UITextView, updatedText: String) {
        viewModel?.data.textFieldText = updatedText
        viewModel?.didUpdateData?()
    }
    
}

// MARK: - Constants
private extension Constants {
    static let maxCharacterCount = 512
    
}
