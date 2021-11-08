//
//  ContactCreateRedactPartView2.swift
//  KODE-Contacts
//
//  Created by Developer on 14.10.2021.
//

import UIKit
import TPKeyboardAvoiding

final class RingtoneView: EditingInfoViewWithTextField {
    // MARK: - Properties
    let trailingImageView = UIImageView()
    let pickerView = UIPickerView()
    let toolbar = CustomToolbar(frame: CGRect.zero)
    
    private var viewModel: ContactRingtoneViewModel?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Additional setup
    override func additionalSetup() {
        initalizeTrailingImageViewUI()
        initializePickerViewUI()
        additionallyInitalizeDescriptionTextViewUI()
        additionallyCreateConstraints()
    }
    
    // MARK: - Public Methods
    func configure(with viewModel: ContactRingtoneViewModel) {
        self.viewModel = viewModel
        setupData()
    }
    
    // MARK: - Private Methods
    private func setupData() {
        guard let viewModel = viewModel else { return }
        descriptionTextField.text = viewModel.data.pickedRingtone.localizedString
        titleLabel.text = viewModel.data.titleLabelText
        pickerView.selectRow(viewModel.data.pickerViewDataSet.firstIndex(of: viewModel.data.pickedRingtone) ?? 0,
                             inComponent: 0,
                             animated: false)
        pickerView.reloadAllComponents()
    }
    
    private func setup() {
        setupToolbar()
        setupPicker()
    }
    
    private func setupToolbar() {
        toolbar.buttonsDelegate = self
    }
    
    private func setupPicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    // UI
    private func additionallyInitalizeDescriptionTextViewUI() {
        descriptionTextField.isUserInteractionEnabled = true
        descriptionTextField.inputView = pickerView
        descriptionTextField.inputAccessoryView = toolbar
        descriptionTextField.delegate = self
    }
    
    private func initializePickerViewUI() {
        pickerView.backgroundColor = .white
    }
    
    private func initalizeTrailingImageViewUI() {
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.image = R.image.arrow()
    }
    
    // Constraints
    private func additionallyCreateConstraints() {
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
extension RingtoneView: CustomToolbarDelegate {
    func customToolbarDidChooseFirstOption(_ customToolbar: CustomToolbar) {
        viewModel?.didAskToFocusNextTextField?()
    }
    
    func customToolbarDidChooseSecondOption(_ customToolbar: CustomToolbar) {
        descriptionTextField.resignFirstResponder()
    }
    
}

// MARK: - UIPickerViewDataSource
extension RingtoneView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel?.data.pickerViewDataSet.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel?.data.pickerViewDataSet[row].localizedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let pickedRingtone = viewModel?.data.pickerViewDataSet[row] {
            descriptionTextField.text = pickedRingtone.localizedString
            viewModel?.data.pickedRingtone = pickedRingtone
            viewModel?.didUpdateData?()
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension RingtoneView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
    
}

// MARK: - UIPickerViewDelegate
extension RingtoneView: UIPickerViewDelegate {}

// MARK: - Constants
private extension Constants {
    struct TrailingImageView {
        static let insetTrailing = CGFloat(20)
        static let centerYOffset = CGFloat(5)
        static let superViewRatio = CGFloat(4)
    }
    
}
