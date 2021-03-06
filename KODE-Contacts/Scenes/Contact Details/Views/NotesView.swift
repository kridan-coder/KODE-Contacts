//
//  NotesView.swift
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
        descriptionTextView.setupScrollAppearance()
    }
    
    private func additionallInitalizeDescriptionTextViewUI() {
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.delegate = self
        descriptionTextView.flexibleDelegate = self
        descriptionTextView.returnKeyType = .done
    }
    
}

// MARK: - FlexibleTextViewDelegate
extension NotesView: FlexibleTextViewDelegate {
    func flexibleTextView(_ flexibleTextView: FlexibleTextView, setScrollEnabled: Bool) {
        if setScrollEnabled {
            viewModel?.adjustViewToTextViewWithEnabledScroll()
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension NotesView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == R.string.localizable.wakeUpNeo() {
            textView.text = nil
        }
        viewModel?.didBecomeActiveTextInputField?(textView)
        viewModel?.adjustViewToTextViewWithEnabledScroll()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = R.string.localizable.wakeUpNeo()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            viewModel?.textInputFieldDidAskToFocusNext?(textView)
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
