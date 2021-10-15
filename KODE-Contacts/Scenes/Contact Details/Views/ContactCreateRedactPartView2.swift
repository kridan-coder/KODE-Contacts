//
//  ContactCreateRedactPartView2.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit
import SnapKit
import TPKeyboardAvoiding

final class ContactCreateRedactPartView2: DefaultCellView {
    // MARK: - Properties
    private var viewModel: ContactCreateRedactPartViewModel2?
    
    private let trailingImageView = UIImageView()
    private let pickerView = UIPickerView()
    private let toolbar = CustomToolbar(frame: CGRect.zero)
    
    override init() {
        super.init()
        setupToolbar()
        setupPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    private func setupToolbar() {
        toolbar.buttonsDelegate = self
    }
    
    private func setupPicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    // UI
    override func initializeUI() {
        super.initializeUI()
        initalizeArrowImageViewUI()
        // TODO: - Get rid of test code
        descriptionTextField.text = "Default"
        titleLabel.text = "Ringtone"
    }
    
    override func initalizeDescriptionTextViewUI() {
        super.initalizeDescriptionTextViewUI()
        descriptionTextField.isUserInteractionEnabled = true
        descriptionTextField.inputView = pickerView
        descriptionTextField.inputAccessoryView = toolbar
    }
    
    private func initalizeArrowImageViewUI() {
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.image = .arrowImage
    }
    
    // Constraints
    override func createConstraints() {
        super.createConstraints()
        addSubview(trailingImageView)
        createConstraintsForArrowImageView()
    }
    
    private func createConstraintsForArrowImageView() {
        trailingImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.TrailingImageView.insetTrailing)
            make.centerY.equalToSuperview().offset(Constants.TrailingImageView.centerYOffset)
            make.width.equalTo(trailingImageView.snp.height)
            make.height.equalToSuperview().dividedBy(Constants.TrailingImageView.superViewRatio)
        }
    }
    
}

// MARK: - ToolbarPickerViewDelegate
extension ContactCreateRedactPartView2: ToolbarPickerViewDelegate {
    func didTapFirstButton() {
        viewModel?.didAskToFocusNextTextField?()
    }
    
    func didTapSecondButton() {
        descriptionTextField.resignFirstResponder()
    }
}

// MARK: - UIPickerViewDataSource
extension ContactCreateRedactPartView2: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 10
        } else {
            return 100
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "First \(row)"
        } else {
            return "Second \(row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}

// MARK: - UIPickerViewDelegate
extension ContactCreateRedactPartView2: UIPickerViewDelegate {}

// MARK: - Constants
private extension Constants {
    struct TrailingImageView {
        static let insetTrailing = CGFloat(20)
        static let centerYOffset = CGFloat(5)
        static let superViewRatio = CGFloat(3.3)
    }
    
}
